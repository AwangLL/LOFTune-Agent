import logging
from typing import Any, List, Optional
from copy import deepcopy

import pandas as pd
from sqlalchemy import create_engine, text, Table, MetaData
from sqlalchemy.engine import result
from sqlalchemy.orm import sessionmaker, scoped_session

from config.common import *
from config.encoder_config import *
from sql_encoder.encoder import encode_sql
from utils import clear_scale_dict, gen_task_embedding


class KnowledgeBaseRetriever():
    def __init__(self, session: Optional[Any] = None):
        if session is None:
            engine = create_engine(db_url)
            self.session = scoped_session(sessionmaker(autocommit=False, autoflush=False, bind=engine))
        else:
            self.session = session

    def similarity_search(self, task_embedding, k: int = 1) -> result.MappingResult:
        with self.session() as db_session:
            sim_str = ''
            for i in range(0, sql_embedding_dim):
                sim_str += f"{task_embedding[f'task_embedding_{i}']} * task_embedding_{i} + "
            sim_str = sim_str[:-3]

            results = db_session.execute(
                text(f"SELECT task_id, `sql`, {sim_str} AS sim FROM task_embeddings ORDER BY sim DESC LIMIT {k};")
            )
            return results.mappings().fetchall()
    
    def fetch_task_embedding(self, task_id: str) -> dict:
        task_embedding = pd.read_sql(
            text(f"SELECT * FROM {tb_task_embeddings} WHERE task_id='{task_id}'"),
            con=self.session.bind, index_col='task_id'
        )
        return task_embedding.iloc[0].to_dict()

    def fetch_best_config(self, task_id: str) -> dict | None:
        with self.session() as db_session:
            results = db_session.execute(
                text(f"SELECT * FROM {tb_task_best_config} WHERE task_id=:task_id"),
                {'task_id': task_id}
            )
            config = results.mappings().first()
            if config is None:
                return None
            return dict(config)
            config = dict(config)
            config.pop('task_id')
            config.pop('duration')
            return config
    
    def fetch_all_task_history(self) -> pd.DataFrame:
        return pd.read_sql(text(f"SELECT * FROM {tb_task_history}"), self.session.bind)
    
    def add_task_embedding(self, task_embeddings: list) -> None:
        with self.session() as db_session:
            metadata = MetaData()
            table = Table(tb_task_embeddings, metadata, autoload_with=db_session.bind)
            for data in task_embeddings:
                result = db_session.execute(
                    text(f"SELECT COUNT(*) FROM {tb_task_embeddings} AS t WHERE t.task_id=:task_id;"),
                    {'task_id': data['task_id']}
                )
                if result.first()[0] == 0:
                    db_session.execute(table.insert(), data)
                else:
                    db_session.execute(
                        table.update().where(table.c.task_id == data['task_id']),
                        data
                    )
            db_session.commit()

    def update_task_best_config(self, app_id, task_id, config, duration) -> None:
        logger = logging.getLogger("retriever")
        with self.session() as db_session:
            data = {'app_id': app_id, 'task_id': task_id, 'duration': duration, 'status': 1}
            data.update(clear_scale_dict(config))

            # add embedding to data
            task_embedding = pd.read_sql(
                text(f"SELECT * FROM {tb_task_embeddings} WHERE task_id='{task_id}'"),
                con=db_session.bind, index_col='task_id'
            )
            if task_embedding.empty:
                task_embedding = gen_task_embedding(task_id=task_id)
                self.add_task_embedding([task_embedding])
            else:
                task_embedding = task_embedding.iloc[0].to_dict()
            data.update(task_embedding)

            # save history data into database table task_history
            self.add_task_history(data)
            
            # fetch best config from database table task_best_config
            best_config = self.fetch_best_config(task_id)

            # compare the best config and current config
            if best_config is not None and best_config['duration'] < data['duration']:
                data.update(best_config)

            # save best config into database table task_best_config
            metadata = MetaData()
            table = Table(tb_task_best_config, metadata, autoload_with=db_session.bind)
            result = db_session.execute(
                text(f"SELECT COUNT(*) FROM {tb_task_best_config} AS t WHERE t.task_id=:task_id;"),
                {'task_id': data['task_id']}
            )
            if result.first()[0] == 0:
                db_session.execute(table.insert(), data)
            db_session.execute(
                table.update().where(table.c.task_id == data['task_id']),
                data
            )
            db_session.commit()

            if int(data['duration']) < duration:
                logger.info(f"Update data for task {task_id} finishes. Previous best time = {duration} ms, "
                            f"update to {int(data['duration'])} ms.")
            else:
                logger.info(f"Update data for task {task_id} finishes. Previous best time = {duration} ms, keep unchanged.")
    
    def add_task_history(self, history_data: dict) -> None:
        if 'sql' in history_data:
            history_data.pop('sql')
        pd.io.sql.to_sql(
            pd.DataFrame([history_data]), tb_task_history,
            con=self.session.bind, if_exists='append', index=False
        )
    
    def add_task_matched_history(self, history_task_id: str, new_task_id: str) -> None:
        row = {"history_task_id": history_task_id, "new_task_id": new_task_id}
        pd.io.sql.to_sql(
            pd.DataFrame([row]), tb_matched_history_tasks,
            con=self.session.bind, if_exists='append', index=False
        )