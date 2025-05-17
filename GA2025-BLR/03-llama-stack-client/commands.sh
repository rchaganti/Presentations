# Set the endpoint for the llama-stack-client to connect to the llama-stack server
llama-stack-client configure --endpoint=http://localhost:8321

# list all models
llama-stack-client models list

# inference with first inference backend (OpenAI)
llama-stack-client inference chat-completion --message "What is Global Azure Bootcamp?"

# inference with second inference backend (Gemini)
llama-stack-client inference chat-completion --message "Why should I attend Global Azure Bootcamp?" --model-id gemini/gemini-1.5-pro

# inference with third inference backend (Ollama)
llama-stack-client inference chat-completion --message "Why should I attend Global Azure Bootcamp?" --model-id llama3.1:8b