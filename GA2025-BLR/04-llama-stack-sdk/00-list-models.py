from llama_stack_client import LlamaStackClient
from dotenv import load_dotenv
import os

load_dotenv()

HOST = os.getenv('HOST')
PORT = os.getenv('PORT')

client = LlamaStackClient(base_url=f'http://{HOST}:{PORT}')
models = client.models.list()
for model in models:
    print("Model ID:", model.identifier)
    print("Model Type:", model.model_type)
    print("Model Provider ID:", model.provider_id)
