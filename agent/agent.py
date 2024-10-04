from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langgraph.graph import StateGraph
from langgraph.prebuilt import ToolNode, tools_condition

from agent.assistant import Assistant, State
from agent.tools import KnowledgeBaseRecommender, KnowledgeBaseUpdater

def init_graph():
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

    tools = [KnowledgeBaseRecommender(), KnowledgeBaseUpdater()]
    assistant_runnable = assistant_prompt | llm.bind_tools(tools)

    graph_builder = StateGraph(State)

    graph_builder.add_node("assistant", Assistant(assistant_runnable))
    graph_builder.add_node("tools", ToolNode(tools))

    graph_builder.add_conditional_edges("assistant", tools_condition)
    graph_builder.add_edge("tools", "assistant")

    graph_builder.set_entry_point("assistant")
    return graph_builder.compile()


def print_event(event: dict, _printed: set, max_length=1500):
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