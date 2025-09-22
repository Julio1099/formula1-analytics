# 🏎️ Formula 1 Analytics — Data Lakehouse (Bronze/Silver/Gold)

Este projeto tem como objetivo **organizar, transformar e analisar dados da Fórmula 1** utilizando a arquitetura **Medallion** (Bronze → Silver → Gold).  

A proposta é criar uma base sólida para análises de desempenho de pilotos, construtores e corridas ao longo da história da Fórmula 1, usando **ETL em Python**, **Postgres** e **Docker**.

---

## 🎯 Objetivos do projeto
- Estruturar dados brutos de Fórmula 1 em camadas (Bronze, Silver e Gold).  
- Criar modelos conceitual, lógico e físico para organizar as informações.  
- Popular um banco de dados containerizado com tabelas otimizadas.  
- Disponibilizar um ambiente pronto para exploração analítica e dashboards.  

---

## 🚀 Como usar
1. **Configurar o ambiente**  
   - Copie o `.env.example` para `.env` e ajuste as credenciais do Postgres.  

2. **Carregar os dados**  
   - Coloque seus arquivos CSV originais em `bronze/dados_originais/`  
     (ex.: `corridas.csv`, `pilotos.csv`, `construtores.csv`, `voltas.csv`).  

3. **Rodar a stack**  
   ```bash
   cd docker
   docker-compose up --build
   ```

4. **Verificar o banco**  
   ```bash
   docker exec -it medallion-db psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\dn+"
   docker exec -it medallion-db psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\dt silver.*"
   ```

5. **ETL automático**  
   - O script `etl_raw_to_silver.py` transforma os dados de Bronze → Silver.  
   - Índices são criados automaticamente (pela primeira coluna de cada tabela).  

---

## 📂 Estrutura do repositório
```
formula1-analytics/
├─ bronze/
│  ├─ dados_originais/              # CSVs brutos (dados da Fórmula 1)
│  └─ dicionario_bronze.md          # Dicionário de dados (Bronze)
├─ silver/
│  ├─ etl_raw_to_silver.py          # ETL genérico: Bronze → Silver (Postgres)
│  ├─ config.yml                    # Configurações do ETL (separador, PK, encoding)
│  └─ models/
│     ├─ mer_silver.md              # Modelo conceitual (MER)
│     ├─ der_silver.md              # Modelo lógico (DER)
│     ├─ dld_silver.md              # Modelo físico (DLD)
│     └─ ddl_silver.sql             # DDL para criação de tabelas
├─ gold/                            # Resultados analíticos e dashboards
├─ docs/
│  ├─ bronze/
│  │  └─ analytics_notebook_plan.md # Roteiro de análise exploratória
│  └─ silver/
│     └─ dicionario_silver.md       # Dicionário de dados Silver
├─ scripts/
│  └─ wait_for_db.sh                # Script para aguardar o Postgres
├─ docker/
│  ├─ docker-compose.yml
│  └─ initdb/
│     └─ 00_create_schemas.sql
├─ .env.example
├─ requirements.txt
└─ README.md
```

---

## 📊 Possibilidades de análise
- Evolução do desempenho de pilotos por temporada  
- Comparação de equipes (construtores) ao longo dos anos  
- Análise de voltas rápidas x posição final  
- Ranking histórico de campeões  
- Impacto de circuitos e condições de corrida no resultado  

---

## 🛠️ Tecnologias utilizadas
- **Python** (ETL, manipulação de dados)  
- **PostgreSQL** (armazenamento e Lakehouse)  
- **Docker** (containerização)  
- **Mermaid / SQL** (modelagem conceitual, lógica e física)  

---

✍️ Projeto de **engenharia e análise de dados** aplicado ao domínio da **Fórmula 1**.  
