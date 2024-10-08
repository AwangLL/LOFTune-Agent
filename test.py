

##########################################
#               recommend                #
##########################################
# from modules.tuning_data_initializer import init_tuning_data
# init_tuning_data()

# import json
# from langchain_core.messages import AIMessage
# from langgraph.prebuilt import ToolNode
# from agent.tools import KnowledgeBaseRecommender
# tool = ToolNode([KnowledgeBaseRecommender()])
# message_with_single_tool_call = AIMessage(
#     content="",
#     tool_calls=[
#         {
#             "name": "knowledge_base_recommender",
#             "args": {"workload": "1a"},
#             "id": "tool_call_1",
#             "type": "tool_call"
#         }
#     ]
# )

# res = tool.invoke({"messages": [message_with_single_tool_call]})
# config = res['messages'][0].content
# print(json.loads(config)[0])
#========================================#


##########################################
#            get_task_config             #
##########################################
from langchain_core.messages import AIMessage
from langgraph.prebuilt import ToolNode
from agent.tools.retriever import get_task_config
tool = ToolNode([get_task_config])
message_with_single_tool_call = AIMessage(
    content="",
    tool_calls=[
        {
            "name": "get_task_config",
            "args": {"task_id": "1a"},
            "id": "tool_call_3",
            "type": "tool_call"
        }
    ]
)
res = tool.invoke({"messages": [message_with_single_tool_call]})
config = res['messages'][0].content
print(config)
#========================================#


##########################################
#                 update                 #
##########################################
from langchain_core.messages import AIMessage
from langgraph.prebuilt import ToolNode
from agent.tools import KnowledgeBaseUpdater
tool = ToolNode([KnowledgeBaseUpdater()])
config = config[config.find('{') : config.find('}') + 1]
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


##########################################
#            get_task_config             #
##########################################
# from langchain_core.messages import AIMessage
# from langgraph.prebuilt import ToolNode
# from agent.tools.retriever import get_task_config
# tool = ToolNode([get_task_config])
# message_with_single_tool_call = AIMessage(
#     content="",
#     tool_calls=[
#         {
#             "name": "get_task_config",
#             "args": {"task_id": "1a"},
#             "id": "tool_call_3",
#             "type": "tool_call"
#         }
#     ]
# )
# res = tool.invoke({"messages": [message_with_single_tool_call]})
# config = res['messages'][0].content
# print(config)
#========================================#