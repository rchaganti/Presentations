import asyncio
import json
import os
from typing import Dict, List
from dotenv import load_dotenv

import requests
from dotenv import load_dotenv
from llama_stack_client import LlamaStackClient
from llama_stack_client.lib.agents.agent import Agent
from llama_stack_client.lib.agents.client_tool import ClientTool
from llama_stack_client.lib.agents.event_logger import EventLogger
from llama_stack_client.types import CompletionMessage
from llama_stack_client.types.agent_create_params import AgentConfig
from llama_stack_client.types.shared.tool_response_message import ToolResponseMessage

load_dotenv()

HOST='localhost'
PORT=8321
MODEL='meta-llama/Llama-3.2-3B-Instruct'
BRAVE_SEARCH_API_KEY = os.environ["BRAVE_SEARCH_API_KEY"]

class BraveSearch:
    def __init__(self, api_key: str) -> None:
        self.api_key = api_key

    async def search(self, query: str) -> str:
        url = "https://api.search.brave.com/res/v1/web/search"
        headers = {
            "X-Subscription-Token": self.api_key,
            "Accept-Encoding": "gzip",
            "Accept": "application/json",
        }
        payload = {"q": query}
        response = requests.get(url=url, params=payload, headers=headers)
        return json.dumps(self._clean_brave_response(response.json()))

    def _clean_brave_response(self, search_response, top_k=3):
        query = search_response.get("query", {}).get("original", None)
        clean_response = []
        mixed_results = search_response.get("mixed", {}).get("main", [])[:top_k]

        for m in mixed_results:
            r_type = m["type"]
            results = search_response.get(r_type, {}).get("results", [])
            if r_type == "web" and results:
                idx = m["index"]
                selected_keys = ["title", "url", "description"]
                cleaned = {k: v for k, v in results[idx].items() if k in selected_keys}
                clean_response.append(cleaned)

        return {"query": query, "top_k": clean_response}
    
class WebSearchTool(ClientTool):
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.engine = BraveSearch(api_key)

    def get_name(self) -> str:
        return "web_search"

    def get_description(self) -> str:
        return "Search the web for a given query"

    async def run_impl(self, query: str):
        return await self.engine.search(query)

    async def run(self, messages):
        query = None
        for message in messages:
            if isinstance(message, CompletionMessage) and message.tool_calls:
                for tool_call in message.tool_calls:
                    if "query" in tool_call.arguments:
                        query = tool_call.arguments["query"]
                        call_id = tool_call.call_id

        if query:
            search_result = await self.run_impl(query)
            return [
                ToolResponseMessage(
                    call_id=call_id,
                    role="ipython",
                    content=self._format_response_for_agent(search_result),
                    tool_name="brave_search",
                )
            ]

        return [
            ToolResponseMessage(
                call_id="no_call_id",
                role="ipython",
                content="No query provided.",
                tool_name="brave_search",
            )
        ]

    def _format_response_for_agent(self, search_result):
        parsed_result = json.loads(search_result)
        formatted_result = "Search Results with Citations:\n\n"
        for i, result in enumerate(parsed_result.get("top_k", []), start=1):
            formatted_result += (
                f"{i}. {result.get('title', 'No Title')}\n"
                f"   URL: {result.get('url', 'No URL')}\n"
                f"   Description: {result.get('description', 'No Description')}\n\n"
            )
        return formatted_result

async def execute_search(query: str):
    web_search_tool = WebSearchTool(api_key=BRAVE_SEARCH_API_KEY)
    result = await web_search_tool.run_impl(query)
    print("Search Results:", result)

query = "What are the latest developments in Agentic AI?"
asyncio.run(execute_search(query))

async def run_main(disable_safety: bool = False):
    # Initialize the Llama Stack client with the specified base URL
    client = LlamaStackClient(
        base_url=f"http://{HOST}:{PORT}",
    )

    # Configure input and output shields for safety (use "llama_guard" by default)
    input_shields = [] if disable_safety else ["llama_guard"]
    output_shields = [] if disable_safety else ["llama_guard"]

    # Initialize custom tool (ensure `WebSearchTool` is defined earlier in the notebook)
    webSearchTool = WebSearchTool(api_key=BRAVE_SEARCH_API_KEY)

    # Create an agent instance with the client and configuration
    agent = Agent(
        client,
        model=MODEL,
        instructions="""You are a helpful assistant that responds to user queries with relevant information and cites sources when available.""",
        sampling_params={
            "strategy": {
                "type": "greedy",
            },
        },
        tools=[webSearchTool],
        input_shields=input_shields,
        output_shields=output_shields,
        enable_session_persistence=False,
    )

    # Create a session for interaction and print the session ID
    session_id = agent.create_session("test-session")
    print(f"Created session_id={session_id} for Agent({agent.agent_id})")

    response = agent.create_turn(
        messages=[
            {
                "role": "user",
                "content": """What are the latest developments in Agentic AI?""",
            }
        ],
        session_id=session_id,  # Use the created session ID
    )

    # Log and print the response from the agent asynchronously
    async for log in EventLogger().log(response):
        log.print()


# Run the function asynchronously in a Jupyter Notebook cell
run_main(disable_safety=True)
