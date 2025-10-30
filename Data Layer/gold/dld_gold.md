#  Dicionário de Linhas e Detalhes (DLD) - Camada GOLD

Este documento detalha cada tabela, coluna e a lógica de transformação (ETL) utilizada para popular a Camada Gold (Data Warehouse), que segue o padrão Dimensional (Star Schema).

## 1. Tabela de Fato: FT_VOLTAS_TEMPO_PARADA

Captura as métricas de desempenho por volta e de paradas nos boxes.

| Coluna | Tipo SQL | Chave | Descrição | Origem (Silver) | Lógica de População (ETL Silver -> Gold) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `srk_tempo_volta` | `BIGSERIAL` | **PK** | Chave sub-rogada (PK) da tabela de fato. | (Gerada) | Gerada automaticamente pelo PostgreSQL. |
| `srk_piloto` | `INTEGER` | **FK** | Chave sub-rogada para a dimensão Piloto. | `id_piloto` | JOIN com `DM_PILOTO` (usando `id_piloto` da Silver = `chave_piloto_origem` da Gold). |
| `srk_equipe` | `INTEGER` | **FK** | Chave sub-rogada para a dimensão Equipe. | `id_equipe` | JOIN com `DM_EQUIPE` (usando `id_equipe` como Business Key). |
| `srk_corrida` | `INTEGER` | **FK** | Chave sub-rogada para a dimensão Corrida. | `id_corrida` | JOIN com `DM_CORRIDA` (usando `id_corrida` como Business Key). |
| `srk_status` | `INTEGER` | **FK** | Chave sub-rogada para a dimensão Status. | `id_status` | JOIN com `DM_STATUS` (usando `id_status` como Business Key). |
| `volta` | `INTEGER` | | Número da volta do circuito. | `volta` | Direto da Silver, com CAST para `IntegerType`. Registros onde `volta` é NULL são FILTRADOS no ETL. |
| `posicao_na_volta` | `INTEGER` | | Posição do piloto na volta. | `posicao_na_volta` | CAST para `IntegerType`. |
| `tempo_volta_ms` | `INTEGER` | | Tempo total da volta em milissegundos. | `tempo_volta_ms` | Direto da Silver, com CAST para `IntegerType`. Registros onde `tempo_volta_ms` é NULL são FILTRADOS no ETL. |
| `duracao_parada_seg` | `DECIMAL(10, 3)` | | Duração da parada nos boxes em segundos. | `duracao_parada_seg` | CAST para `DecimalType(10, 3)`. |

---

## 2. Dimensões

### 2.1. Dimensão: DM_PILOTO

Armazena atributos estáticos sobre os pilotos.

| Coluna | Tipo SQL | Chave | Descrição | Origem (Silver) | Lógica de População (ETL Silver -> Gold) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `srk_piloto` | `SERIAL` | **PK** | Chave sub-rogada da Dimensão. | (Gerada) | Gerada automaticamente pelo PostgreSQL. |
| `chave_piloto_origem` | `INTEGER` | **BK** | Chave de Negócio. ID do piloto na origem. | `id_piloto` | Renomeado de `id_piloto` para `chave_piloto_origem` e selecionado como DISTINCT. |
| `primeiro_nome` | `VARCHAR(255)` | | Primeiro nome do piloto. | `primeiro_nome_piloto` | Alias. Unicidade garantida por `chave_piloto_origem`. |
| `sobrenome` | `VARCHAR(255)` | | Sobrenome do piloto. | `sobrenome_piloto` | Alias. Unicidade garantida por `chave_piloto_origem`. |
| `nome_completo` | `VARCHAR(510)` | | Nome e sobrenome combinados. | - | Coluna GERADA (Calculated Column) no DDL do PostgreSQL: `(primeiro_nome || ' ' || sobrenome) STORED`. |

### 2.2. Dimensão: DM_EQUIPE

Armazena atributos estáticos sobre as equipes/construtoras.

| Coluna | Tipo SQL | Chave | Descrição | Origem (Silver) | Lógica de População (ETL Silver -> Gold) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `srk_equipe` | `SERIAL` | **PK** | Chave sub-rogada da Dimensão. | (Gerada) | Gerada automaticamente pelo PostgreSQL. |
| `chave_equipe_origem` | `INTEGER` | **BK** | Chave de Negócio. ID da equipe na origem. | `id_equipe` | Renomeado de `id_equipe` para `chave_equipe_origem` e selecionado como DISTINCT. |
| `nome_equipe` | `VARCHAR(255)` | | Nome oficial da equipe. | `nome_equipe` | Direto da Silver. Unicidade garantida por `chave_equipe_origem`. |

### 2.3. Dimensão: DM_CORRIDA

Armazena atributos estáticos sobre as corridas.

| Coluna | Tipo SQL | Chave | Descrição | Origem (Silver) | Lógica de População (ETL Silver -> Gold) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `srk_corrida` | `SERIAL` | **PK** | Chave sub-rogada da Dimensão. | (Gerada) | Gerada automaticamente pelo PostgreSQL. |
| `chave_corrida_origem` | `INTEGER` | **BK** | Chave de Negócio. ID da corrida na origem. | `id_corrida` | Renomeado de `id_corrida` para `chave_corrida_origem` e selecionado como DISTINCT. |
| `ano` | `INTEGER` | | Ano da temporada. | `ano` | Direto da Silver. |
| `rodada` | `INTEGER` | | Número da rodada no calendário. | `rodada` | Direto da Silver. |
| `nome_corrida` | `VARCHAR(255)` | | Nome do Grande Prêmio. | `nome_corrida` | Direto da Silver. |

### 2.4. Dimensão: DM_STATUS

Armazena atributos sobre o status final do piloto.

| Coluna | Tipo SQL | Chave | Descrição | Origem (Silver) | Lógica de População (ETL Silver -> Gold) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `srk_status` | `SERIAL` | **PK** | Chave sub-rogada da Dimensão. | (Gerada) | Gerada automaticamente pelo PostgreSQL. |
| `chave_status_origem` | `INTEGER` | **BK** | Chave de Negócio. ID do status na origem. | `id_status` | Renomeado de `id_status` para `chave_status_origem` e selecionado como DISTINCT. |
| `descricao_status` | `VARCHAR(255)` | | Descrição textual do status (e.g., Finished, Accident). | `descricao_status` | Direto da Silver. |

## Histórico de versão

| Data | Versão | Descrição | Autor | Revisor |
|:---:|:---:|:---:|:---:|:---:|
| 29/10/2025 | `1.0`      | Ajuste para representação de tabela única | [Júlio Cesar](https://github.com/Julio1099) | [Kaleb Macedo](https://github.com/kalebmacedo) |

