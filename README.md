# PC1 Starter Kit — Arquitetura Medallion (Bronze/Silver/Gold)

Este kit foi gerado em 2025-09-06 19:19 e serve como ponto de partida para o **Ponto de Controle 1 (PC1)**.

## Como usar (resumo)
1) **Crie o arquivo `.env`** a partir do `.env.example` com suas credenciais do Postgres.  
2) Coloque seus arquivos CSV originais em `bronze/dados_originais/`.  
3) (Opcional) Ajuste `silver/config.yml` para separador, encoding, PK etc.  
4) Rode:  
```bash
cd docker
docker-compose up --build
```
5) Verifique as tabelas criadas (ex.: `silver.*_clean`) e índices:
```bash
docker exec -it medallion-db psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\dn+"
docker exec -it medallion-db psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\dt silver.*"
```

> **PC1 cobre**: Repositório Git, escolha de dados, documentação Bronze (dicionário + analytics), MER/DER/DLD/DDL Silver, ETL Raw→Silver, Lakehouse populada (com índice), banco containerizado e script Python rodando no `docker-compose up`.

---

## Estrutura do repositório
```
pc1_starter_kit/
├─ bronze/
│  ├─ dados_originais/              # Coloque seus CSVs aqui (Raw/Bronze)
│  └─ dicionario_bronze.md          # Template do dicionário de dados (Bronze)
├─ silver/
│  ├─ etl_raw_to_silver.py          # ETL genérico: Bronze → Silver (Postgres)
│  ├─ config.yml                    # Configurações do ETL (separador, PK, encoding)
│  └─ models/
│     ├─ mer_silver.md              # MER (conceitual) - template (Mermaid)
│     ├─ der_silver.md              # DER (lógico) - template
│     ├─ dld_silver.md              # DLD (físico) - template
│     └─ ddl_silver.sql             # DDL exemplo (Lakehouse)
├─ gold/                            # (Reservado para PC futuros)
├─ docs/
│  ├─ bronze/
│  │  └─ analytics_notebook_plan.md # Roteiro da análise exploratória
│  └─ silver/
│     └─ dicionario_silver.md       # Template dicionário (Silver)
├─ scripts/
│  └─ wait_for_db.sh                # Script simples para aguardar o Postgres
├─ docker/
│  ├─ docker-compose.yml
│  └─ initdb/
│     └─ 00_create_schemas.sql
├─ .env.example
├─ requirements.txt
└─ README.md
```

## Ordem sugerida de execução (PC1)
1. **Git**: crie o repositório, suba esta estrutura.
2. **Dados**: escolha o dataset e coloque os arquivos em `bronze/dados_originais/`.
3. **Bronze docs**: preencha `bronze/dicionario_bronze.md`; use o roteiro em `docs/bronze/analytics_notebook_plan.md`.
4. **Silver model**: edite os templates `silver/models/*` para refletir seu caso.
5. **Docker**: configure `.env` e rode `docker-compose up`.
6. **ETL**: o serviço `etl` irá ler os CSVs e popular `silver.<arquivo>_clean`.
7. **Índices**: criados pelo ETL (id ou primeira coluna). Confirme com `\d` no psql.
