import json
import datetime
import random
import logging
import warnings
from typing import Type
from copy import deepcopy

import numpy as np
import pandas as pd
from pydantic import BaseModel, Field
from langchain_core.tools import BaseTool

from agent.vectorstores import KnowledgeBaseRetriever
from config.common import cwd, simulator
from config.knob_list import *
from modules.task_runner import run_task
from modules.regression_model import PerformanceModel
from utils import load_event_log_content, load_info_from_lines, add_scale_dict, check_sample, embedding_columns


class UpdaterInput(BaseModel):
    workload: str = Field(description="The target workload")
    config: str = Field(description="The initial configuraiton to be optimized, for example: {'spark.broadcast.compress': 'true'}")


class UpdaterOutput(BaseModel):
    config: dict = Field(description="The optimized configuration")


logger = logging.getLogger('updater')
class KnowledgeBaseUpdater(BaseTool):
    name: str = "knowledge_base_updater"
    description: str = (
        "The Knowldge Base Updater optimizes configuration parameters for a given workload. "
        "By iteratively tuning the configuration, the tool seeks the best possible settings "
        "for the workload and stores the optimal configuration in the knowledge base. "
        # "This process ensures that future workload recommendations are based on the most "
        # "effective configuration."
    )
    args_schema: Type[BaseModel] = UpdaterInput
    response_format: Type[BaseModel] = UpdaterOutput


    def run_task_and_update(self, task_id, config, update=True):
        retriever = KnowledgeBaseRetriever()
        app_id = run_task(task_id, config)
        if app_id == '':
            logger.error(f"App launch failed. Please refer to the spark output logs.")
            return None
        # 根据app_id从HDFS上拉文件并获取运行时间
        if simulator:
            run_time, app_succeed = random.randint(1000, 10000), True
        else:
            event_log_content_of_apps = load_event_log_content(app_id)
            run_time, app_succeed = load_info_from_lines(event_log_content_of_apps)
        if app_succeed:
            logger.info(f"Run successfully. Duration = {run_time} ms.")
            if update:
                # 更新历史数据
                retriever.update_task_best_config(app_id, task_id, config, run_time)
        else:
            logger.error(f"Run failed.")
            run_time = 3600000
        
        tunning_data = {'app_id': app_id, 'duration': run_time}
        tunning_data.update(config)
        return tunning_data
    
    # 调整所有参数的范围，不再局限于RESOURCE_KNOBS
    def update_knob_detail(self, task_best_config):
        # 资源范围不调了
        core_thresholds = (CORE_MIN, CORE_MAX)
        memory_thresholds = (MEMORY_MIN, MEMORY_MAX)

        updated_knob_details = deepcopy(KNOB_DETAILS)
        for knob, best_value in task_best_config.items():
            # 范围调整为最优值的[80%, 140%]
            knob_details = KNOB_DETAILS[knob]
            knob_type = knob_details['type']
            if knob_details['range_adjustable']:  # 只有范围可调节的参数才适用动态调节
                min_value, max_value, step_length = knob_details['range'][0: 3]

                # 调整最小值
                new_min_value = best_value * 0.8
                if not knob_details['limit_exceed'][0]:  # 新的最小值不能超过knobs_list里给定的最小值
                    new_min_value = max(new_min_value, min_value)
                if knob_type == KnobType.INTEGER:
                    new_min_value = int(max(1, new_min_value))  # 处理一下best_value=1的极端情况
                updated_knob_details[knob]['range'][0] = new_min_value

                # 调整最大值
                expand_ratio = 1.4 if best_value >= min_value else 2  # 如果最优值太小，搜索空间会越来越小而且无法恢复，所以此时拉大一些
                new_max_value = best_value * expand_ratio + step_length  # 加一个step_length，防止搜索空间是空的
                if not knob_details['limit_exceed'][1]:  # 新的最大值不能超过knobs_list里给定的最大值
                    new_max_value = min(new_max_value, max_value)
                if knob_type == KnobType.INTEGER:
                    new_max_value = int(new_max_value)
                updated_knob_details[knob]['range'][1] = new_max_value

        return updated_knob_details, core_thresholds, memory_thresholds


    def update_history(self, task_id, epoch, weights=None):
        warnings.filterwarnings('ignore', category=UserWarning)
        logger.info(f"Config {epoch} for history task {task_id} generation starts.")

        retriever = KnowledgeBaseRetriever()

        task_embedding = retriever.fetch_task_embedding(task_id)
        sql = task_embedding.pop('sql')
        task_embedding = [task_embedding[c] for c in embedding_columns]
        best_config = retriever.fetch_best_config(task_id)
        task_best_config = {knob: best_config[knob] for knob in KNOB_DETAILS.keys()}
        updated_knob_details, core_thresholds, memory_thresholds = self.update_knob_detail(task_best_config)
        logger.info(f"Updated resource thresholds for task {task_id}: "
                    f"cores [{core_thresholds[0]}, {core_thresholds[1]}], "
                    f"memory [{memory_thresholds[0]}m, {memory_thresholds[1]}m].")

        history_data = retriever.fetch_all_task_history()
        regression_model = PerformanceModel(
                                            core_thresholds=core_thresholds,
                                            memory_thresholds=memory_thresholds,
                                            weights=weights)
        regression_model.train(history_data)

        # 给输入的历史任务采样一个配置点
        estimated_running_time = -1
        while True:
            params = regression_model.search_new_config(task_embedding, updated_knob_details, task_best_config)
            data = [params[knob] for knob in KNOBS]
            data.extend(task_embedding)
            predict_data = np.array(data).reshape(1, -1)
            # 如果返回的参数能够成功运行，跳出循环
            # BO只能做到软约束，不能做到硬约束，所以还需要检查
            if check_sample(params, core_thresholds, memory_thresholds):
                estimated_running_time = regression_model.predict(predict_data)[0]
                break
            else:
                logger.info(f"Config {epoch} for history task {task_id} generated failed.")
        config = add_scale_dict(params)
        logger.info(f"Config {epoch} for history task {task_id} generated successfully: {config}, "
                    f"estimated running time = {estimated_running_time} ms.")

        logger.info(f"Update history of task {task_id} finished.")
        warnings.resetwarnings()
        if weights is None:
            return config
        else:
            return config, regression_model.probabilities, regression_model.selected_index


    def _run(self, workload: str, config: str) -> dict:
        all_tuning_data = []
        task_id = workload
        config = json.loads(config)

        tuning_data = self.run_task_and_update(task_id, config)
        all_tuning_data.append(tuning_data)

        num_epochs = 2
        duration = tuning_data['duration']
        best_config = config
        logger.info(f"Start {num_epochs - 1} iters of further tuning for task {task_id}.")
        for epoch in range(1, num_epochs):
            config = self.update_history(task_id, epoch)
            if config is None:
                return
            logger.info(f"Suggested config for {task_id} in iter {epoch} = {config}.")
            tuning_data = self.run_task_and_update(task_id, config)
            if tuning_data is None:
                continue
            if tuning_data['duration'] < duration:
                best_config = config
                duration = tuning_data['duration']
            all_tuning_data.append(tuning_data)
        

        df = pd.DataFrame(all_tuning_data)
        df.to_csv(f"{cwd}/result/{workload}#{data_size}G#{task_id}#{datetime.datetime.now().strftime('%Y-%m-%d-%H-%M-%S')}#new#{num_epochs}epochs.csv", index=False)
        logger.info(f"Finish tuning for new task {task_id}.")

        return add_scale_dict(best_config)