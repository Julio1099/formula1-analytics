# Modelo Entidade-Relacionamento (MER) - Camada GOLD

## 1. Introdução

O modelo da Camada Gold (Data Warehouse) adota o padrão **Star Schema (Esquema Estrela)**. Esta estrutura é otimizada para consultas analíticas (OLAP), separando os dados em uma única Tabela de Fato central (`FT_VOLTAS_TEMPO_PARADA`) e quatro Dimensões circundantes, conectadas por chaves sub-rogadas (`SRK`).

O objetivo é fornecer uma visão limpa e dimensionalizada para análises de desempenho por volta e paradas nos boxes.

## 2. Diagrama Lógico (Star Schema)

Este diagrama representa o relacionamento de 1 para N (Um para Muitos) entre as Dimensões e a Tabela de Fato.

```mermaid
erDiagram
    DM_PILOTO ||--o{ FT_VOLTAS_TEMPO_PARADA : "Tem"
    DM_EQUIPE ||--o{ FT_VOLTAS_TEMPO_PARADA : "Faz parte"
    DM_CORRIDA ||--o{ FT_VOLTAS_TEMPO_PARADA : "Acontece em"
    DM_STATUS ||--o{ FT_VOLTAS_TEMPO_PARADA : "Resulta em"

    DM_PILOTO {
        SERIAL srk_piloto PK "Chave Sub-rogada"
        INTEGER chave_piloto_origem "Chave de Negócio (BK)"
        VARCHAR primeiro_nome
        VARCHAR sobrenome
        VARCHAR nome_completo "Nome Completo (Gerado)"
    }
    
    DM_EQUIPE {
        SERIAL srk_equipe PK "Chave Sub-rogada"
        INTEGER chave_equipe_origem "Chave de Negócio (BK)"
        VARCHAR nome_equipe
    }
    
    DM_CORRIDA {
        SERIAL srk_corrida PK "Chave Sub-rogada"
        INTEGER chave_corrida_origem "Chave de Negócio (BK)"
        INTEGER ano
        INTEGER rodada
        VARCHAR nome_corrida
    }
    
    DM_STATUS {
        SERIAL srk_status PK "Chave Sub-rogada"
        INTEGER chave_status_origem "Chave de Negócio (BK)"
        VARCHAR descricao_status
    }
    
    FT_VOLTAS_TEMPO_PARADA {
        BIGSERIAL srk_tempo_volta PK "Chave Sub-rogada"
        INTEGER srk_piloto FK "Referência à DM_PILOTO"
        INTEGER srk_equipe FK "Referência à DM_EQUIPE"
        INTEGER srk_corrida FK "Referência à DM_CORRIDA"
        INTEGER srk_status FK "Referência à DM_STATUS"
        INTEGER volta
        INTEGER posicao_na_volta
        INTEGER tempo_volta_ms "Tempo da volta em ms"
        DECIMAL duracao_parada_seg "Duração do pit stop em segundos"
        DECIMAL pontos_piloto "Pontos obtidos na corrida"
        INTEGER vitorias_piloto "Indicador de vitória"
    }
```

### 2.1. Visão Estrela Simplificada

```
                 DM_PILOTO
                     |
DM_STATUS ---- FT_VOLTAS_TEMPO_PARADA ---- DM_EQUIPE
                     |
                 DM_CORRIDA
```

*As ligações indicam relacionamentos 1:N partindo das dimensões (1) para a tabela fato (N).* 

## 3. Descrição das Entidades

### 3.1. Fato: FT_VOLTAS_TEMPO_PARADA

A Tabela de Fato captura as métricas de desempenho de um piloto em uma volta ou o tempo de parada nos boxes. É a granularidade mais fina do modelo.

| Atributo | Chave | Tipo SQL | Descrição |
|-----------|--------|----------|------------|
| srk_tempo_volta | PK | BIGSERIAL | Chave primária. Identificador único do registro de fato. |
| srk_piloto | FK | INTEGER | Chave estrangeira para o Piloto. |
| srk_equipe | FK | INTEGER | Chave estrangeira para a Equipe/Construtora. |
| srk_corrida | FK | INTEGER | Chave estrangeira para a Corrida. |
| srk_status | FK | INTEGER | Chave estrangeira para o Status de Resultado. |
| volta |  | INTEGER | Número da volta registrada. |
| posicao_na_volta |  | INTEGER | Posição do piloto ao cruzar a linha de chegada da volta. |
| tempo_volta_ms |  | INTEGER | Tempo total da volta em milissegundos. |
| duracao_parada_seg |  | DECIMAL(10, 3) | Duração da parada nos boxes em segundos (0 se não houve parada naquela volta). |
| pontos_piloto |  | DECIMAL(10, 1) | Pontos obtidos pelo piloto na corrida (repetidos em todas as voltas daquela prova). |
| vitorias_piloto |  | INTEGER | Indicador 1/0 se o piloto venceu a corrida (repetido nas voltas da prova). |

**UNIQUE:** `(srk_piloto, srk_corrida, volta)`

---

### 3.2. Dimensão: DM_PILOTO

Armazena atributos estáticos sobre os pilotos.

| Atributo | Chave | Tipo SQL | Descrição |
|-----------|--------|----------|------------|
| srk_piloto | PK | SERIAL | Chave primária. |
| chave_piloto_origem | BK | INTEGER | Chave de Negócio (Business Key). ID original do piloto na Camada Silver/Raw. |
| primeiro_nome |  | VARCHAR(255) | Primeiro nome. |
| sobrenome |  | VARCHAR(255) | Sobrenome. |
| nome_completo |  | VARCHAR(510) | Nome e sobrenome concatenados (coluna gerada). |

---

### 3.3. Dimensão: DM_EQUIPE

Armazena atributos estáticos sobre as equipes/construtoras.

| Atributo | Chave | Tipo SQL | Descrição |
|-----------|--------|----------|------------|
| srk_equipe | PK | SERIAL | Chave primária. |
| chave_equipe_origem | BK | INTEGER | Chave de Negócio. ID original da equipe. |
| nome_equipe |  | VARCHAR(255) | Nome oficial da equipe. |

---

### 3.4. Dimensão: DM_CORRIDA

Armazena atributos estáticos sobre as corridas.

| Atributo | Chave | Tipo SQL | Descrição |
|-----------|--------|----------|------------|
| srk_corrida | PK | SERIAL | Chave primária. |
| chave_corrida_origem | BK | INTEGER | Chave de Negócio. ID original da corrida. |
| ano |  | INTEGER | Ano da temporada. |
| rodada |  | INTEGER | Número da rodada no calendário. |
| nome_corrida |  | VARCHAR(255) | Nome do Grande Prêmio. |

---

### 3.5. Dimensão: DM_STATUS

Armazena atributos sobre o status final do piloto.

| Atributo | Chave | Tipo SQL | Descrição |
|-----------|--------|----------|------------|
| srk_status | PK | SERIAL | Chave primária. |
| chave_status_origem | BK | INTEGER | Chave de Negócio. ID original do status. |
| descricao_status |  | VARCHAR(255) | Descrição textual do status (e.g., Finished, Accident, Engine). |


## Histórico de Versão

| Data | Versão | Descrição | Autor | Revisor |
| :---: | :---: | :--- | :--- | :--- |
| 29/10/2025 | `1.0` | Criação inicial do MER para Fórmula 1. | [Júlio Cesar](https://github.com/Julio1099) | [Kaleb Macedo](https://github.com/kalebmacedo) |
| 30/10/2025 | `1.1` | Criação do diagrama para o MER | [Kaleb Macedo](https://github.com/kalebmacedo)|  |

