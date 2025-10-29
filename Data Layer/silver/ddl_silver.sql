CREATE TABLE IF NOT EXISTS ResultadosCorridas (
    id_equipe INTEGER,
    nome_equipe VARCHAR(255),
    
    id_piloto INTEGER,
    primeiro_nome_piloto VARCHAR(255),
    sobrenome_piloto VARCHAR(255),
    
    id_corrida INTEGER NOT NULL,
    ano INTEGER NOT NULL,
    rodada INTEGER NOT NULL,
    nome_corrida VARCHAR(255) NOT NULL,

    id_status INTEGER,
    descricao_status VARCHAR(255),

    volta INTEGER,
    posicao_na_volta INTEGER,
    tempo_volta_ms INTEGER,
    
    duracao_parada_seg DECIMAL(10, 3) NOT NULL DEFAULT 0,

    pontos_piloto DECIMAL(10, 1) NOT NULL DEFAULT 0,
    vitorias_piloto INTEGER NOT NULL DEFAULT 0
);