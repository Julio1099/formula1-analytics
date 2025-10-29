from airflow.models.dag import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime
import pendulum
from airflow.utils.dates import days_ago

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

# --- Variáveis de Ambiente Essenciais para PySpark (Caminhos Corretos do Ambiente) ---
SPARK_HOME_VAR = "/usr/local/spark"
PY4J_PATH = f"{SPARK_HOME_VAR}/python/lib/py4j-0.10.9.7-src.zip"
PYTHONPATH_VAR = f"{SPARK_HOME_VAR}/python:{PY4J_PATH}"

# --- Comandos Bash ---

cmd_ddl_silver = "psql -h db -U f1user -d f1database -f /opt/airflow/dags/sql/ddl_silver.sql"
cmd_ddl_gold = "psql -h db -U f1user -d f1database -f /opt/airflow/dags/sql/ddl_gold.sql"

# ETLs usando Papermill com Variáveis de Ambiente Explícitas
cmd_etl_silver = f"""
docker exec \\
    -e SPARK_HOME='{SPARK_HOME_VAR}' \\
    -e PYTHONPATH='{PYTHONPATH_VAR}' \\
    f1_etl_job \\
    papermill /home/jovyan/work/etl_raw_to_silver.ipynb /home/jovyan/work/etl_raw_to_silver.ipynb
"""

cmd_etl_gold = f"""
docker exec \\
    -e SPARK_HOME='{SPARK_HOME_VAR}' \\
    -e PYTHONPATH='{PYTHONPATH_VAR}' \\
    f1_etl_job \\
    papermill /home/jovyan/work/etl_silver_to_gold.ipynb /home/jovyan/work/etl_silver_to_gold.ipynb
"""

# --- Definição da DAG ---
with DAG(
    dag_id='formula1_pipeline_full_ipynb', 
    default_args=default_args,
    description='Pipeline ETL completo para dados da F1 (Raw -> Silver -> Gold) com limpeza idempotente', 
    schedule=None,
    start_date=days_ago(1),
    catchup=False,
    tags=['f1', 'etl', 'ipynb', 'idempotence'],
) as dag:

    # 1. Criação do esquema Silver (Tabela denormalizada única)
    task_1_run_ddl_silver = BashOperator(
        task_id='run_ddl_silver',
        bash_command=cmd_ddl_silver,
        env={'PGPASSWORD': '1234'},
    )
    
    # 2. NOVA TAREFA: LIMPAR TABELAS SILVER ANTES DO CARREGAMENTO
    # CORRIGIDO: Limpa APENAS a tabela ResultadosCorridas
    clear_silver_tables = PostgresOperator(
        task_id='clear_silver_tables',
        postgres_conn_id='f1_postgres_connection', 
        sql="TRUNCATE TABLE ResultadosCorridas RESTART IDENTITY;",
    )

    # 3. Execução do ETL Raw -> Silver
    task_2_run_etl_silver = BashOperator(
        task_id='run_etl_raw_to_silver_ipynb',
        bash_command=cmd_etl_silver,
    )
    
    # 4. Criação do esquema Gold (Tabelas Dimensionais)
    task_3_run_ddl_gold = BashOperator(
        task_id='run_ddl_gold',
        bash_command=cmd_ddl_gold,
        env={'PGPASSWORD': '1234'},
    )
    
    # 5. LIMPAR TABELAS GOLD ANTES DE CADA CARGA
    # Usa CASCADE em todas as dimensões referenciadas para limpar a Tabela Fato
    clear_gold_tables = PostgresOperator(
        task_id='clear_gold_tables',
        postgres_conn_id='f1_postgres_connection', 
        sql="""
        TRUNCATE TABLE gold.dm_piloto RESTART IDENTITY CASCADE; 
        TRUNCATE TABLE gold.dm_equipe RESTART IDENTITY CASCADE; 
        TRUNCATE TABLE gold.dm_corrida RESTART IDENTITY CASCADE; 
        TRUNCATE TABLE gold.dm_status RESTART IDENTITY CASCADE;
        """,
    )
    
    # 6. Execução do ETL Silver -> Gold
    task_4_run_etl_gold = BashOperator(
        task_id='run_etl_silver_to_gold_ipynb',
        bash_command=cmd_etl_gold,
    )

    # --- DEFINIÇÃO DA ORDEM CORRIGIDA ---
    # DDL Silver >> Limpeza Silver >> ETL Silver >> DDL Gold >> Limpeza Gold >> ETL Gold
    (
        task_1_run_ddl_silver 
        >> clear_silver_tables      # Limpa Silver (Corrigido)
        >> task_2_run_etl_silver    # Carrega Silver
        >> task_3_run_ddl_gold 
        >> clear_gold_tables        # Limpa Gold (Corrigido com CASCADE)
        >> task_4_run_etl_gold      # Carrega Gold
    )
