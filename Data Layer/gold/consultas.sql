-- CONSULTAS DE ANÁLISE (PC2)
-- Demonstração da Camada Gold (Modelo Estrela)
-- Padrão de Chave: SRK (Surrogate Key)

-- 1. Análise de Desempenho: Tempo Médio de Volta por Piloto em Corridas de 2024
-- Objetivo: Determinar o desempenho base do piloto (média de tempo de volta), excluindo pit stops (duracao_parada_seg = 0.000).
WITH FastestLapPerRace AS (
    SELECT
        f.srk_corrida,
        MIN(f.tempo_volta_ms) AS fastest_lap_in_race_ms
    FROM
        gold.ft_voltas_tempo_parada f
    JOIN
        gold.dm_corrida dc ON f.srk_corrida = dc.srk_corrida
    WHERE
        dc.ano = 2024  -- <-- Defina a temporada aqui
        AND f.tempo_volta_ms IS NOT NULL
        AND f.duracao_parada_seg = 0.000
    GROUP BY
        f.srk_corrida
),
LapsWithRelativePace AS (
    SELECT
        f.srk_piloto,
        f.srk_equipe,
        f.srk_corrida,
        (f.tempo_volta_ms::numeric / flpr.fastest_lap_in_race_ms) AS relative_pace
    FROM
        gold.ft_voltas_tempo_parada f
    JOIN
        FastestLapPerRace flpr ON f.srk_corrida = flpr.srk_corrida
    JOIN
        gold.dm_status ds ON f.srk_status = ds.srk_status
    WHERE
        f.tempo_volta_ms IS NOT NULL
        AND f.duracao_parada_seg = 0.000
        AND ds.descricao_status IN (
            'Finished', '+1 Lap', '+2 Laps', '+3 Laps', '+4 Laps', '+5 Laps', '+6 Laps',
            '+7 Laps', '+8 Laps', '+9 Laps', '+10 Laps', '+11 Laps', '+12 Laps',
            '+13 Laps', '+14 Laps', '+15 Laps', '+16 Laps', '+17 Laps', '+18 Laps',
            '+19 Laps', '+20 Laps', '+21 Laps', '+22 Laps', '+23 Laps', '+24 Laps',
            '+25 Laps', '+26 Laps', '+29 Laps', '+30 Laps', '+38 Laps', '+42 Laps',
            '+44 Laps', '+46 Laps', '+49 Laps'
        )
),
PilotRaceCounts AS (
    SELECT
        f.srk_piloto,
        COUNT(DISTINCT f.srk_corrida) AS total_corridas_piloto
    FROM
        gold.ft_voltas_tempo_parada f
    JOIN
        gold.dm_corrida dc ON f.srk_corrida = dc.srk_corrida
    WHERE
        dc.ano = 2024 -- <-- Use o MESMO ano das outras CTEs
    GROUP BY
        f.srk_piloto
)

SELECT
    dp.nome_completo AS piloto,
    de.nome_equipe AS equipe,
    'MÉDIA DA TEMPORADA' AS corrida,
    0 AS rodada,
    (AVG(lrp.relative_pace) - 1) * 100 AS porcentagem
FROM
    LapsWithRelativePace lrp
JOIN
    gold.dm_piloto dp ON lrp.srk_piloto = dp.srk_piloto
JOIN
    gold.dm_equipe de ON lrp.srk_equipe = de.srk_equipe
JOIN
    PilotRaceCounts prc ON lrp.srk_piloto = prc.srk_piloto
WHERE
    lrp.relative_pace <= 1.07
    AND prc.total_corridas_piloto >= 10 
GROUP BY
    dp.nome_completo,
    de.nome_equipe

UNION ALL
SELECT
    dp.nome_completo AS piloto,
    de.nome_equipe AS equipe,
    dc.nome_corrida AS corrida,
    dc.rodada,
    (AVG(lrp.relative_pace) - 1) * 100 AS porcentagem
FROM
    LapsWithRelativePace lrp
JOIN
    gold.dm_piloto dp ON lrp.srk_piloto = dp.srk_piloto
JOIN
    gold.dm_equipe de ON lrp.srk_equipe = de.srk_equipe
JOIN
    gold.dm_corrida dc ON lrp.srk_corrida = dc.srk_corrida
JOIN
    PilotRaceCounts prc ON lrp.srk_piloto = prc.srk_piloto
WHERE
    lrp.relative_pace <= 1.07
    AND prc.total_corridas_piloto >= 10 
GROUP BY
    dp.nome_completo,
    de.nome_equipe,
    dc.nome_corrida,
    dc.rodada
ORDER BY
--    piloto ASC,
--    equipe ASC,
    rodada ASC, 
    porcentagem ASC;

-- 2. Confiabilidade da Equipe: Contagem de Incidentes por Motivo de Status
-- Objetivo: Identificar as causas mais frequentes de abandono (incidentes) por equipe , esse codigo mostra os incidentes individuais e totais por equipe.
SELECT
    de.nome_equipe AS equipe,
    'Total de incidentes' AS motivo_incidente, 
    COUNT(f.srk_tempo_volta) AS contagem_incidentes
FROM
    gold.ft_voltas_tempo_parada f
JOIN
    gold.dm_equipe de ON f.srk_equipe = de.srk_equipe
JOIN
    gold.dm_status ds ON f.srk_status = ds.srk_status
