import asyncio
from llama_stack_client import LlamaStackClient
from llama_stack_client.lib.inference.event_logger import EventLogger
from termcolor import cprint
from dotenv import load_dotenv
import os
import json

load_dotenv()

HOST = os.getenv('HOST')
PORT = os.getenv('PORT')
OPENAI_MODEL = os.getenv('OPENAI_MODEL')
GEMINI_MODEL = os.getenv('GEMINI_MODEL')

client = LlamaStackClient(base_url=f'http://{HOST}:{PORT}')

async def chat_loop():
    messages = [{
        "role": "system",
        "content": "You are a helpful assistant and an expert in Python. When the user asks for code, you respond with code and an explanation."
    }]

    while True:
        user_input = input('User> ')
        if user_input.lower() in ['exit', 'quit', 'bye']:
            cprint('Ending conversation. Goodbye!', 'yellow')
            break

        message = {"role": "user", "content": user_input}
        messages.append(message)
        response = client.inference.chat_completion(
            messages=messages,
            model_id=GEMINI_MODEL,
            stream=True
        )

        message = ""
        for log in EventLogger().log(response):
            message += log.content
            log.print()

        messages.append({
            "role": "assistant",
            "content": message,
            "stop_reason": 'end_of_message'
        })


asyncio.run(chat_loop())
