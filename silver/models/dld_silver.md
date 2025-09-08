# DLD — Camada Silver (Template)

| Tabela         | Coluna          | Tipo       | Nulável | Descrição                         |
|----------------|------------------|------------|---------|-----------------------------------|
| dim_tempo      | id_tempo (PK)    | integer    | não     | Chave surrogate                   |
|                | ano              | integer    | não     | Ano                                |
|                | mes              | integer    | não     | Mês                                |
|                | dia              | integer    | sim     | Dia do mês                         |
| dim_entidade   | id_entidade (PK) | integer    | não     | Chave surrogate                   |
|                | nome             | text       | não     | Nome da entidade                   |
|                | categoria        | text       | sim     | Categoria/Tipo                     |
|                | codigo_externo   | text       | sim     | Código do sistema de origem        |
| fato_medida    | id_fato (PK)     | bigserial  | não     | Chave surrogate                    |
|                | id_tempo (FK)    | integer    | não     | FK para dim_tempo                  |
|                | id_entidade (FK) | integer    | não     | FK para dim_entidade               |
|                | valor            | numeric    | sim     | Métrica principal                  |
|                | unidade          | text       | sim     | Unidade de medida                  |
|                | origem_bronze    | text       | sim     | Nome do arquivo/linha de origem    |

> Use este DLD como guia; se seu Silver for mais "wide table" inicialmente, documente aqui do mesmo jeito.
