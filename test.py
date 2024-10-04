from modules.tuning_data_initializer import init_tuning_data
init_tuning_data()

##########################################
#               recommend                #
##########################################
import json
from langchain_core.messages import AIMessage
from langgraph.prebuilt import ToolNode
from agent.tools import KnowledgeBaseRecommender
tool = ToolNode([KnowledgeBaseRecommender()])
message_with_single_tool_call = AIMessage(
    content="",
    tool_calls=[
        {
            "name": "knowledge_base_recommender",
            "args": {"workload": "1a"},
            "id": "tool_call_1",
            "type": "tool_call"
        }
    ]
)

res = tool.invoke({"messages": [message_with_single_tool_call]})
config = res['messages'][0].content
config = json.loads(config)[0]
print(config)
#========================================#


##########################################
#                 update                 #
##########################################
from langchain_core.messages import AIMessage
from langgraph.prebuilt import ToolNode
from agent.tools import KnowledgeBaseUpdater
tool = ToolNode([KnowledgeBaseUpdater()])
message_with_single_tool_call = AIMessage(
    content="",
    tool_calls=[
        {
            "name": "knowledge_base_updater",
            "args": {"workload": "1a", "config": config},
            "id": "tool_call_2",
            "type": "tool_call"
        }
    ]
)

res = tool.invoke({"messages": [message_with_single_tool_call]})
config = res['messages'][0].content
print(config)
#========================================#