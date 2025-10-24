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
