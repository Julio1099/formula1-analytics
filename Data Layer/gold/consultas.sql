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
WITH incidentes AS (
    SELECT DISTINCT
        f.srk_equipe,
        f.srk_status,
        f.srk_piloto, 
        f.srk_corrida 
    FROM
        gold.ft_voltas_tempo_parada f
    JOIN
        gold.dm_status ds ON f.srk_status = ds.srk_status
    WHERE
        ds.descricao_status NOT IN (
            'Finished', '+1 Lap', '+2 Laps', '+3 Laps', '+4 Laps', '+5 Laps', 
            '+6 Laps', '+7 Laps', '+8 Laps', '+9 Laps', '+10 Laps', '+11 Laps', 
            '+12 Laps', '+13 Laps', '+14 Laps', '+15 Laps', '+16 Laps', 
            '+17 Laps', '+18 Laps', '+19 Laps', '+20 Laps', '+21 Laps', 
            '+22 Laps', '+23 Laps', '+24 Laps', '+25 Laps', '+26 Laps', 
            '+29 Laps', '+30 Laps', '+38 Laps', '+42 Laps', '+44 Laps', 
            '+46 Laps', '+49 Laps'
        )
)


SELECT
    de.nome_equipe AS equipe,
    'Total de incidentes' AS motivo_incidente,
    COUNT(*) AS contagem_incidentes 
FROM
    incidentes i
JOIN
    gold.dm_equipe de ON i.srk_equipe = de.srk_equipe
GROUP BY
    de.nome_equipe

UNION ALL

SELECT
    de.nome_equipe AS equipe,
    ds.descricao_status AS motivo_incidente,
    COUNT(*) AS contagem_incidentes
FROM
    incidentes i
JOIN
    gold.dm_equipe de ON i.srk_equipe = de.srk_equipe
JOIN
    gold.dm_status ds ON i.srk_status = ds.srk_status
GROUP BY
    de.nome_equipe, ds.descricao_status

ORDER BY
--    equipe, 
    contagem_incidentes DESC;

-- 3. Análise de Eficiência de Pit Stop: Duração Média da Parada por Equipe e pilotos ao longo dos anos e por temporada.
-- Objetivo: Comparar a velocidade das equipes e pilotos na troca de pneus ao longo dos anos e por temporada (pit stops).
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

-- 6. Comparação de Companheiros de Equipe: Ritmo Médio por Corrida
-- Objetivo: Medir a diferença média de ritmo (voltas limpas, sem pit stop) entre pilotos da mesma equipe em cada corrida.
WITH ValidLaps AS (
    SELECT
        f.srk_corrida,
        f.srk_equipe,
        f.srk_piloto,
        AVG(f.tempo_volta_ms)::NUMERIC AS avg_lap_ms
    FROM gold.ft_voltas_tempo_parada f   
    JOIN gold.dm_status ds ON f.srk_status = ds.srk_status      
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
    GROUP BY
        f.srk_corrida,
        f.srk_equipe,
        f.srk_piloto
),
TeamPairs AS (
    SELECT
        vl1.srk_corrida,
        vl1.srk_equipe,
        vl1.srk_piloto AS srk_piloto_a,
        vl2.srk_piloto AS srk_piloto_b,
        vl1.avg_lap_ms AS avg_lap_ms_a,
        vl2.avg_lap_ms AS avg_lap_ms_b,
        vl1.avg_lap_ms - vl2.avg_lap_ms AS diff_ms
    FROM
        ValidLaps vl1
    JOIN
        ValidLaps vl2 ON vl1.srk_corrida = vl2.srk_corrida
        AND vl1.srk_equipe = vl2.srk_equipe
        AND vl1.srk_piloto < vl2.srk_piloto
)
SELECT dc.ano AS temporada,
       dc.rodada,
       dc.nome_corrida,
       de.nome_equipe AS equipe,
       dp_a.nome_completo AS piloto_a,
       ROUND(tp.avg_lap_ms_a / 1000.0, 3) AS media_volta_piloto_a_seg,
       dp_b.nome_completo AS piloto_b,
       ROUND(tp.avg_lap_ms_b / 1000.0, 3) AS media_volta_piloto_b_seg,
       CASE WHEN tp.diff_ms <= 0 THEN dp_a.nome_completo ELSE dp_b.nome_completo END AS piloto_mais_rapido,
       ROUND(ABS(tp.diff_ms) / 1000.0, 3) AS diferenca_media_segundos,
       ROUND((ABS(tp.diff_ms) / LEAST(tp.avg_lap_ms_a, tp.avg_lap_ms_b)) * 100, 3) AS diferenca_percentual
