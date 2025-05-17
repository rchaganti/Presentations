export INFERENCE_MODEL="llama3.1:8b"
export OPENAI_API_KEY="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"
export GEMINI_API_KEY="AIzaSyBUTT5_XRboYOJeDXyjkoCJajooFFYOZ3Q"
export OLLAMA_URL="http://host.docker.internal:11434"

# Start a Llama Stack server with OpenAI, Gemini, and Ollama inference
docker run -d -p 8321:8321 \
           -v ~/.llama:/root/.llama \
           -v ~/run.yaml:/root/.llama/run.yaml \
           --env OPENAI_API_KEY=$OPENAI_API_KEY \
           --env GEMINI_API_KEY=$GEMINI_API_KEY \
           --env INFERENCE_MODEL=$INFERENCE_MODEL \
           ga2025-lstack:0.2.5 --port 8321 \
           --yaml-config /root/.llama/run.yaml

# Start PgVector
export PGVECTOR_HOST=host.docker.internal
export PGVECTOR_PORT=5432
export PGVECTOR_USER=pgv
export PGVECTOR_PASSWORD=P@ssw0rd
export PGVECTOR_DB=pgvdb

docker run -e POSTGRES_USER=$PGVECTOR_USER \
           -e POSTGRES_PASSWORD=$PGVECTOR_PASSWORD \
          -e POSTGRES_DB=$PGVECTOR_DB \
           --name pgv \
           -p $PGVECTOR_PORT:$PGVECTOR_PORT \
           -d pgvector/pgvector:pg17

sudo apt install postgresql-client-common
sudo apt install postgresql-client
psql -U $PGVECTOR_USER --host=localhost $PGVECTOR_DB -c "CREATE EXTENSION vector;"

# Run Llama Stack server with PgVector
docker run -d \
    -p 8321:8321 \
    -v ~/.llama:/root/.llama \
    -v ~/run.yaml:/root/.llama/run.yaml \
    --env OPENAI_API_KEY=$OPENAI_API_KEY \
    --env GEMINI_API_KEY=$GEMINI_API_KEY \
    --env INFERENCE_MODEL=$INFERENCE_MODEL \
    --env PGVECTOR_HOST=$PGVECTOR_HOST \
    --env PGVECTOR_PORT=$PGVECTOR_PORT \
    --env PGVECTOR_USER=$PGVECTOR_USER \
    --env PGVECTOR_PASSWORD=$PGVECTOR_PASSWORD \
    --env PGVECTOR_DB=$PGVECTOR_DB \
    ga2025-lstack:0.2.5 \
    --port 8321 \
    --yaml-config /root/.llama/run.yaml
