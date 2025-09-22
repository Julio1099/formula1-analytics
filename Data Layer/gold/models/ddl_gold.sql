-- DDL — Exemplo Camada Silver (edite conforme seu modelo)
CREATE TABLE IF NOT EXISTS silver.dim_tempo (
  id_tempo      integer PRIMARY KEY,
  ano           integer NOT NULL,
  mes           integer NOT NULL,
  dia           integer
);

CREATE TABLE IF NOT EXISTS silver.dim_entidade (
  id_entidade   integer PRIMARY KEY,
  nome          text NOT NULL,
  categoria     text,
  codigo_externo text
);

CREATE TABLE IF NOT EXISTS silver.fato_medida (
  id_fato       bigserial PRIMARY KEY,
  id_tempo      integer NOT NULL REFERENCES silver.dim_tempo(id_tempo),
  id_entidade   integer NOT NULL REFERENCES silver.dim_entidade(id_entidade),
  valor         numeric,
  unidade       text,
  origem_bronze text
);

-- Índices úteis
CREATE INDEX IF NOT EXISTS ix_fato_medida_tempo ON silver.fato_medida(id_tempo);
CREATE INDEX IF NOT EXISTS ix_fato_medida_entidade ON silver.fato_medida(id_entidade);
