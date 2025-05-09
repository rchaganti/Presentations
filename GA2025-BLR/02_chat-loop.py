import asyncio
from llama_stack_client import LlamaStackClient
from termcolor import cprint
from dotenv import load_dotenv
import os

load_dotenv()

host = os.environ['HOST']
port = os.environ['PORT']      
model = os.environ['MODEL']

client = LlamaStackClient(base_url=f'http://{host}:{port}')

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
            model_id=model
        )
        messages.append({
            "role": "assistant",
            "content": response.completion_message.content,
            "stop_reason": response.completion_message.stop_reason
        })
        cprint(f'Assitant>: \n{response.completion_message.content}', 'cyan')

asyncio.run(chat_loop())
