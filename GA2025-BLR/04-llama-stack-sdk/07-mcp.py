from llama_stack_client.types.tool_group import McpEndpoint
from llama_stack_client import LlamaStackClient
from llama_stack_client.lib.agents.agent import Agent
from llama_stack_client.lib.agents.event_logger import EventLogger
from llama_stack_client.types.shared_params.agent_config import ToolConfig

from termcolor import cprint
import os

HOST = os.getenv('HOST')
PORT = os.getenv('PORT')
OPENAI_MODEL = os.getenv('OPENAI_MODEL')
GEMINI_MODEL = os.getenv('GEMINI_MODEL')

client = LlamaStackClient(
    base_url=f"http://{HOST}:{PORT}",
)

client.toolgroups.register(
    toolgroup_id="mcp::azure-mcp-server",
    provider_id="model-context-protocol-1",
    mcp_endpoint=McpEndpoint(uri="http://localhost:8888/sse"),
)

agent = Agent(
    client,   
    model=OPENAI_MODEL,
    instructions="""
    You are an agent - please keep going until the user's query is completely resolved, before ending your turn and yielding back to the user. Only terminate your turn when you are sure that the prompt is resolved.
If you are not sure about the parameters to use for a given tool call, use your tools to gather the necessary input parameters: do NOT guess or make up an answer.
You MUST plan extensively before each function call, and reflect extensively on the outcomes of the previous function calls. DO NOT do this entire process by making function calls only, as this can impair your ability to solve the problem and think insightfully.
    """,
    tools=["mcp::azure-mcp-server"],
    tool_config=ToolConfig(
        tool_choice="auto"
    ),
)

user_prompts = [    
    "list all azure subscriptions I have access to",
    "Are there any virtual machines running in my azure subscriptions?",
    "What are all the resource groups my subscriptions have?",
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
        toolgroups=["mcp::azure-mcp-server"]
    )

    for log in EventLogger().log(response):
        log.print()

client.toolgroups.unregister(
    toolgroup_id="mcp::azure-mcp-server"
)
