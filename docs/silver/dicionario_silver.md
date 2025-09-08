# Dicionário de Dados — Camada Silver (Template)

| Tabela          | Coluna          | Tipo       | Regra de Transformação (Raw→Silver)         | Origem (arquivo/coluna) |
|-----------------|------------------|------------|----------------------------------------------|-------------------------|
| dim_entidade    | id_entidade      | integer    | surrogate key                                 | -                       |
| dim_entidade    | nome             | text       | normalização/trim                             | arquivo.csv / coluna X  |
| fato_medida     | valor            | numeric    | cast de string→numeric, troca vírgula por ponto| arquivo.csv / coluna Y  |
