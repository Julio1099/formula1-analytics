-- DDL MODIFICADO PARA FUNCIONAR COM A LÓGICA BASEADA EM 'resultados'
CREATE TABLE IF NOT EXISTS ResultadosCorridas (
    id_corrida INTEGER,
    id_piloto INTEGER,
    id_equipe INTEGER,
    id_status INTEGER,
    ano INTEGER,
    rodada INTEGER,
    nome_corrida VARCHAR(100),

    -- MUDANÇA 1: A coluna 'volta' agora permite valores nulos
    volta INTEGER,

    posicao_na_volta INTEGER,
    tempo_volta_ms INTEGER,
    duracao_parada_seg DECIMAL(10, 3),
    primeiro_nome_piloto VARCHAR(100),
    sobrenome_piloto VARCHAR(100),
    nome_equipe VARCHAR(100),
    descricao_status VARCHAR(255)

    -- MUDANÇA 2 (CRÍTICA): A chave primária foi removida.
    -- Sem isso, a inserção de voltas nulas falharia.
);