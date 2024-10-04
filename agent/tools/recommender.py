import logging
from typing import Optional, Type

import pandas as pd
from pydantic import BaseModel, Field
from langchain_core.tools import BaseTool

from agent.vectorstores import KnowledgeBaseRetriever
from utils import gen_task_embedding, add_scale_dict


class RecommenderInput(BaseModel):
    workload: str = Field(description="The target workload")


class RecommenderOutput(BaseModel):
    configuration: dict = Field(description="The recommended configuraiton")
    similarity: float = Field(description="The similarity between target and historical workload")


logger = logging.getLogger('recommender')
class KnowledgeBaseRecommender(BaseTool):
    name: str = "knowledge_base_recommender"
    description: str = (
        "The Knowledge Base Recommender analyzes a target workload to find the most similar "
        "historical workload from a knowledge base. It suggests configuration parameters "
        "based on the historical workload's settings, providing recommendations that may "
        "help in tuning the database for the target workload, though not necessarily optimal."
    )
    args_schema: Type[BaseModel] = RecommenderInput
    response_format: Type[BaseModel] = RecommenderOutput

    def recommend_by_knowledge_base(self, query: Optional[str]=None, task_id: Optional[str]=None) -> dict:
        data = gen_task_embedding(query, task_id)
        retriever = KnowledgeBaseRetriever()

        similar_task_id, _, similarity = retriever.similarity_search(data)[0].values()
        logger.info(f"new task = {data['task_id']}, similar task = {similar_task_id}, similarity = {similarity}")
        config = retriever.fetch_best_config(similar_task_id)
        if config is None:
            return None, 0
        config.pop("task_id")
        config.pop("duration")

        # save (similar_task_id, task_id) into matched_history_tasks
        retriever.add_task_matched_history(similar_task_id, data["task_id"])

        config = add_scale_dict(config)

        logger.info(f"Suggested config using similar history task for {data['task_id']} = {config}.")
        return config, similarity

    def _run(self, workload: str) -> dict:
        if 'SELECT' in workload.upper():
            config, similarity = self.recommend_by_knowledge_base(query=workload)
        else:
            config, similarity = self.recommend_by_knowledge_base(task_id=workload)

        
        return config, similarity
