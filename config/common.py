import os
from config.config import *

cwd = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

sql_base_path = f"{cwd}/data/optimized-sqls"
config_path = f"{os.getenv('SPARK_HOME')}/benchmarks/conf"

data_path = f"{cwd}/data/{workload}_{data_size}G_{mode}"
raw_history_data_file_path = f"{data_path}/raw_history_data.csv"
all_history_data_file_path = f"{data_path}/bert_history_data.csv" if encoding_model == 'bert' else f"{data_path}/all_history_data.csv"
new_task_file_path = f"{data_path}/new_tasks{task_suffix}"  # 存储用于测试的新任务id
history_task_file_path = f"{data_path}/history_tasks{task_suffix}"  # 存储用于测试的历史任务id
tuneful_mapping_file_path = f"{data_path}/tuneful_mapping.json"
rover_mapping_file_path = f"{data_path}/rover_mapping.json"

db_name = f"{workload}_{data_size}G_{mode}_loftune"
db_url = f"mysql+pymysql://{db_username}:{db_password}@{db_host}:{db_port}/{db_name}?charset=utf8"
tb_task_best_config = 'task_best_config'
tb_task_embeddings = 'task_embeddings'
tb_task_history = 'task_history'
tb_matched_history_tasks = 'matched_history_tasks'