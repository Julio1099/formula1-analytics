# Use Debian como base para ter apt-get disponível
FROM debian:bullseye

# Instalar Java 17, Python 3 e utilitários
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk python3 python3-pip wget curl && \
    rm -rf /var/lib/apt/lists/*

# Configurar JAVA_HOME para PySpark
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Instalar bibliotecas Python
RUN pip3 install --no-cache-dir pyspark psycopg2-binary

# Diretório de trabalho
WORKDIR /app
COPY populate.py /app/populate.py

# Comando default
CMD ["python3", "populate.py"]
