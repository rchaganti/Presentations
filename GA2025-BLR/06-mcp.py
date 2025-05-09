from llama_stack_client.types.tool_group import McpEndpoint
from llama_stack_client import LlamaStackClient
from llama_stack_client.lib.agents.agent import Agent
from llama_stack_client.lib.agents.event_logger import EventLogger
from llama_stack_client.lib.inference.event_logger import EventLogger as iel
from llama_stack_client.types.shared_params.agent_config import ToolConfig

from termcolor import cprint
import pprint

HOST='192.168.32.46'
PORT=8321
MODEL='meta-llama/Llama-3.2-3B-Instruct'

client = LlamaStackClient(
    base_url=f"http://{HOST}:{PORT}",
)

client.toolgroups.register(
    toolgroup_id="mcp::idrac-mcp-server",
    provider_id="model-context-protocol-4",
    mcp_endpoint=McpEndpoint(uri="http://192.168.32.46:8888/sse"),
)

agent = Agent(
    client,   
    model=MODEL,
    instructions="""
    You are an agent - please keep going until the user's query is completely resolved, before ending your turn and yielding back to the user. Only terminate your turn when you are sure that the problem is solved.
If you are not sure about the parameters to use for a given tool call, use your tools to gather the necessary input parameters: do NOT guess or make up an answer.
You MUST plan extensively before each function call, and reflect extensively on the outcomes of the previous function calls. DO NOT do this entire process by making function calls only, as this can impair your ability to solve the problem and think insightfully.
    """,
    tools=["mcp::idrac-mcp-server"],
    tool_config=ToolConfig(
        tool_choice="auto"
    ),
)

#pprint.pprint(client.tools.list())

user_prompts = [    
# "Show me all systems with processor virtualization attribute enabled",
 "What network adapters are available on system 172.16.0.27?",
"Get all BIOS attributes from the systems with iDRAC IP address 172.16.0.28",
# "What Dell PowerEdge systems I have access to?",
"Are there any systems with a Broadcom network adapter?"
]

session_id = agent.create_session("demo-session")

for prompt in user_prompts:
    cprint(f"User> {prompt}", "green")
    
    response = agent.create_turn(
        messages=[
            {
                "role": "user",
                "content": prompt,
            }
        ],
        session_id=session_id,
        stream=True,
        toolgroups=["mcp::idrac-mcp-server"]
    )

    for log in EventLogger().log(response):
        log.print()

client.toolgroups.unregister(
    toolgroup_id="mcp::idrac-mcp-server"
)
