from typing import Annotated, Literal


workload: Literal['TPCDS', 'TPCH', 'IMDB'] = 'IMDB'
data_size: int = 10
mode: Literal['single', 'multi'] = 'single'
encoding_model: Literal['tbcnn', 'bert'] = 'bert'
task_suffix = ''

hdfs_path = 'http://10.214.151.183:9870'
event_log_hdfs_path = '/home/yjh/spark_tune/environment/spark-3.2.4/log'

alpha: float = 0.1
rate_tradeoff: float = 0.4

db_host: str = 'localhost'
db_port: str = '3306'
db_username: str = 'root'
db_password: str = '123456'

simulator = True