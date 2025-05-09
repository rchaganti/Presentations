from llama_stack_client import LlamaStackClient
from dotenv import load_dotenv
import os

load_dotenv()

host = os.environ['HOST']
port = os.environ['PORT']

client = LlamaStackClient(base_url=f'http://{host}:{port}')
models = client.models.list()
for model in models:
    print("Model ID:", model.identifier)
    print("Model Type:", model.model_type)
    print("Model Provider ID:", model.provider_id)
