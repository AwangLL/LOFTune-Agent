
from langchain_core.tools import tool

from agent.vectorstores import KnowledgeBaseRetriever
from utils import add_scale_dict

@tool
def get_task_config(task_id: str) -> dict:
    """Call to get the config stored in the knowledge base of target task"""
    retriever = KnowledgeBaseRetriever()
    config = retriever.fetch_best_config(task_id)
    config = dict(config)
    config.pop('task_id')
    config.pop('duration')
    return add_scale_dict(config)