WHERE
    ds.descricao_status NOT IN ('Finished',
'+1 Lap', '+2 Laps', '+3 Laps', '+4 Laps', '+5 Laps', '+6 Laps',
'+7 Laps', '+8 Laps', '+9 Laps', '+10 Laps', '+11 Laps', '+12 Laps',
'+13 Laps', '+14 Laps', '+15 Laps', '+16 Laps', '+17 Laps', '+18 Laps',
'+19 Laps', '+20 Laps', '+21 Laps', '+22 Laps', '+23 Laps', '+24 Laps',
'+25 Laps', '+26 Laps', '+29 Laps', '+30 Laps', '+38 Laps', '+42 Laps',
'+44 Laps', '+46 Laps', '+49 Laps'
)
GROUP BY
    de.nome_equipe 

UNION ALL

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
    ds.descricao_status NOT IN ('Finished',
'+1 Lap', '+2 Laps', '+3 Laps', '+4 Laps', '+5 Laps', '+6 Laps',
'+7 Laps', '+8 Laps', '+9 Laps', '+10 Laps', '+11 Laps', '+12 Laps',
'+13 Laps', '+14 Laps', '+15 Laps', '+16 Laps', '+17 Laps', '+18 Laps',
'+19 Laps', '+20 Laps', '+21 Laps', '+22 Laps', '+23 Laps', '+24 Laps',
'+25 Laps', '+26 Laps', '+29 Laps', '+30 Laps', '+38 Laps', '+42 Laps',
'+44 Laps', '+46 Laps', '+49 Laps'
)
GROUP BY
    de.nome_equipe, ds.descricao_status

ORDER BY
    equipe, 
    contagem_incidentes DESC; 

-- 3. Análise de Eficiência de Pit Stop: Duração Média da Parada por Equipe e pilotos.
-- Objetivo: Comparar a velocidade das equipes e pilotos na troca de pneus (pit stops).
SELECT * FROM (
    SELECT
        'MÉDIA DA EQUIPE' AS piloto, 
        de.nome_equipe AS equipe,
        COUNT(CASE WHEN f.duracao_parada_seg > 0 THEN 1 END) AS total_paradas,
        ROUND(AVG(CASE WHEN f.duracao_parada_seg > 0 THEN f.duracao_parada_seg ELSE NULL END), 3) AS media_duracao_pit_stop_seg
    FROM
        gold.ft_voltas_tempo_parada f
    JOIN
        gold.dm_equipe de ON f.srk_equipe = de.srk_equipe
    GROUP BY
        de.nome_equipe 
    HAVING
        COUNT(CASE WHEN f.duracao_parada_seg > 0 THEN 1 END) > 100

    UNION ALL
    SELECT
        dp.nome_completo AS piloto,
        de.nome_equipe AS equipe,
        COUNT(CASE WHEN f.duracao_parada_seg > 0 THEN 1 END) AS total_paradas,
        ROUND(AVG(CASE WHEN f.duracao_parada_seg > 0 THEN f.duracao_parada_seg ELSE NULL END), 3) AS media_duracao_pit_stop_seg
    FROM
        gold.ft_voltas_tempo_parada f
    JOIN
        gold.dm_equipe de ON f.srk_equipe = de.srk_equipe
    JOIN
        gold.dm_piloto dp ON f.srk_piloto = dp.srk_piloto 
    GROUP BY
        dp.nome_completo, 
        de.nome_equipe    
    HAVING
        COUNT(CASE WHEN f.duracao_parada_seg > 0 THEN 1 END) > 20

) AS combined_results 

ORDER BY
    CASE WHEN piloto = 'MÉDIA DA EQUIPE' THEN 1 ELSE 2 END ASC,  
--    equipe ASC,
    media_duracao_pit_stop_seg ASC;

-- 4. Análise de DNF dos pilotos por temporada: DNF (Did Not Finish)
-- Objetivo: Comparar quais pilotos tiveram mais dificuldades em uma temporada.
SELECT
    dp.nome_completo AS piloto,
    COUNT(DISTINCT f.srk_corrida) AS total_dnfs 
FROM
    gold.ft_voltas_tempo_parada f
JOIN
    gold.dm_piloto dp ON f.srk_piloto = dp.srk_piloto
JOIN
    gold.dm_corrida dc ON f.srk_corrida = dc.srk_corrida
JOIN
    gold.dm_status ds ON f.srk_status = ds.srk_status
WHERE
    dc.ano = 2023  
AND
    ds.descricao_status NOT IN ( 
        'Finished', 
        '+1 Lap', '+2 Laps', '+3 Laps', '+4 Laps', '+5 Laps', '+6 Laps',
        '+7 Laps', '+8 Laps', '+9 Laps', '+10 Laps', '+11 Laps', '+12 Laps',
        '+13 Laps', '+14 Laps', '+15 Laps', '+16 Laps', '+17 Laps', '+18 Laps',
        '+19 Laps', '+20 Laps', '+21 Laps', '+22 Laps', '+23 Laps', '+24 Laps',
        '+25 Laps', '+26 Laps', '+29 Laps', '+30 Laps', '+38 Laps', '+42 Laps',
        '+44 Laps', '+46 Laps', '+49 Laps'
    )
GROUP BY
    dp.nome_completo
ORDER BY
    total_dnfs DESC;

-- 5. Análise de pontos dos pilotos por todas as temporadas.
-- Objetivo: Comparar quais pilotos tiveram mais pontos em todas as temporada.
SELECT
    dc.ano AS temporada,
    dp.nome_completo AS piloto,

    MAX(f.pontos_piloto) AS total_pontos_temporada
    
FROM
    gold.ft_voltas_tempo_parada f 
JOIN
    gold.dm_piloto dp ON f.srk_piloto = dp.srk_piloto
JOIN
    gold.dm_corrida dc ON f.srk_corrida = dc.srk_corrida 
WHERE
    dc.ano BETWEEN 2011 AND 2024
GROUP BY
    dc.ano,
    dp.nome_completo
HAVING
    MAX(f.pontos_piloto) > 0
ORDER BY
    temporada DESC,
    total_pontos_temporada DESC;