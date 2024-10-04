from typing import Annotated
from typing_extensions import TypedDict

from langchain_core.runnables import Runnable
from langgraph.graph.message import add_messages


class State(TypedDict):
    messages: Annotated[list, add_messages]


class Assistant:
    def __init__(self, runnable: Runnable):
        self.runnable = runnable

    def __call__(self, state: State):
        result = self.runnable.invoke(state)
        return {"messages": result}
    

