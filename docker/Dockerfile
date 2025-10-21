FROM jupyter/pyspark-notebook:latest

USER root

# Instala o psycopg2 (para o teste de conexão) e o wget (para baixar o driver)
RUN pip install psycopg2-binary && \
    apt-get update && apt-get install -y wget

# Baixa o driver JDBC do PostgreSQL e o coloca na pasta de jars do Spark
RUN wget https://jdbc.postgresql.org/download/postgresql-42.3.1.jar -P /usr/local/spark/jars/

# Volta para o usuário padrão
USER jovyan
WORKDIR /home/jovyan/work

# O caminho agora reflete sua estrutura de pastas com a pasta "Transformer"
COPY Transformer/ETL/raw_to_silver.ipynb .

CMD [ \
  "sh", \
  "-c", \
  "jupyter nbconvert --to script raw_to_silver.ipynb && spark-submit raw_to_silver.py" \
]