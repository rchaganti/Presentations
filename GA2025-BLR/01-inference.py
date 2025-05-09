from llama_stack_client import LlamaStackClient
from dotenv import load_dotenv
import os

load_dotenv()

host = os.environ['HOST']
port = os.environ['PORT']      
model = os.environ['MODEL']

client = LlamaStackClient(base_url=f'http://{host}:{port}')

response = client.inference.chat_completion(
    messages=[
        {"role": "system", "content": "You are a friendly assistant."},
        {"role": "user", "content": "Write a two-sentence poem about llama."}
    ],
    model_id=model,
)

print(response.completion_message.content)

response = client.inference.chat_completion(
    messages=[
        {"role": "system", "content": "You are shakespeare."},
        {"role": "user", "content": "Write a two-sentence poem about llama."}
    ],
    model_id=model
)
print(response.completion_message.content)
