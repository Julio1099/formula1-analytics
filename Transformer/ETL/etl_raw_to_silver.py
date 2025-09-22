import os
import glob
import re
import sys
import time
import yaml
from datetime import datetime
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

# ------------------------ Config & Env ------------------------
ROOT = Path(__file__).resolve().parents[1]
BRONZE_DIR = ROOT / "bronze" / "dados_originais"

def snake_case(s: str) -> str:
    s = s.strip().replace("/", "_").replace("-", "_")
    s = re.sub(r"[^\w]+", "_", s, flags=re.UNICODE)
    s = re.sub(r"_+", "_", s)
    return s.strip("_").lower()

def load_config():
    cfg_path = ROOT / "silver" / "config.yml"
    if cfg_path.exists():
        with open(cfg_path, "r", encoding="utf-8") as f:
            return yaml.safe_load(f) or {}
    return {}

def get_db_engine():
    db = os.getenv("POSTGRES_DB", "medallion")
    user = os.getenv("POSTGRES_USER", "medallion")
    pwd = os.getenv("POSTGRES_PASSWORD", "medallion")
    host = os.getenv("POSTGRES_HOST", "db")
    port = os.getenv("POSTGRES_PORT", "5432")

    url = URL.create(
        "postgresql+psycopg2",
        username=user,
        password=pwd,
        host=host,
        port=int(port),
        database=db,
    )
    return create_engine(url, pool_pre_ping=True)

def ensure_schema(engine, schema_name="silver"):
    with engine.begin() as conn:
        conn.execute(text(f'CREATE SCHEMA IF NOT EXISTS "{schema_name}";'))

def create_index(engine, table_full, df: pd.DataFrame, pk_hint: str | None):
    """Cria um índice básico: se pk_hint existir usa ele, senão usa a primeira coluna."""
    schema, table = table_full.split(".")
    with engine.begin() as conn:
        # Tenta PK informada
        if pk_hint and pk_hint in df.columns:
            idx_name = f"idx_{table}_{pk_hint}"
            conn.execute(text(f'CREATE INDEX IF NOT EXISTS "{idx_name}" ON "{schema}"."{table}" ("{pk_hint}");'))
            return idx_name

        # Senão, usa a primeira coluna
        first_col = df.columns[0]
        idx_name = f"idx_{table}_{first_col}"
        conn.execute(text(f'CREATE INDEX IF NOT EXISTS "{idx_name}" ON "{schema}"."{table}" ("{first_col}");'))
        return idx_name

def read_csv_any(path, delimiter=",", encoding="utf-8", parse_dates=None, infer_datetime=True):
    try:
        return pd.read_csv(path, sep=delimiter, encoding=encoding, parse_dates=parse_dates, infer_datetime_format=infer_datetime, low_memory=False)
    except UnicodeDecodeError:
        # Tenta latin1 se utf-8 falhar
        return pd.read_csv(path, sep=delimiter, encoding="latin1", parse_dates=parse_dates, infer_datetime_format=infer_datetime, low_memory=False)

def main():
    cfg = load_config()
    delimiter = cfg.get("delimiter", ",")
    encoding = cfg.get("encoding", "utf-8")
    infer_dt = cfg.get("infer_datetime", True)
    per_file = cfg.get("files", {}) or {}

    if not BRONZE_DIR.exists():
        print(f"[ERRO] Diretório Bronze não encontrado: {BRONZE_DIR}", file=sys.stderr)
        sys.exit(1)

    csvs = sorted(glob.glob(str(BRONZE_DIR / "*.csv")))
    if not csvs:
        print(f"[AVISO] Nenhum CSV encontrado em {BRONZE_DIR}. Coloque seus dados e rode novamente.")
        return

    engine = get_db_engine()
    ensure_schema(engine, "silver")

    for csv_path in csvs:
        p = Path(csv_path)
        name = p.stem  # nome do arquivo sem extensão
        print(f"\n[ETL] Processando arquivo: {p.name}")

        file_rules = per_file.get(name, {})
        delim = file_rules.get("delimiter", delimiter)
        enc = file_rules.get("encoding", encoding)
        parse_dates = file_rules.get("parse_dates")
        pk_hint = file_rules.get("primary_key")

        df = read_csv_any(csv_path, delimiter=delim, encoding=enc, parse_dates=parse_dates, infer_datetime=infer_dt)

        # Normaliza colunas
        df.columns = [snake_case(c) for c in df.columns]

        # Limpeza mínima
        df = df.drop_duplicates().copy()

        # Adiciona colunas de auditoria
        df["ingestion_time_utc"] = datetime.utcnow()

        table = f"silver.{snake_case(name)}_clean"
        print(f"[ETL] Gravando {len(df):,} linhas em {table} ...")

        # Persistência
        df.to_sql(table.split(".")[1], con=engine, schema="silver", if_exists="replace", index=False, method="multi", chunksize=20_000)

        # Índice
        idx_name = create_index(engine, table, df, pk_hint)
        print(f"[ETL] Índice criado/verificado: {idx_name}")

    print("\n[ETL] Concluído com sucesso!")

if __name__ == "__main__":
    main()
