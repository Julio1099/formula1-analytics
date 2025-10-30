FROM jupyter/pyspark-notebook:latest

USER root

# Instala dependências Python (psycopg2, papermill) E do sistema (wget, psql)
RUN pip install --no-cache-dir psycopg2-binary papermill && \
    apt-get update && apt-get install -y --no-install-recommends wget postgresql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Baixa o driver JDBC do PostgreSQL
RUN wget https://jdbc.postgresql.org/download/postgresql-42.3.1.jar -P /usr/local/spark/jars/

# Volta para o usuário padrão jovyan e define o diretório
USER jovyan
WORKDIR /home/jovyan/work

# Copia os notebooks (opcional com volumes, mas mantido)
COPY Transformer/etl_raw_to_silver.ipynb .
COPY Transformer/etl_silver_to_gold.ipynb .