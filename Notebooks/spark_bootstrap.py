"""
Bootstrap de sessão Spark para notebooks locais.

Uso no Jupyter (na mesma pasta do notebook):

    %run spark_bootstrap.py
    # ou
    from spark_bootstrap import get_spark
    spark = get_spark()

Este script:
- Garante JAVA_HOME compatível (macOS: tenta 17 → 11 → 1.8).
- Define PYSPARK_* para o Python atual do kernel.
- Cria pastas locais e graváveis para tmp/warehouse dentro de Notebooks.
"""

from __future__ import annotations

import os
import sys
import platform
import subprocess
from pathlib import Path

try:
    from pyspark.sql import SparkSession
except Exception as e:  # pragma: no cover
    raise RuntimeError(
        "PySpark não encontrado. Instale com `pip install pyspark` no mesmo ambiente do Jupyter."
    ) from e


def _ensure_java_home() -> None:
    """Em macOS tenta localizar um Java compatível (17/11/8) e exporta JAVA_HOME.

    Spark 3.4/3.5 é compatível com Java 8/11/17. Em muitos Macs, o default pode
    ser 21/22, causando erro de gateway do Py4J. Este ajuste evita isso.
    """

    if platform.system() != "Darwin":
        return

    java_home = os.environ.get("JAVA_HOME", "")
    if any(v in java_home for v in ("1.8", "11", "17", "jdk-17", "jdk-11")):
        return  # já parece compatível

    selector = "/usr/libexec/java_home"
    if not Path(selector).exists():
        return

    for ver in ("17", "11", "1.8"):
        try:
            jh = subprocess.check_output([selector, "-v", ver], text=True).strip()
        except Exception:
            continue
        else:
            os.environ["JAVA_HOME"] = jh
            break


def _ensure_local_dirs(base_dir: Path) -> tuple[str, str]:
    """Cria diretórios locais para tmp/warehouse e exporta variáveis relacionadas."""
    tmp = (base_dir / ".spark-tmp").resolve()
    wh = (base_dir / ".spark-warehouse").resolve()
    tmp.mkdir(parents=True, exist_ok=True)
    wh.mkdir(parents=True, exist_ok=True)

    os.environ["SPARK_LOCAL_DIRS"] = str(tmp)
    os.environ["TMPDIR"] = str(tmp)
    return str(tmp), str(wh)


def get_spark(app_name: str = "F1-Analysis", base: str | os.PathLike[str] | None = None):
    """Cria (ou reutiliza) uma SparkSession local, robusta para notebooks.

    - Ajusta JAVA_HOME (macOS) se necessário.
    - Usa diretórios temporários locais dentro da pasta do notebook.
    - Garante que o Python do Spark seja o mesmo do kernel do Jupyter.
    """

    _ensure_java_home()

    # Alinha o Python do driver/executor com o kernel atual
    os.environ["PYSPARK_DRIVER_PYTHON"] = sys.executable
    os.environ["PYSPARK_PYTHON"] = sys.executable

    base_dir = Path(base) if base else Path(__file__).parent
    local_tmp, local_wh = _ensure_local_dirs(base_dir)

    builder = (
        SparkSession.builder.appName(app_name).master("local[*]")
        .config("spark.ui.showConsoleProgress", "false")
        .config("spark.local.dir", local_tmp)
        .config("spark.sql.warehouse.dir", local_wh)
        .config("spark.driver.extraJavaOptions", f"-Djava.io.tmpdir={local_tmp}")
        .config("spark.executor.extraJavaOptions", f"-Djava.io.tmpdir={local_tmp}")
    )

    return builder.getOrCreate()


if __name__ == "__main__":  # Permite `%run spark_bootstrap.py`
    spark = get_spark()
    print(spark)

