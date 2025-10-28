FROM jupyter/pyspark-notebook:latest

USER root

# Instala psycopg2, wget E o postgresql-client
RUN pip install psycopg2-binary && \
    apt-get update && apt-get install -y wget postgresql-client

# Baixa o driver JDBC do PostgreSQL
RUN wget https://jdbc.postgresql.org/download/postgresql-42.3.1.jar -P /usr/local/spark/jars/

# Volta para o usuário padrão
USER jovyan
WORKDIR /home/jovyan/work

# Copia o notebook
COPY Transformer/etl_raw_to_silver.ipynb .