FROM TeamPairs tp
JOIN gold.dm_corrida dc ON tp.srk_corrida = dc.srk_corrida
JOIN gold.dm_equipe de ON tp.srk_equipe = de.srk_equipe
JOIN gold.dm_piloto dp_a ON tp.srk_piloto_a = dp_a.srk_piloto
JOIN gold.dm_piloto dp_b ON tp.srk_piloto_b = dp_b.srk_piloto
WHERE
    dc.ano = 2024 -- <-- Ajuste a temporada conforme necessário
ORDER BY
    temporada,
    rodada,
    diferenca_media_segundos ASC;

-- 7. Evolução de Pontos: Pontuação Acumulada por Piloto na Temporada
-- Objetivo: Acompanhar a evolução da pontuação dos pilotos rodada a rodada dentro de uma temporada.
WITH DriverRaceSummary AS (
    SELECT
        f.srk_piloto,
        f.srk_corrida,
        MAX(f.srk_equipe) AS srk_equipe,
        MAX(f.pontos_piloto) AS pontos_acumulados_ate_corrida 
    FROM
        gold.ft_voltas_tempo_parada f
    GROUP BY
        f.srk_piloto,
        f.srk_corrida
),
PointsByRound AS (
    SELECT
        dc.ano,
        dc.rodada,
        dc.nome_corrida,
        drs.srk_piloto,
        drs.srk_equipe,
        
		drs.pontos_acumulados_ate_corrida AS pontos_acumulados,
        
		(drs.pontos_acumulados_ate_corrida - 
         LAG(drs.pontos_acumulados_ate_corrida, 1, 0.0) OVER (
             PARTITION BY drs.srk_piloto, dc.ano 
             ORDER BY dc.rodada
         )
        ) AS pontos_corrida
        
    FROM
        DriverRaceSummary drs
    JOIN
        gold.dm_corrida dc ON drs.srk_corrida = dc.srk_corrida
    WHERE
        dc.ano = 2023 -- <-- Ajuste a temporada 
)
SELECT ano AS temporada,
       rodada,
       nome_corrida,
       dp.nome_completo AS piloto,
       de.nome_equipe AS equipe,
       pontos_corrida,     
       pontos_acumulados   
FROM PointsByRound pbr
JOIN gold.dm_piloto dp ON pbr.srk_piloto = dp.srk_piloto
JOIN gold.dm_equipe de ON pbr.srk_equipe = de.srk_equipe
ORDER BY
    temporada,
    piloto,
    rodada;


-- 8. Carga de Pit Stop: Volume e Tempo Total por Equipe na Temporada
-- Objetivo: Quantificar o esforço de pit stop por equipe (quantidade, tempo total e médias) em uma temporada.
SELECT * FROM (
    SELECT
        dc.ano AS temporada, 
        'MÉDIA DA EQUIPE' AS piloto, 
        de.nome_equipe AS equipe,
        COUNT(CASE WHEN f.duracao_parada_seg > 0 THEN 1 END) AS total_paradas,
        ROUND(AVG(CASE WHEN f.duracao_parada_seg > 0 THEN f.duracao_parada_seg ELSE NULL END), 3) AS media_duracao_pit_stop_seg
    FROM
        gold.ft_voltas_tempo_parada f
    JOIN
        gold.dm_equipe de ON f.srk_equipe = de.srk_equipe
    JOIN 
        gold.dm_corrida dc ON f.srk_corrida = dc.srk_corrida
    GROUP BY
        dc.ano, 
        de.nome_equipe 
    HAVING
        COUNT(CASE WHEN f.duracao_parada_seg > 0 THEN 1 END) > 100

    UNION ALL
    
    SELECT
        dc.ano AS temporada, 
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
    JOIN 
        gold.dm_corrida dc ON f.srk_corrida = dc.srk_corrida
    GROUP BY
        dc.ano, 
        dp.nome_completo, 
        de.nome_equipe    
    HAVING
        COUNT(CASE WHEN f.duracao_parada_seg > 0 THEN 1 END) > 20

) AS combined_results 

ORDER BY
    temporada DESC, 
    CASE WHEN piloto = 'MÉDIA DA EQUIPE' THEN 1 ELSE 2 END ASC,  
--  equipe ASC,
    media_duracao_pit_stop_seg ASC;