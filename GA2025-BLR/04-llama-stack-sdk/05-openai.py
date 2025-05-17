from openai import OpenAI
from dotenv import load_dotenv
import os

from rich.console import Console
from rich.markdown import Markdown

load_dotenv()

console = Console()

HOST = os.getenv('HOST')
PORT = os.getenv('PORT')
OPENAI_MODEL = os.getenv('OPENAI_MODEL')
GEMINI_MODEL = os.getenv('GEMINI_MODEL')

OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
base_url = f'http://{HOST}:{PORT}'
openai_client = OpenAI(base_url=f"{base_url}/v1/openai/v1", api_key=OPENAI_API_KEY)

response = openai_client.chat.completions.create(
    model=OPENAI_MODEL,
    messages=[
        {"role": "system", "content": "You are a helpful assistant and an expert in Python. When the user asks for code, you respond with code and an explanation."},
        {"role": "user", "content": "Can you write a program to print Fibonacci series?"},
    ]
)

markdown_text = Markdown(response.choices[0].message.content)
console.print(markdown_text)