"""
Funções auxiliares para um gráfico único que resume TODAS as tabelas.

O gráfico padrão é um barplot com a contagem de linhas por tabela,
para dar uma visão global do volume de dados em cada CSV.

Uso no notebook:

    from spark_bootstrap import get_spark
    from combined_overview import load_all_csvs, plot_rowcount_overview

    spark = get_spark()
    base = 'Data Layer/raw/dados_originais'
    dfs = load_all_csvs(spark, base)
    plot_rowcount_overview(dfs)
"""

from __future__ import annotations

from typing import Dict
from pathlib import Path

import matplotlib
matplotlib.use("Agg")  # evita backends interativos no Jupyter remoto
import matplotlib.pyplot as plt
import seaborn as sns


def load_all_csvs(spark, base_path: str | Path) -> Dict[str, "DataFrame"]:
    """Lê todos os CSVs do diretório em um dict {nome_tabela: DataFrame}.

    - Usa o nome do arquivo (sem .csv) como nome de tabela.
    - Define opções comuns de leitura (header=True, inferSchema=True).
    """
    base = Path(base_path)
    assert base.exists(), f"Diretório não encontrado: {base}"

    csvs = sorted(base.glob("*.csv"))
    assert csvs, f"Nenhum CSV encontrado em: {base}"

    options = {
        "header": True,
        "inferSchema": True,
        # Ajuste se necessário: separador, encoding etc.
    }

    dfs: Dict[str, "DataFrame"] = {}
    for p in csvs:
        name = p.stem
        df = spark.read.options(**options).csv(str(p))
        dfs[name] = df
    return dfs


def plot_rowcount_overview(dfs: Dict[str, "DataFrame" ], figsize=(10, 6)):
    """Plota um único gráfico (barplot) com a contagem de linhas por tabela.

    Observação: df.count() aciona um job no Spark; com arquivos grandes
    pode demorar, mas é a métrica mais direta de volume.
    """
    data = []
    for name, df in dfs.items():
        try:
            n = df.count()
        except Exception as e:  # captura erro por tabela e continua
            n = None
        data.append((name, n))

    # Ordena por contagem (None por último)
    data_sorted = sorted(
        data,
        key=lambda x: (-1 if x[1] is None else x[1])
    )

    labels = [k for k, _ in data_sorted]
    counts = [v if v is not None else 0 for _, v in data_sorted]

    plt.figure(figsize=figsize)
    ax = sns.barplot(x=counts, y=labels, palette="crest")
    ax.set_title("Contagem de linhas por tabela (CSV)")
    ax.set_xlabel("Linhas")
    ax.set_ylabel("Tabela")

    # Anota valores nas barras
    for i, v in enumerate(counts):
        ax.text(v, i, f" {v:,}".replace(",", "."), va="center")

    plt.tight_layout()
    plt.show()

