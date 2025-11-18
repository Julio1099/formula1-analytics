# Diagrama Entidade-Relacionamento (DER) — Camada Gold

## 1. Introdução

Este documento descreve o Diagrama Entidade-Relacionamento (DER) da Camada Gold do data lakehouse de Fórmula 1. O objetivo é apresentar uma visão lógica e visual do Star Schema que sustenta o modelo analítico, permitindo rápidas iterações de BI e governança consistente com o MER documentado em `mer_gold.md`.

A Camada Gold agrega métricas e dimensões já tratadas, otimizadas para consumo em dashboards que comparam pilotos, equipes, pit stops e incidentes. O DER garante que todos entendam a estrutura dimensional, as cardinalidades e os atributos fundamentais que suportam as consultas analíticas.

## 2. Visão Geral do DER

```mermaid
graph BT
    %% --- Estilização para parecer tabelas ---
    classDef table fill:#fff,stroke:#333,stroke-width:2px,align:left;
    classDef relation fill:#e0e0e0,stroke:#333,stroke-width:1px,shape:diamond;

    %% --- Dimensões (Top Layer) ---
    
    subgraph Dimensões
        direction LR
        DIM_PIL["<b>dim_pil</b>
        -------------------
        PK srk_pil
        UK chv_pil_org
        nom_prim
        sobrenome
        nom_comp"]:::table

        DIM_EQP["<b>dim_eqp</b>
        -------------------
        PK srk_eqp
        UK chv_eqp_org
        nom_eqp"]:::table

        DIM_COR["<b>dim_cor</b>
        -------------------
        PK srk_cor
        UK chv_cor_org
        ano
        rodada
        nom_cor"]:::table

        DIM_STS["<b>dim_sts</b>
        -------------------
        PK srk_sts
        UK chv_sts_org
        dsc_sts"]:::table
    end

    %% --- Relacionamentos (Losangos) ---
    
    REL_PIL{realiza}:::relation
    REL_EQP{participa}:::relation
    REL_COR{ocorre_em}:::relation
    REL_STS{registra}:::relation

    %% --- Tabela Fato (Bottom Layer) ---

    FAT["<b>fat_des_volt</b>
    -------------------
    PK srk_des_volt
    FK srk_pil
    FK srk_eqp
    FK srk_cor
    FK srk_sts
    volt
    pos_na_volt
    tmp_volt_ms
    dur_par_seg
    pts_pil
    vit_pil"]:::table

    %% --- Conexões com Cardinalidade ---
    
    %% Piloto (1) -- realiza --> (N) Fato
    DIM_PIL ---|1| REL_PIL
    REL_PIL -->|N| FAT

    %% Equipe (1) -- participa --> (N) Fato
    DIM_EQP ---|1| REL_EQP
    REL_EQP -->|N| FAT

    %% Corrida (1) -- ocorre_em --> (N) Fato
    DIM_COR ---|1| REL_COR
    REL_COR -->|N| FAT

    %% Status (1) -- registra --> (N) Fato
    DIM_STS ---|1| REL_STS
    REL_STS -->|N| FAT
```

**Fonte:** Autoria de [Fernando Carrijo](https://github.com/show-dawn), [Júlio Cesar](https://github.com/Julio1099), [Kaleb Macedo](https://github.com/kalebmacedo) e [Othavio Bolzan](https://github.com/bolzanMGB)

## 3. Componentes do Diagrama

- **fat_des_volt**: É a tabela de fato central. Cada linha representa a menor granularidade disponível (volta do piloto na corrida) e carrega métricas de tempo, pit stop, pontos e vitórias.

- **Dimensões** (`dim_pil`, `dim_eqp`, `dim_cor`, `dim_sts`): Oferecem contexto descritivo. Todas utilizam surrogate keys (`srk_...`) e mantêm a business key (`chv_..._org`) para rastreabilidade.

- **Cardinalidades**: As relações são `1:N`, partindo das dimensões (1) para a fato (N). Assim, um piloto pode existir sem registros na fato (0..N), mas cada ocorrência da fato referencia obrigatoriamente uma dimensão.

- **Integridade**: A fato possui a restrição única `(srk_pil, srk_cor, volt)`, garantindo unicidade do evento analítico.

## 4. Histórico de Versões

| Data | Versão | Descrição | Autor | Revisor |
| :--: | :----: | :-------- | :---- | :----- |
| 31/10/2025 | `1.0` | Documentação do DER. | [Kaleb Macedo](https://github.com/kalebmacedo), [Othavio Bolzan](https://github.com/bolzanMGB) |  |
| 16/11/2025 | 1.1 | Sincronização do DER com o DDL da Camada Gold. | [Júlio Cesar](https://github.com/Julio1099) |  [Othavio Bolzan](https://github.com/bolzanMGB) |

