import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import argparse

from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, scoped_session
from sqlalchemy_utils import database_exists, create_database

from config.common import *
from config.encoder_config import sql_embedding_dim


def setup_mysql():
    if not database_exists(db_url):
        create_database(db_url)

    engine = create_engine(db_url)
    session = scoped_session(sessionmaker(autocommit=False, autoflush=False, bind=engine))
    
    with session() as db_session:
        create_table_query = f"""
CREATE TABLE {tb_task_embeddings} (
    `task_id` TEXT,
    `sql` TEXT,
""" + ",\n".join([f"    `task_embedding_{i}` DOUBLE" for i in range(sql_embedding_dim)]) + """
);"""
        db_session.execute(text(f"DROP TABLE IF EXISTS {tb_task_embeddings};"))
        db_session.execute(text(create_table_query))
        
        create_table_query = f"""
CREATE TABLE {tb_task_best_config} (
    `task_id` TEXT,
    `spark.broadcast.blockSize` BIGINT,
    `spark.broadcast.compress` BIGINT,
    `spark.default.parallelism` BIGINT,
    `spark.driver.cores` BIGINT,
    `spark.driver.memory` BIGINT,
    `spark.executor.cores` BIGINT,
    `spark.executor.instances` BIGINT,
    `spark.executor.memory` BIGINT,
    `spark.executor.memoryOverhead` BIGINT,
    `spark.io.compression.codec` BIGINT,
    `spark.locality.wait` BIGINT,
    `spark.memory.fraction` DOUBLE,
    `spark.memory.offHeap.size` BIGINT,
    `spark.memory.storageFraction` DOUBLE,
    `spark.rdd.compress` BIGINT,
    `spark.reducer.maxSizeInFlight` BIGINT,
    `spark.shuffle.file.buffer` BIGINT,
    `spark.sql.autoBroadcastJoinThreshold` BIGINT,
    `spark.sql.inMemoryColumnarStorage.batchSize` BIGINT,
    `spark.sql.join.preferSortMergeJoin` BIGINT,
    `spark.sql.shuffle.partitions` BIGINT,
    `spark.storage.memoryMapThreshold` BIGINT,
    `duration` BIGINT
);"""
        db_session.execute(text(f"DROP TABLE IF EXISTS {tb_task_best_config};"))
        db_session.execute(text(create_table_query))

        create_table_query = f"""
CREATE TABLE {tb_task_history} (
    `app_id` TEXT,
    `task_id` TEXT,
    `spark.broadcast.blockSize` BIGINT,
    `spark.broadcast.compress` BIGINT,
    `spark.default.parallelism` BIGINT,
    `spark.driver.cores` BIGINT,
    `spark.driver.memory` BIGINT,
    `spark.executor.cores` BIGINT,
    `spark.executor.instances` BIGINT,
    `spark.executor.memory` BIGINT,
    `spark.executor.memoryOverhead` BIGINT,
    `spark.io.compression.codec` BIGINT,
    `spark.locality.wait` BIGINT,
    `spark.memory.fraction` DOUBLE,
    `spark.memory.offHeap.size` BIGINT,
    `spark.memory.storageFraction` DOUBLE,
    `spark.rdd.compress` BIGINT,
    `spark.reducer.maxSizeInFlight` BIGINT,
    `spark.shuffle.file.buffer` BIGINT,
    `spark.sql.autoBroadcastJoinThreshold` BIGINT,
    `spark.sql.inMemoryColumnarStorage.batchSize` BIGINT,
    `spark.sql.join.preferSortMergeJoin` BIGINT,
    `spark.sql.shuffle.partitions` BIGINT,
    `spark.storage.memoryMapThreshold` BIGINT,
""" + ",\n".join([f"    `task_embedding_{i}` DOUBLE" for i in range(sql_embedding_dim)]) + """,
    `status` BIGINT,
    `duration` BIGINT
);"""
        db_session.execute(text(f"DROP TABLE IF EXISTS {tb_task_history};"))
        db_session.execute(text(create_table_query))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    args = parser.parse_args()


    setup_mysql()