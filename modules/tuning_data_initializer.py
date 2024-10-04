
import pandas as pd
from sqlalchemy import text
from sqlalchemy_utils import database_exists, create_database

from agent.vectorstores import KnowledgeBaseRetriever
from config.common import *
from config.knob_list import KNOBS
from utils import embedding_columns


def load_history_tasks(sqls_in_all_history_data):
    with open(history_task_file_path, 'r') as history_task_file:
        history_tasks = history_task_file.read().splitlines()
        # 取交集，万一历史数据里面漏了几条SQL，不会报错
        history_tasks = set(history_tasks) & set(sqls_in_all_history_data)

    return list(history_tasks)


def init_tuning_data(filepath=all_history_data_file_path, clear_content=False):
    if not database_exists(db_url):
        create_database(db_url)

    retriever = KnowledgeBaseRetriever()
    with retriever.session() as db_session:
        db_session.execute(text(f"DROP TABLE IF EXISTS {tb_task_embeddings};"))
        db_session.execute(text(f"DROP TABLE IF EXISTS {tb_task_best_config};"))
        db_session.execute(text(f"DROP TABLE IF EXISTS {tb_matched_history_tasks};"))
        db_session.execute(text(f"DROP TABLE IF EXISTS {tb_task_history};"))

        all_history_data = pd.read_csv(filepath, index_col='task_id')

        history_tasks = load_history_tasks(all_history_data.index.unique().tolist())
        history_data = all_history_data.loc[history_tasks]

        history_data.reset_index(inplace=True)

        # task_embedding table
        embeddings = history_data[['task_id', 'sql'] + embedding_columns]
        embeddings = embeddings.drop_duplicates(subset=['task_id'], keep='first')
        pd.io.sql.to_sql(embeddings, tb_task_embeddings, con=db_session.bind, if_exists='append', index=False)
        del embeddings

        # history_data table
        history_data = history_data[['app_id', 'task_id'] + KNOBS + embedding_columns + ['status', 'duration']]
        history_data['duration'] = history_data['duration'].astype('int64')
        pd.io.sql.to_sql(history_data, tb_task_history, con=db_session.bind, if_exists='append', index=False)
        
        # task_best_config
        best_config_data = history_data.groupby('task_id', as_index=False).apply(lambda t: t[(t.duration == t.duration.min()) & (t.duration != 3600000)].sample(1))
        best_config_data = best_config_data[['task_id'] + KNOBS + ['duration']]
        pd.io.sql.to_sql(best_config_data, tb_task_best_config, con=db_session.bind, if_exists='append', index=False)
        del best_config_data

        # matched_history_tasks
        matched_history_tasks = pd.DataFrame(columns=['history_task_id', 'new_task_id'])
        pd.io.sql.to_sql(matched_history_tasks, tb_matched_history_tasks, con=db_session.bind, if_exists='append', index=False)
        del matched_history_tasks

        if clear_content:
            db_session.execute(text('DELETE FROM task_embeddings'))
            db_session.execute(text('DELETE FROM task_history'))
            db_session.execute(text('DELETE FROM task_best_config'))
            db_session.execute(text('DELETE FROM matched_history_tasks'))
            db_session.commit()
            print('Finish creating tables.')
        else:
            print('Finish initializing tuning data.')