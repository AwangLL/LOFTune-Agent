from dotenv import load_dotenv
from typing import Annotated, Type
from typing_extensions import TypedDict

from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.pydantic_v1 import BaseModel, Field
from langchain_core.runnables import Runnable
from langchain_core.tools import BaseTool
from langgraph.graph import StateGraph
from langgraph.graph.message import add_messages
from langgraph.prebuilt import ToolNode, tools_condition


class State(TypedDict):
    messages: Annotated[list, add_messages]


class RecommenderInput(BaseModel):
    workload: str = Field(description="target workload")


class RecommenderOutput(BaseModel):
    configuration: dict = Field(description="configuration")


class ConfigurationRecommender(BaseTool):
    name: str = "ConfigurationRecommender"
    description: str = "Recommend a proper configuration for the target workload based on Knowledge Base."
    args_schema: Type[BaseModel] = RecommenderInput
    response_format: Type[BaseModel] = RecommenderOutput

    def _run(self, workload: str) -> dict:
        return {
            "spark.sql.autoBroadcastJoinThreshold": "-1"
        }


class UpdaterInput(BaseModel):
    workload: str = Field(description="historical workload")


class UpdaterOutput(BaseModel):
    configuration: str = Field(description="better configuration")


class KnowledgeBaseUpdater(BaseTool):
    name: str = "KnowledgeBaseUpdater"
    description: str = "Find better configurations for the historical workloads and update the Knowledge Base"
    args_schema: Type[BaseModel] = UpdaterInput
    response_format: Type[BaseModel] = UpdaterOutput

    max_iters: int = 10

    def _run(self, workload: str) -> dict:
        old_configuration = {"spark.sql.autoBroadcastJoinThreshold": str(20 * 1024 * 1024)}
        configuration = old_configuration
        for i in range(self.max_iters):
            configuration = configuration
        return configuration


class Assistant:
    def __init__(self, runnable: Runnable):
        self.runnable = runnable

    def __call__(self, state: State):
        result = self.runnable.invoke(state)
        return {"messages": result}


def main():
    load_dotenv()

    llm = ChatOpenAI(temperature=0)
    # llm = ChatOpenAI(model="gpt-4o", temperature=0)

    assistant_prompt = ChatPromptTemplate.from_messages(
        [
            (
                "system",
                "You are a helpful database assistant for optimizing the configuration of database."
                "  You should implement 2 functions:\n"
                "    - Recommend configuration for target workload: invoke Configuration Recommender to generate acceptable configuration and then call Knowledge Base Updater to get the best configuration.\n"
                "    - Update the historical workload: use Knowledge Base Updater to update configuration of workload.\n"
                "  Final configuration should be output in JSON format without other messages."
            ),
            ("placeholder", "{messages}")
        ]
    )

    tools = [ConfigurationRecommender(), KnowledgeBaseUpdater()]
    assistant_runnable = assistant_prompt | llm.bind_tools(tools)

    graph_builder = StateGraph(State)

    graph_builder.add_node("assistant", Assistant(assistant_runnable))
    graph_builder.add_node("tools", ToolNode(tools))

    graph_builder.add_conditional_edges("assistant", tools_condition)
    graph_builder.add_edge("tools", "assistant")

    graph_builder.set_entry_point("assistant")
    graph = graph_builder.compile()

    user_input = "Recommend: SELECT * FROM user_info"
    # user_input = "Update: SELECT * FROM user_info"
    events = graph.stream(
        {"messages": ("user", user_input)}, stream_mode="values"
    )

    def _print_event(event: dict, _printed: set, max_length=1500):
        current_state = event.get("dialog_state")
        if current_state:
            print("Currently in: ", current_state[-1])
        message = event.get("messages")
        if message:
            if isinstance(message, list):
                message = message[-1]
            if message.id not in _printed:
                msg_repr = message.pretty_repr(html=True)
                if len(msg_repr) > max_length:
                    msg_repr = msg_repr[:max_length] + " ... (truncated)"
                print(msg_repr)
                _printed.add(message.id)

    _printed = set()
    for event in events:
        _print_event(event, _printed)


if __name__ == "__main__":
    main()
