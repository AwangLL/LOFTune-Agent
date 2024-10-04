import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import argparse
import random
from itertools import combinations

import pandas as pd

from config.common import *
from config.knob_list import KNOBS, KNOB_DETAILS, KnobType
from utils import normalize_sql, gen_task_embedding

# TODO: raw_history_data 不包含sql语句，生成的初步 history_data 中只包含
# app_id, task_id, duration, status, <config>


# TODO: process-logs

def select_single_sql_history():
    raw_history = pd.read_csv(raw_history_data_file_path, index_col=None)
    raw_history.rename(columns={'app_name': 'task_id'}, inplace=True)
    raw_history['task_id'] = raw_history['task_id'].apply(lambda name: name.split('#')[0])
    sampled_history = raw_history.groupby('task_id', as_index=False).apply(lambda group: group.sample(25))
    sampled_history.to_csv(all_history_data_file_path, index=False)


def get_valid_tasks(task_dict):
    # task_dict: {task_id_1: [config_id_1, config_id_2, ...], task_id_2: [], ...}
    lower_bound = 25
    tuples = {}
    valid_task_dict = {task_id: config_ids for task_id, config_ids in task_dict.items() if len(set(config_ids)) >= lower_bound}
    four_tuples = list(combinations(valid_task_dict.keys(), 4))
    valid_tuples = 0
    for four_tuple in four_tuples:
        common_config_ids = set(valid_task_dict[four_tuple[0]])
        for task_id in four_tuple[1:]:
            common_config_ids = common_config_ids.intersection(set(valid_task_dict[task_id]))
        if len(common_config_ids) >= lower_bound:
            valid_tuples += 1
            tuples[four_tuple] = common_config_ids
            # print(f'Four tuple: {four_tuple}, Common Config ID: {common_config_ids}, Count: {len(common_config_ids)}')
    return tuples

def select_multi_sql_history():
    raw_history = pd.read_csv(raw_history_data_file_path, index_col='app_id')
    raw_history.rename(columns={'app_name': 'task_id'}, inplace=True)

    split_cols = raw_history['task_id'].str.split('#')
    raw_history['task_id'], raw_history['config_id'] = split_cols.str[0], split_cols.str[2]
    raw_history['config_id'] = raw_history['config_id'].apply(lambda name: name.split('_')[0])

    # 生成task_dist
    task_dict = {}
    for index, row in raw_history.iterrows():
        task_id = row['task_id']
        config_id = row['config_id']
        if task_id not in task_dict.keys():
            task_dict[task_id] = []
        task_dict[task_id].append(config_id)

    tasks = get_valid_tasks(task_dict)

    # 先随机选30个tuple
    sampled_tasks = random.sample(tasks.keys(), 30)

    # 从这30个tuple中随机选25条配置
    # 然后组合形成新的all_history_data
    all_records = []
    for task in sampled_tasks:
        sampled_config_ids = random.sample(tasks[task], 25)
        sorted_task = sorted(task)
        task_id_str = '_'.join(sorted_task)
        for config_id in sampled_config_ids:
            values = raw_history.query(f"config_id == '{config_id}'").head(1)[KNOBS].values[0]
            app_idx = []
            total_duration = 0
            for sql in task:
                query_result = raw_history.query(f"task_id == '{sql}' and config_id == '{config_id}'")
                app_idx.append(query_result.index.values[0])
                total_duration += query_result['duration'].values[0]
            app_id_str = '/'.join(sorted(app_idx))
            record = {'app_id': app_id_str, 'task_id': task_id_str, 'duration': total_duration, 'status': True}

            type_calibrated_config = {}
            for name, value in zip(KNOBS, values):
                knob_type = KNOB_DETAILS[name]['type']
                if knob_type == KnobType.INTEGER:
                    type_calibrated_config[name] = int(value)
                elif knob_type == KnobType.NUMERIC:
                    type_calibrated_config[name] = float(value)
                else:
                    type_calibrated_config[name] = int(value)  # CATEGORICAL, 是索引
            record.update(type_calibrated_config)
            all_records.append(record)

    sampled_history = pd.DataFrame(all_records)
    sampled_history.to_csv(all_history_data_file_path, index=False)


def to_our_history_data():
    all_history_data = pd.read_csv(all_history_data_file_path, index_col=None)
    # convert status
    all_history_data['status'] = all_history_data['status'].apply(lambda status: 1 if status else 0)
    # generate sql
    embeddings = {}
    workload_sql_path = os.path.join(sql_base_path, workload.lower())
    for filename in os.listdir(workload_sql_path):
        filepath = os.path.join(workload_sql_path, filename)
        with open(filepath, 'r') as fp:
            sql = normalize_sql(fp.read())
            task_id = filename.removesuffix('.sql')
            embeddings[task_id] = gen_task_embedding(query=sql)
            embeddings[task_id].pop('task_id')

    new_all_history_data = []
    for _, row in all_history_data.iterrows():
        task_id = row['task_id']
        row = row.to_dict()
        row.update(embeddings[task_id])
        new_all_history_data.append(row)
    new_all_history_data = pd.DataFrame(new_all_history_data)
    new_all_history_data.to_csv(all_history_data_file_path, index=False)

# 1. run `python script/history_data_organizer.py process-logs` to generate raw_history_data.csv
# 2. run `python script/history_data_organizer.py select-history` to generate *_history_data.csv
# 3. run `python script/history_data_organizer.py convert-history` to futher convert *_history_data.csv to what we want (also *_history_data.csv)
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--type', type=str, default='',
                        choices=['process-logs', 'select-history', 'convert-history'])
    args = parser.parse_args()

    if not os.path.exists(data_path):
        os.makedirs(data_path)

    if args['type'] == 'process-logs':
        raise NotImplementedError
    elif args['type'] == 'select-history':
        if mode == 'single':
            select_single_sql_history()
        elif mode == 'multi':
            select_multi_sql_history()
    elif args['type'] == 'convert-history':
        to_our_history_data()

