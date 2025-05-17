python3 -m venv .venv
source .venv/bin/activate

git clone https://github.com/meta-llama/llama-stack.git
cd llama-stack
pip install -e .

llama stack build --config build.yaml --image-name ga2025-lstack