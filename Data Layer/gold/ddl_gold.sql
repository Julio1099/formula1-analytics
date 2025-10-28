-- DDL para a Camada Gold (Data Warehouse)
-- Padrão de Chave: SRK (Surrogate Key) para PK e FK
-- Padrão de Chave de Negócio: CHAVE_..._ORIGEM (Para evitar o termo "ID")

CREATE SCHEMA IF NOT EXISTS gold;

-------------------------------------
-- 1. DIMENSÕES
-------------------------------------

-- 1.1. Dimensão Piloto (DM_PILOTO)
CREATE TABLE IF NOT EXISTS gold.dm_piloto (
    srk_piloto              SERIAL PRIMARY KEY, -- Chave Sub-rogada (PK)
    chave_piloto_origem     INTEGER UNIQUE NOT NULL, -- Chave de Negócio (BK) - Antigo id_piloto
    primeiro_nome           VARCHAR(255) NOT NULL, 
    sobrenome               VARCHAR(255) NOT NULL,
    nome_completo           VARCHAR(510) GENERATED ALWAYS AS (primeiro_nome || ' ' || sobrenome) STORED
);

-- 1.2. Dimensão Equipe (DM_EQUIPE)
CREATE TABLE IF NOT EXISTS gold.dm_equipe (
    srk_equipe              SERIAL PRIMARY KEY,
    chave_equipe_origem     INTEGER UNIQUE NOT NULL, -- Antigo id_equipe
    nome_equipe             VARCHAR(255) NOT NULL
);

-- 1.3. Dimensão Corrida (DM_CORRIDA)
CREATE TABLE IF NOT EXISTS gold.dm_corrida (
    srk_corrida             SERIAL PRIMARY KEY,
    chave_corrida_origem    INTEGER UNIQUE NOT NULL, -- Antigo id_corrida
    ano                     INTEGER NOT NULL,
    rodada                  INTEGER NOT NULL,
    nome_corrida            VARCHAR(255) NOT NULL
);

-- 1.4. Dimensão Status (DM_STATUS)
CREATE TABLE IF NOT EXISTS gold.dm_status (
    srk_status              SERIAL PRIMARY KEY,
    chave_status_origem     INTEGER UNIQUE NOT NULL, -- Antigo id_status
    descricao_status        VARCHAR(255) NOT NULL
);

-------------------------------------
-- 2. TABELA DE FATO
-------------------------------------

-- Tabela de Fato: Desempenho por Volta e Pit Stop
CREATE TABLE IF NOT EXISTS gold.ft_voltas_tempo_parada (
    srk_tempo_volta         BIGSERIAL PRIMARY KEY, -- Chave Sub-rogada
    
    -- Chaves Estrangeiras (Foreign Keys)
    srk_piloto              INTEGER NOT NULL REFERENCES gold.dm_piloto(srk_piloto),
    srk_equipe              INTEGER NOT NULL REFERENCES gold.dm_equipe(srk_equipe),
    srk_corrida             INTEGER NOT NULL REFERENCES gold.dm_corrida(srk_corrida),
    srk_status              INTEGER NOT NULL REFERENCES gold.dm_status(srk_status),
    
    -- Métricas e Atributos de Fato
    volta                   INTEGER NOT NULL,
    posicao_na_volta        INTEGER,
    tempo_volta_ms          INTEGER,
    duracao_parada_seg      DECIMAL(10, 3) NOT NULL DEFAULT 0,
    
    UNIQUE (srk_piloto, srk_corrida, volta) 
);
