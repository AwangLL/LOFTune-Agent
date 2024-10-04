import os
import time
import random
import subprocess
from copy import deepcopy

from config.config import workload, data_size
from config.common import config_path, cwd, simulator
from config.knob_list import EXTRA_KNOBS


def write_config_file(config: dict, file_name: str) -> None:
    """ write config to config_file """
    with open(file_name, 'w') as conf_file:
        for knob, value in EXTRA_KNOBS.items():
            if knob in config:
                continue
            config[knob] = value
        for conf in config:
            conf_file.write(f"{conf} {config[conf]}\n")


def run_task(task_id, config: dict) -> str:
    """ run the sql with the config """
    if simulator:
        return f"application_" + str(random.randint(0, 100))
    cur_time = int(round(time.time() * 1000))
    sqls = task_id.split('_')

    if workload in ['JOIN', 'SCAN', 'AGGR']:
        sqls = workload

    os.chdir(os.getenv('SPARK_HOME'))
    cmd = './benchmarks/scripts/run_benchmark_task.sh'

    app_idx = []
    for index, sql in enumerate(sqls):
        name = f"{cur_time}_{index}"
        config_file_path = f"{config_path}/{name}.conf"
        write_config_file(deepcopy(config), config_file_path)

        # print(f"{cmd} --workload={workload} --task={sql} --data_size={data_size} --name={name}")
        
        result = subprocess.run([cmd, f"--workload={workload}", f"--task={sql}", f"--data_size={data_size}", f"--name={name}"],
                                stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        output_lines = result.stdout.decode('utf-8').splitlines()
        app_id = output_lines[1].split(': ')[1]

        if app_id == '':
            os.chdir(cwd)
            return ''
        
        app_idx.append(app_idx)

    os.chdir(cwd)
    return '/'.join(app_idx)