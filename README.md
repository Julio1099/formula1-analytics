# Formula 1 Analytics 

Este projeto organiza e analisa dados da Fórmula 1 usando arquitetura Medallion (Bronze → Silver → Gold) com PySpark, Python e Jupyter Notebook. Inclui processos de ETL, dashboards interativos e análises históricas de pilotos, construtores e corridas. Desenvolvido como projeto da disciplina FGA0060 – Sistemas de Banco de Dados 2, do curso de Engenharia de Software da Universidade de Brasília (UnB).



## 1. Objetivos do projeto

- Implementar uma arquitetura Lakehouse para armazenar e processar dados da Fórmula 1, organizada nas camadas Bronze, Silver e Gold;

- Modelar os dados por meio de representações conceitual (MER), lógica (DER) e física (DLD), garantindo consistência e padronização estrutural;

- Construir e popular um banco de dados containerizado (via Docker) com tabelas otimizadas para consultas e transformações em larga escala;

- Disponibilizar um ambiente analítico integrado, permitindo exploração de dados, análises estatísticas e construção de dashboards interativos com base nas camadas Gold.



## 2. Como usar

### 2.1. Clone o repositório

```bash
git clone https://github.com/Julio1099/formula1-analytics.git
cd formula1-analytics
```

### 2.2. Configurar o ambiente

Certifique-se de ter o **Java** e **Python** instalados, necessários para rodar o PySpark.

```bash
# Instalar Java
sudo apt install default-jdk
java -version

# Instalar Python
sudo apt install python3 python3-venv python3-pip
python3 --version
```

### 2.3. Instalar PySpark e Jupyter

Crie um ambiente virtual:

```bash
python3 -m venv venv
source venv/bin/activate
```

Instale PySpark e Jupyter:

```bash
pip install pyspark jupyter
```

Inicie o Jupyter Notebook:

```bash
jupyter notebook
```

### 2.4. **Rodar a stack Docker**

```bash
cd docker
docker-compose up --build
```

### 2.5. **Verificar o banco**

```bash
docker exec -it medallion-db psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\dn+"
docker exec -it medallion-db psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\dt silver.*"
```


##  3. Estrutura do repositório
```
formula1-analytics/
├─ DataLayer/
│  ├─ raw/                                # Camada Bronze (dados brutos)
│  │  ├─ dados_originais/                 # Dados CSV originais
│  │  ├─ Analise_PySpark2.ipynb           # Notebook de análise exploratória inicial
│  │  └─ dicionario_bronze.md             # Dicionário de dados Bronze
│  │
│  ├─ silver/                             # Camada Silver (dados tratados)
│  │  ├─ dados_limpos/                    # Dados limpos e transformados
│  │  ├─ models/
│  │  │  ├─ ddl_silver.sql
│  │  │  ├─ der_silver.md
│  │  │  ├─ dld_silver.md
│  │  │  └─ mer_silver.md
│  │  └─ dicionario_silver.md
│  │
│  └─ gold/                               # Camada Gold (dados analíticos)
│     ├─ models/
│     │  ├─ ddl_gold.sql
│     │  ├─ der_gold.md
│     │  ├─ dld_gold.md
│     │  └─ mer_gold.md
│     └─ dicionario_gold.md              
│
├─ Notebooks/
│  ├─ Analise_PySpark.ipynb
│  ├─ combined_overview.py
│  └─ spark_bootstrap.py
│
├─ Transformer/                           # Scripts de transformação/ETL
│  ├─ etl_raw_to_silver.py
│  └─ etl_silver_to_gold.py
│
├─ docker/                                # Docker
│  ├─ docker-compose.yml
│  └─ initdb/
│     └─ 00_create_schemas.sql
│
├─ README.md
└─ venv/

```



## 4. Tópicos de análise possiveis

- Distribuição de Tempos de Volta em Mônaco;
- Evolução do Tempo Médio de Volta em Corrida;
- Pit stops por corrida (distribuição);
- Experiência vs Eficácia em Voltas Rápidas;
- Distribuição de Tempos de Volta por Construtor;
- Proporção de abandonos por status de corrida;
- Evolução do Tempo de Volta e Consistência da Pista;
- Heatmap de Performance por Volta;
- Evolução da Posição em Corrida.



## 5. Tecnologias utilizadas

* **Python** – ETL e manipulação de dados;
* **PySpark** – processamento distribuído e transformação de dados em larga escala;
* **PostgreSQL** – armazenamento e estruturação dos dados (Lakehouse);
* **Docker** – containerização e isolamento dos ambientes;
* **Jupyter Notebook** – análise exploratória, desenvolvimento e visualização interativa;
* **Mermaid / SQL** – modelagem conceitual, lógica e física do banco de dados.




## Integrantes do Grupo

<table border="1" style="border-collapse: collapse; width: 100%;">
  <tbody>
    <tr>
      <td align="center" style="padding: 10px;">
        <a href="https://github.com/show-dawn">
          <img src="https://github.com/show-dawn.png?size=120" width="120px;" alt="Fernando Carrijo"/>
        </a>
        <br />
        <b> Fernando Gabriel dos Santos Carrijo</b>
        <br />
        221008033
      </td>
      <td align="center" style="padding: 10px;">
        <a href="https://github.com/Julio1099">
          <img src="https://github.com/Julio1099.png?size=120" width="120px;" alt="Julio Crispim"/>
        </a>
        <br />
        <b>Júlio Cezar Gomes de Souza Crispim </b>
        <br />
        221007591
      </td>
      <td align="center" style="padding: 10px;">
        <a href="https://github.com/kalebmacedo">
          <img src="https://github.com/kalebmacedo.png?size=120" width="120px;" alt="Kaleb Macedo"/>
        </a>
        <br />
        <b> Kaleb de Souza Macedo</b>
        <br />
        231026975
      </td>
      <td align="center" style="padding: 10px;">
        <a href="https://github.com/bolzanMGB">
          <img src="https://github.com/bolzanMGB.png?size=120" width="120px;" alt="Othavio Araujo Bolzan"/>
        </a>
        <br />
        <b>Othavio Araujo Bolzan</b>
        <br />
        231039150
      </td>
    </tr>
  </tbody>
</table>




## Histórico de Versões

| Versão | Data       | Descrição                                           | Autor                                           | Revisor |
| :----: | ---------- | --------------------------------------------------- | ----------------------------------------------- | ------- |
|  `1.0` | 28/09/2025 | Criação do README                                   | [Júlio Cezar](https://github.com/Julio1099) |   [Othavio Bolzan](https://github.com/bolzanMGB)  |
|  `2.0` | 06/10/2025 | Reformulação do README                                   | [Othavio Bolzan](https://github.com/bolzanMGB) |         |
