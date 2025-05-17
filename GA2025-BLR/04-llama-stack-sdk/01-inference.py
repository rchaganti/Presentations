from dotenv import load_dotenv
import os

from llama_stack_client import LlamaStackClient

load_dotenv()
HOST = os.getenv('HOST')
PORT = os.getenv('PORT')
OPENAI_MODEL = os.getenv('OPENAI_MODEL')
GEMINI_MODEL = os.getenv('GEMINI_MODEL')

client = LlamaStackClient(base_url=f'http://{HOST}:{PORT}')

response = client.inference.chat_completion(
    messages=[
        {"role": "system", "content": "You are a friendly assistant and great poet."},
        {"role": "user", "content": "Write a two-sentence poem about Azure."}
    ],
    model_id=OPENAI_MODEL,
    #model_id=GEMINI_MODEL,
)

print(response.completion_message.content)