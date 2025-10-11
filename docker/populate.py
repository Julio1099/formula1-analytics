from pyspark.sql import SparkSession
from pyspark.sql.utils import AnalysisException

spark = SparkSession.builder \
    .appName("PopulateFormula1") \
    .config("spark.jars.packages", "org.postgresql:postgresql:42.6.0") \
    .getOrCreate()

jdbc_url = "jdbc:postgresql://db:5432/formula1"
db_properties = {
    "user": "postgres",
    "password": "postgres",
    "driver": "org.postgresql.Driver"
}

tabelas = [
    "constructors",
    "drivers",
    "races",
    "lap_times_fact",
    "pit_stops",   
    "results",     
    "status"
]

def carregar_e_inserir(nome_tabela):
    caminho = f"/dados/{nome_tabela}"
    print(f"📂 Lendo dados de: {caminho}")
    try:
        df = spark.read.parquet(caminho)
        print(f"✅ {nome_tabela}: {df.count()} linhas carregadas")

        df.write.jdbc(
            url=jdbc_url,
            table=nome_tabela,
            mode="overwrite",
            properties=db_properties
        )
        print(f"💾 Dados inseridos em: {nome_tabela}")

    except AnalysisException as e:
        print(f"⚠️ Erro ao ler {nome_tabela}: {e}")
    except Exception as e:
        print(f"❌ Erro ao inserir {nome_tabela}: {e}")

for tabela in tabelas:
    carregar_e_inserir(tabela)

print("🏁 Processo de carga concluído com sucesso!")

spark.stop()
