-- CONSULTAS DE ANÁLISE (PC2)
-- Demonstração da Camada Gold (Modelo Estrela)
-- Padrão de Chave: SRK (Surrogate Key)

-- 1. Análise de Desempenho: Tempo Médio de Volta por Piloto em Corridas de 2024
-- Objetivo: Determinar o desempenho base do piloto (média de tempo de volta), excluindo pit stops (duracao_parada_seg = 0.000).
SELECT
dp.nome_completo AS piloto,
dc.nome_corrida AS corrida,
-- Converte milissegundos para segundos para facilitar a leitura
ROUND(AVG(f.tempo_volta_ms) / 1000, 3) AS media_tempo_volta_seg
FROM
gold.ft_voltas_tempo_parada f
JOIN
gold.dm_piloto dp ON f.srk_piloto = dp.srk_piloto
JOIN
gold.dm_corrida dc ON f.srk_corrida = dc.srk_corrida
WHERE
dc.ano = 2024
AND f.tempo_volta_ms IS NOT NULL
AND f.duracao_parada_seg = 0.000
GROUP BY
1, 2
ORDER BY
media_tempo_volta_seg ASC
LIMIT 10;

-- 2. Confiabilidade da Equipe: Contagem de Incidentes por Motivo de Status
-- Objetivo: Identificar as causas mais frequentes de abandono (incidentes) por equipe.
SELECT
de.nome_equipe AS equipe,
ds.descricao_status AS motivo_incidente,
COUNT(f.srk_tempo_volta) AS contagem_incidentes
FROM
gold.ft_voltas_tempo_parada f
JOIN
gold.dm_equipe de ON f.srk_equipe = de.srk_equipe
JOIN
gold.dm_status ds ON f.srk_status = ds.srk_status
WHERE
-- Filtra por motivos que não são "finalização de corrida"
ds.descricao_status NOT IN ('Finished', '+1 Lap', '+2 Laps', '+3 Laps', '+4 Laps', '+5 Laps', '+6 Laps', '+7 Laps')
GROUP BY
de.nome_equipe, ds.descricao_status
ORDER BY
contagem_incidentes DESC
LIMIT 15;

-- 3. Análise de Eficiência de Pit Stop: Duração Média da Parada por Equipe
-- Objetivo: Comparar a velocidade das equipes na troca de pneus (pit stops).
SELECT
de.nome_equipe,
COUNT(CASE WHEN f.duracao_parada_seg > 0 THEN 1 END) AS total_paradas,
ROUND(AVG(CASE WHEN f.duracao_parada_seg > 0 THEN f.duracao_parada_seg ELSE NULL END), 3) AS media_duracao_pit_stop_seg
FROM
gold.ft_voltas_tempo_parada f
JOIN
gold.dm_equipe de ON f.srk_equipe = de.srk_equipe
GROUP BY
de.nome_equipe
HAVING
COUNT(CASE WHEN f.duracao_parada_seg > 0 THEN 1 END) > 50 -- Filtra para equipes com volume mínimo de dados
ORDER BY
media_duracao_pit_stop_seg ASC;