CREATE TABLE IF NOT EXISTS ResultadosCorridasPorVolta (

    id_corrida INTEGER NOT NULL,
    id_piloto INTEGER NOT NULL,
    id_equipe INTEGER,
    id_status INTEGER,

    ano INTEGER,
    rodada INTEGER,
    nome_corrida VARCHAR(100),
    volta INTEGER NOT NULL,
    posicao_na_volta INTEGER,
    tempo_volta_ms INTEGER,
    duracao_parada_seg DECIMAL(10, 3),

    primeiro_nome_piloto VARCHAR(100),
    sobrenome_piloto VARCHAR(100),

    nome_equipe VARCHAR(100),
    descricao_status VARCHAR(255),

    PRIMARY KEY (id_corrida, id_piloto, volta)
);