# Data Definition Language (DDL)

## 1. Introdução

A linguagem DDL define a estrutura física das tabelas no banco de dados. Com a modelagem Silver consolidada em uma única entidade, o script DDL precisa somente criar a tabela `ResultadosCorridas`, garantindo que todos os atributos estejam disponíveis para análises, mas sem impor relacionamentos ou chaves estrangeiras.

## 2. Estrutura do Banco de Dados

Abaixo está o comando `CREATE TABLE` utilizado para materializar a camada Silver. Ele é equivalente ao conteúdo do arquivo `ddl_silver.sql`.

```sql
CREATE TABLE IF NOT EXISTS ResultadosCorridas (
    id_corrida INTEGER NOT NULL,
    id_piloto INTEGER NOT NULL,
    id_equipe INTEGER,
    id_status INTEGER,
    ano INTEGER NOT NULL,
    rodada INTEGER NOT NULL,
    nome_corrida VARCHAR(100) NOT NULL,
    volta INTEGER,
    posicao_na_volta INTEGER,
    tempo_volta_ms INTEGER,
    duracao_parada_seg DECIMAL(10, 3),
    primeiro_nome_piloto VARCHAR(100) NOT NULL,
    sobrenome_piloto VARCHAR(100) NOT NULL,
    nome_equipe VARCHAR(100),
    descricao_status VARCHAR(255)
);
```

> A tabela não possui chave primária nem restrições de chave estrangeira. Essa decisão foi tomada para evitar conflitos durante a carga de registros que não possuem informações de volta ou de chaves de referência completas.

## Histórico de versão

|    Data    | Versão |                 Descrição                 |                   Autor                   |                   Revisor                  |
|:----------:|:------:|:-----------------------------------------:|:-----------------------------------------:|:------------------------------------------:|
| 09/10/2025 | `1.0`  | Criação do DDL para Fórmula 1             | [Fernando Gabriel](https://github.com/show-dawn) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 09/10/2025 | `1.1`  | Fix da documentação                       | [Fernando Gabriel](https://github.com/show-dawn) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 09/10/2025 | `1.2`  | Fix histórico de versão                   | [Fernando Gabriel](https://github.com/show-dawn) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 09/10/2025 | `1.3`  | Padronização da documentação              | [Fernando Gabriel](https://github.com/show-dawn) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 24/10/2025 | `1.4`  | Adequação do DDL para tabela única        | [Kaleb Macedo](https://github.com/kalebmacedo) | [Júlio Cesar](https://github.com/Julio1099) |
