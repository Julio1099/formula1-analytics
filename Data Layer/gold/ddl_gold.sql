-- DDL para a Camada Gold (Data Warehouse)
-- Padrão de Chave: SRK (Surrogate Key) para PK e FK
-- Padrão de Chave de Negócio: CHV_..._ORG (Para evitar o termo "ID")

CREATE SCHEMA IF NOT EXISTS gold;

-------------------------------------
-- 1. DIMENSÕES
-------------------------------------

-- 1.1. Dimensão Piloto (DIM_PIL)
CREATE TABLE IF NOT EXISTS gold.dim_pil (
    srk_pil         SERIAL PRIMARY KEY,
    chv_pil_org     INTEGER UNIQUE NOT NULL,
    prim_nom        VARCHAR(255) NOT NULL,
    sob_nom         VARCHAR(255) NOT NULL,
    nom_com         VARCHAR(510) GENERATED ALWAYS AS (prim_nom || ' ' || sob_nom) STORED
);

-- 1.2. Dimensão Equipe (DIM_EQP)
CREATE TABLE IF NOT EXISTS gold.dim_eqp (
    srk_eqp         SERIAL PRIMARY KEY,
    chv_eqp_org     INTEGER UNIQUE NOT NULL,
    nom_eqp         VARCHAR(255) NOT NULL
);

-- 1.3. Dimensão Corrida (DIM_COR)
CREATE TABLE IF NOT EXISTS gold.dim_cor (
    srk_cor         SERIAL PRIMARY KEY,
    chv_cor_org     INTEGER UNIQUE NOT NULL,
    ano             INTEGER NOT NULL,
    rod             INTEGER NOT NULL,
    nom_cor         VARCHAR(255) NOT NULL
);

-- 1.4. Dimensão Status (DIM_STS)
CREATE TABLE IF NOT EXISTS gold.dim_sts (
    srk_sts         SERIAL PRIMARY KEY,
    chv_sts_org     INTEGER UNIQUE NOT NULL,
    des_sts         VARCHAR(255) NOT NULL
);

-------------------------------------
-- 2. TABELA DE FATO
-------------------------------------

-- Tabela de Fato: Desempenho por Volta
CREATE TABLE IF NOT EXISTS gold.fat_des_volt (
    srk_tmp_volt    BIGSERIAL PRIMARY KEY,
    srk_pil         INTEGER NOT NULL REFERENCES gold.dim_pil(srk_pil),
    srk_eqp         INTEGER NOT NULL REFERENCES gold.dim_eqp(srk_eqp),
    srk_cor         INTEGER NOT NULL REFERENCES gold.dim_cor(srk_cor),
    srk_sts         INTEGER NOT NULL REFERENCES gold.dim_sts(srk_sts),

    volt            INTEGER NOT NULL,
    pos_volt        INTEGER,
    tmp_volt_ms     INTEGER,
    dur_par_seg     DECIMAL(10, 3) NOT NULL DEFAULT 0,

    pnt_pil         DECIMAL(10, 1) NOT NULL DEFAULT 0,
    vit_pil         INTEGER NOT NULL DEFAULT 0,

    UNIQUE (srk_pil, srk_cor, volt)
);