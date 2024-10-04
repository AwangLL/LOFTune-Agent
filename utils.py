import re
import copy
import hashlib
import json
from typing import Optional

import torch
import sqlparse
import numpy as np
from hdfs import Client

from config.common import *
from config.encoder_config import *
from config.knob_list import*
from sql_encoder.encoder import encode_sql


find_number = lambda x: re.search('\d+(\.\d+)?', x).group()
embedding_columns = [f"task_embedding_{_}" for _ in range(0, sql_embedding_dim)]


def normalize_sql(sql: str):
    parsed = sqlparse.format(sql, reindent=True, keyword_case='upper')
    normalized_sql = ' '.join(parsed.split())
    suffix = ';' if normalized_sql[-1] != ';' else ''
    return normalized_sql + suffix

def gen_task_id(sql: str):
    normalized_sql = normalize_sql(sql)
    sql_hash = hashlib.md5(normalized_sql.encode('utf-8')).hexdigest()
    return sql_hash[:8]

def gen_task_embedding(query: Optional[str]=None, task_id: Optional[str]=None):
    if query is None and task_id is None:
        raise ValueError('Please provide query or key_id.')
    
    sql_embeddings = []
    if task_id is not None:
        query = ''
        sqls = task_id.split('_')
        for sql_id in sqls:
            with open(f"{sql_base_path}/{workload.lower()}/{sql_id}.sql") as fp:
                sql = normalize_sql(fp.read())
                sql_embeddings.append(encode_sql(sql))
                query += sql
    elif query is not None:
        task_id = ''
        querys = query.split(';')
        for sql in querys:
            if sql == '': continue
            sql = normalize_sql(sql)
            sql_embeddings.append(encode_sql(sql))
            task_id += gen_task_id(sql)
            task_id += '_'
        task_id = task_id[:-1]

    # normalization
    sql_embeddings = torch.tensor(sql_embeddings)
    sql_embedding = torch.max(sql_embeddings, dim=0)[0].tolist()
    norm = np.linalg.norm(sql_embedding)
    sql_embedding = list(map(lambda x: x / norm, sql_embedding))

    data = {'task_id': task_id, 'sql': query}
    data.update({f"task_embedding_{i}": sql_embedding[i] for i in range(0, sql_embedding_dim)})
    return data

def add_scale_dict(origin_dict):
    """ add scale('k','m','g',...) to dict """
    new_dict = copy.deepcopy(origin_dict)
    for knob, details in KNOB_DETAILS.items():
        if knob not in new_dict.keys():
            continue
        if details['type'] == KnobType.CATEGORICAL:
            new_dict[knob] = details['candidates'][origin_dict[knob]]
        elif 'unit' in details.keys():
            new_dict[knob] = str(origin_dict[knob]) + details['unit']
    return new_dict

def clear_scale_dict(origin_dict):
    """ remove scale('k','m','g',...) from dict """
    for key, value in origin_dict.items():
        val_type = KNOB_DETAILS[key]['type']
        if val_type == KnobType.INTEGER and isinstance(value, str):
            origin_dict[key] = int(find_number(value))
        elif val_type == KnobType.NUMERIC and isinstance(value, str):
            origin_dict[key] = float(find_number(value))
        elif val_type == KnobType.CATEGORICAL:
            candidates = KNOB_DETAILS[key]['candidates']
            index = candidates.index(value)
            origin_dict[key] = index
            # origin_dict[key] = 1 if value == 'true' else 0
    return origin_dict

def load_event_log_content(app_idx):
    app_id_list = app_idx.split('/')
    client = Client(hdfs_path)
    lines_of_all_apps = []
    for app_id in app_id_list:
        lines = []
        if EXTRA_KNOBS['spark.submit.deployMode'] == 'client':
            file_name = f"{event_log_hdfs_path}/{app_id}"
        else:
            file_name = f"{event_log_hdfs_path}/{app_id}_1"
        
        with client.read(file_name, encoding='utf-8', delimiter='\n') as event_log_file:
            for line in event_log_file:
                lines.append(line)
        lines_of_all_apps.append(lines)

def load_info_from_lines(lines_of_apps):
    run_time_of_apps = []
    status_of_apps = []
    for lines in lines_of_apps:
        start_time = np.inf
        finish_time = -1

        succeed_job_count = 0
        failed_jon_count = 0
        
        for line in lines:
            if line == '':
                continue
            event = json.loads(line)
            event_type = event['Event']
            if event_type == 'SparkListenerJobStart':
                if event['Submission Time'] < start_time:
                    start_time = event['Submission Time']
            elif event_type == 'SparkListenerJobEnd':
                if event['Completion Time'] > finish_time:
                    finish_time = event['Completion Time']
                job_status = event['Job Result']['Result']
                if job_status == 'JobSucceeded':
                    succeed_job_count += 1
                else:
                    failed_job_count += 1

        app_succeeded = succeed_job_count > 0 and failed_jon_count == 0
        run_time_of_apps.append(finish_time - start_time)
        status_of_apps.append(app_succeeded)
    
    return sum(run_time_of_apps), all(status_of_apps)

def get_resource_usage_of_config(sample):
    # 全都是不带单位的数字
    num_executors = sample['spark.executor.instances']
    executor_cores = sample['spark.executor.cores']
    driver_cores = sample['spark.driver.cores']
    executor_memory = sample['spark.executor.memory']
    driver_memory = sample['spark.driver.memory']
    off_heap_size = sample['spark.memory.offHeap.size']

    total_memory = num_executors * (1.1 * executor_memory + off_heap_size) + 1.1 * driver_memory
    total_cores = num_executors * executor_cores + driver_cores
    return total_cores, total_memory

def check_sample(sample, core_thresholds=(CORE_MIN, CORE_MAX), memory_thresholds=(MEMORY_MIN, MEMORY_MAX)):
    # thresholds[0]是最小值，thresholds[1]是最大值
    total_cores, total_memory = get_resource_usage_of_config(sample)
    if total_cores < core_thresholds[0] or total_cores > core_thresholds[1]:
        return False
    if total_memory < memory_thresholds[0] or total_memory > memory_thresholds[1]:
        return False
    return True