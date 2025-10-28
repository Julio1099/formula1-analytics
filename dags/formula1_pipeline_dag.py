import pendulum
from datetime import datetime
from airflow.models.dag import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
}

# --- Variáveis de Ambiente Essenciais para PySpark (Caminhos Corretos do Ambiente) ---
SPARK_HOME_VAR = "/usr/local/spark" # <-- Correto via interactive shell
PY4J_PATH = f"{SPARK_HOME_VAR}/python/lib/py4j-0.10.9.7-src.zip" # <-- Correto via interactive shell
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
    dag_id='formula1_pipeline_full_ipynb', # Mantendo o mesmo ID
    default_args=default_args,
    description='Pipeline ETL completo para dados da F1 (Raw -> Silver -> Gold) via .ipynb com Papermill e Env Vars v2', # Descrição atualizada
    schedule=None,
    start_date=pendulum.datetime(2023, 1, 1, tz="UTC"),
    catchup=False,
    tags=['f1', 'etl', 'ipynb', 'papermill'],
) as dag:

    task_1_run_ddl_silver = BashOperator(
        task_id='run_ddl_silver',
        bash_command=cmd_ddl_silver,
        env={'PGPASSWORD': '1234'},
    )
    task_2_run_etl_silver = BashOperator(
        task_id='run_etl_raw_to_silver_ipynb',
        bash_command=cmd_etl_silver,
    )
    task_3_run_ddl_gold = BashOperator(
        task_id='run_ddl_gold',
        bash_command=cmd_ddl_gold,
        env={'PGPASSWORD': '1234'},
    )
    task_4_run_etl_gold = BashOperator(
        task_id='run_etl_silver_to_gold_ipynb',
        bash_command=cmd_etl_gold,
    )

    task_1_run_ddl_silver >> task_2_run_etl_silver >> task_3_run_ddl_gold >> task_4_run_etl_gold