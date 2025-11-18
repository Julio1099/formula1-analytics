-- CONSULTAS DE ANÁLISE (PC2)
-- Demonstração da Camada Gold (Modelo Estrela)
-- Padrão de Chave: SRK (Surrogate Key)

-- 1. Análise de Desempenho: Tempo Médio de Volta por Piloto em Corridas de 2024
-- Objetivo: Determinar o desempenho base do piloto (média de tempo de volta), excluindo pit stops (dur_par_seg = 0.000).
WITH FastestLapPerRace AS (
    SELECT
        f.srk_cor,
        MIN(f.tmp_volt_ms) AS fastest_lap_in_race_ms
    FROM
        gold.fat_des_volt f
    JOIN
        gold.dim_cor dc ON f.srk_cor = dc.srk_cor
    WHERE
        dc.ano = 2024  -- <-- Defina a temporada aqui
        AND f.tmp_volt_ms IS NOT NULL
        AND f.dur_par_seg = 0.000
    GROUP BY
        f.srk_cor
),
LapsWithRelativePace AS (
    SELECT
        f.srk_pil,
        f.srk_eqp,
        f.srk_cor,
        (f.tmp_volt_ms::numeric / flpr.fastest_lap_in_race_ms) AS relative_pace
    FROM
        gold.fat_des_volt f
    JOIN
        FastestLapPerRace flpr ON f.srk_cor = flpr.srk_cor
    JOIN
        gold.dim_sts ds ON f.srk_sts = ds.srk_sts
    WHERE
        f.tmp_volt_ms IS NOT NULL
        AND f.dur_par_seg = 0.000
        AND ds.des_sts IN (
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
        f.srk_pil,
        COUNT(DISTINCT f.srk_cor) AS total_corridas_piloto
    FROM
        gold.fat_des_volt f
    JOIN
        gold.dim_cor dc ON f.srk_cor = dc.srk_cor
    WHERE
        dc.ano = 2024 -- <-- Use o MESMO ano das outras CTEs
    GROUP BY
        f.srk_pil
)

SELECT
    dp.nom_com AS piloto,
    de.nom_eqp AS equipe,
    'MÉDIA DA TEMPORADA' AS corrida,
    0 AS rodada,
    (AVG(lrp.relative_pace) - 1) * 100 AS porcentagem
FROM
    LapsWithRelativePace lrp
JOIN
    gold.dim_pil dp ON lrp.srk_pil = dp.srk_pil
JOIN
    gold.dim_eqp de ON lrp.srk_eqp = de.srk_eqp
JOIN
    PilotRaceCounts prc ON lrp.srk_pil = prc.srk_pil
WHERE
    lrp.relative_pace <= 1.07
    AND prc.total_corridas_piloto >= 10 
GROUP BY
    dp.nom_com,
    de.nom_eqp

UNION ALL
SELECT
    dp.nom_com AS piloto,
    de.nom_eqp AS equipe,
    dc.nom_cor AS corrida,
    dc.rod,
    (AVG(lrp.relative_pace) - 1) * 100 AS porcentagem
FROM
    LapsWithRelativePace lrp
JOIN
    gold.dim_pil dp ON lrp.srk_pil = dp.srk_pil
JOIN
    gold.dim_eqp de ON lrp.srk_eqp = de.srk_eqp
JOIN
    gold.dim_cor dc ON lrp.srk_cor = dc.srk_cor
JOIN
    PilotRaceCounts prc ON lrp.srk_pil = prc.srk_pil
WHERE
    lrp.relative_pace <= 1.07
    AND prc.total_corridas_piloto >= 10 
GROUP BY
    dp.nom_com,
    de.nom_eqp,
    dc.nom_cor,
    dc.rod
ORDER BY
--  piloto ASC,
--  equipe ASC,
    rodada ASC, 
    porcentagem ASC;

-- 2. Confiabilidade da Equipe: Contagem de Incidentes por Motivo de Status
-- Objetivo: Identificar as causas mais frequentes de abandono (incidentes) por equipe , esse codigo mostra os incidentes individuais e totais por equipe.
WITH incidentes AS (
    SELECT DISTINCT
        f.srk_eqp,
        f.srk_sts,
        f.srk_pil, 
        f.srk_cor 
    FROM
        gold.fat_des_volt f
    JOIN
        gold.dim_sts ds ON f.srk_sts = ds.srk_sts
    WHERE
        ds.des_sts NOT IN (
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
    de.nom_eqp AS equipe,
    'Total de incidentes' AS motivo_incidente,
    COUNT(*) AS contagem_incidentes 
FROM
    incidentes i
JOIN
    gold.dim_eqp de ON i.srk_eqp = de.srk_eqp
GROUP BY
    de.nom_eqp

UNION ALL

SELECT
    de.nom_eqp AS equipe,
    ds.des_sts AS motivo_incidente,
    COUNT(*) AS contagem_incidentes
FROM
    incidentes i
JOIN
    gold.dim_eqp de ON i.srk_eqp = de.srk_eqp
JOIN
    gold.dim_sts ds ON i.srk_sts = ds.srk_sts
GROUP BY
    de.nom_eqp, ds.des_sts

ORDER BY
--  equipe, 
    contagem_incidentes DESC;

-- 3. Análise de Eficiência de Pit Stop: Duração Média da Parada por Equipe e pilotos ao longo dos anos e por temporada.
-- Objetivo: Comparar a velocidade das equipes e pilotos na troca de pneus ao longo dos anos e por temporada (pit stops).
SELECT * FROM (
    SELECT
        'MÉDIA DA EQUIPE' AS piloto, 
        de.nom_eqp AS equipe,
        COUNT(CASE WHEN f.dur_par_seg > 0 THEN 1 END) AS total_paradas,
        ROUND(AVG(CASE WHEN f.dur_par_seg > 0 THEN f.dur_par_seg ELSE NULL END), 3) AS media_duracao_pit_stop_seg
    FROM
        gold.fat_des_volt f
    JOIN
        gold.dim_eqp de ON f.srk_eqp = de.srk_eqp
    GROUP BY
        de.nom_eqp 
    HAVING
        COUNT(CASE WHEN f.dur_par_seg > 0 THEN 1 END) > 100

    UNION ALL
    SELECT
        dp.nom_com AS piloto,
        de.nom_eqp AS equipe,
        COUNT(CASE WHEN f.dur_par_seg > 0 THEN 1 END) AS total_paradas,
        ROUND(AVG(CASE WHEN f.dur_par_seg > 0 THEN f.dur_par_seg ELSE NULL END), 3) AS media_duracao_pit_stop_seg
    FROM
        gold.fat_des_volt f
    JOIN
        gold.dim_eqp de ON f.srk_eqp = de.srk_eqp
    JOIN
        gold.dim_pil dp ON f.srk_pil = dp.srk_pil 
    GROUP BY
        dp.nom_com, 
        de.nom_eqp
    HAVING
        COUNT(CASE WHEN f.dur_par_seg > 0 THEN 1 END) > 20

) AS combined_results 

ORDER BY
    CASE WHEN piloto = 'MÉDIA DA EQUIPE' THEN 1 ELSE 2 END ASC,
--  equipe ASC,
    media_duracao_pit_stop_seg ASC;

-- 4. Análise de DNF dos pilotos por temporada: DNF (Did Not Finish)
-- Objetivo: Comparar quais pilotos tiveram mais dificuldades em uma temporada.
SELECT
    dp.nom_com AS piloto,
    COUNT(DISTINCT f.srk_cor) AS total_dnfs 
FROM
    gold.fat_des_volt f
JOIN
    gold.dim_pil dp ON f.srk_pil = dp.srk_pil
JOIN
    gold.dim_cor dc ON f.srk_cor = dc.srk_cor
JOIN
    gold.dim_sts ds ON f.srk_sts = ds.srk_sts
WHERE
    dc.ano = 2023  
AND
    ds.des_sts NOT IN ( 
        'Finished', 
        '+1 Lap', '+2 Laps', '+3 Laps', '+4 Laps', '+5 Laps', '+6 Laps',
        '+7 Laps', '+8 Laps', '+9 Laps', '+10 Laps', '+11 Laps', '+12 Laps',
        '+13 Laps', '+14 Laps', '+15 Laps', '+16 Laps', '+17 Laps', '+18 Laps',
        '+19 Laps', '+20 Laps', '+21 Laps', '+22 Laps', '+23 Laps', '+24 Laps',
        '+25 Laps', '+26 Laps', '+29 Laps', '+30 Laps', '+38 Laps', '+42 Laps',
        '+44 Laps', '+46 Laps', '+49 Laps'
    )
GROUP BY
    dp.nom_com
ORDER BY
    total_dnfs DESC;

-- 5. Análise de pontos dos pilotos por todas as temporadas.
-- Objetivo: Comparar quais pilotos tiveram mais pontos em todas as temporada.
SELECT
    dc.ano AS temporada,
    dp.nom_com AS piloto,

    MAX(f.pnt_pil) AS total_pontos_temporada
    
FROM
    gold.fat_des_volt f 
JOIN
    gold.dim_pil dp ON f.srk_pil = dp.srk_pil
JOIN
    gold.dim_cor dc ON f.srk_cor = dc.srk_cor 
WHERE
    dc.ano BETWEEN 2011 AND 2024
GROUP BY
    dc.ano,
    dp.nom_com
HAVING
    MAX(f.pnt_pil) > 0
ORDER BY
    temporada DESC,
    total_pontos_temporada DESC;

-- 6. Comparação de Companheiros de Equipe: Ritmo Médio por Corrida
-- Objetivo: Medir a diferença média de ritmo (voltas limpas, sem pit stop) entre pilotos da mesma equipe em cada corrida.
WITH ValidLaps AS (
    SELECT
        f.srk_cor,
        f.srk_eqp,
        f.srk_pil,
        AVG(f.tmp_volt_ms)::NUMERIC AS avg_lap_ms
    FROM gold.fat_des_volt f   
    JOIN gold.dim_sts ds ON f.srk_sts = ds.srk_sts
    WHERE
        f.tmp_volt_ms IS NOT NULL
        AND f.dur_par_seg = 0.000
        AND ds.des_sts IN (
            'Finished', '+1 Lap', '+2 Laps', '+3 Laps', '+4 Laps', '+5 Laps', '+6 Laps',
            '+7 Laps', '+8 Laps', '+9 Laps', '+10 Laps', '+11 Laps', '+12 Laps',
            '+13 Laps', '+14 Laps', '+15 Laps', '+16 Laps', '+17 Laps', '+18 Laps',
            '+19 Laps', '+20 Laps', '+21 Laps', '+22 Laps', '+23 Laps', '+24 Laps',
            '+25 Laps', '+26 Laps', '+29 Laps', '+30 Laps', '+38 Laps', '+42 Laps',
            '+44 Laps', '+46 Laps', '+49 Laps'
        )
    GROUP BY
        f.srk_cor,
        f.srk_eqp,
        f.srk_pil
),
TeamPairs AS (
    SELECT
        vl1.srk_cor,
        vl1.srk_eqp,
        vl1.srk_pil AS srk_piloto_a,
        vl2.srk_pil AS srk_piloto_b,
        vl1.avg_lap_ms AS avg_lap_ms_a,
        vl2.avg_lap_ms AS avg_lap_ms_b,
        vl1.avg_lap_ms - vl2.avg_lap_ms AS diff_ms
    FROM
        ValidLaps vl1
    JOIN
        ValidLaps vl2 ON vl1.srk_cor = vl2.srk_cor
        AND vl1.srk_eqp = vl2.srk_eqp
        AND vl1.srk_pil < vl2.srk_pil
)
SELECT dc.ano AS temporada,
       dc.rod,
       dc.nom_cor,
       de.nom_eqp AS equipe,
       dp_a.nom_com AS piloto_a,
       ROUND(tp.avg_lap_ms_a / 1000.0, 3) AS media_volta_piloto_a_seg,
       dp_b.nom_com AS piloto_b,
       ROUND(tp.avg_lap_ms_b / 1000.0, 3) AS media_volta_piloto_b_seg,
       CASE WHEN tp.diff_ms <= 0 THEN dp_a.nom_com ELSE dp_b.nom_com END AS piloto_mais_rapido,
       ROUND(ABS(tp.diff_ms) / 1000.0, 3) AS diferenca_media_segundos,
       ROUND((ABS(tp.diff_ms) / LEAST(tp.avg_lap_ms_a, tp.avg_lap_ms_b)) * 100, 3) AS diferenca_percentual
FROM TeamPairs tp
JOIN gold.dim_cor dc ON tp.srk_cor = dc.srk_cor
JOIN gold.dim_eqp de ON tp.srk_eqp = de.srk_eqp
JOIN gold.dim_pil dp_a ON tp.srk_piloto_a = dp_a.srk_pil
JOIN gold.dim_pil dp_b ON tp.srk_piloto_b = dp_b.srk_pil
WHERE
    dc.ano = 2024 -- <-- Ajuste a temporada conforme necessário
ORDER BY
    temporada,
    rod,
    diferenca_media_segundos ASC;

-- 7. Evolução de Pontos: Pontuação Acumulada por Piloto na Temporada
-- Objetivo: Acompanhar a evolução da pontuação dos pilotos rodada a rodada dentro de uma temporada.
WITH DriverRaceSummary AS (
    SELECT
        f.srk_pil,
        f.srk_cor,
        MAX(f.srk_eqp) AS srk_eqp,
        MAX(f.pnt_pil) AS pontos_acumulados_ate_corrida 
    FROM
        gold.fat_des_volt f
    GROUP BY
        f.srk_pil,
        f.srk_cor
),
PointsByRound AS (
    SELECT
        dc.ano,
        dc.rod,
        dc.nom_cor,
        drs.srk_pil,
        drs.srk_eqp,
        
        drs.pontos_acumulados_ate_corrida AS pontos_acumulados,
        
        (drs.pontos_acumulados_ate_corrida - 
         LAG(drs.pontos_acumulados_ate_corrida, 1, 0.0) OVER (
             PARTITION BY drs.srk_pil, dc.ano 
             ORDER BY dc.rod
         )
        ) AS pontos_corrida
        
    FROM
        DriverRaceSummary drs
    JOIN
        gold.dim_cor dc ON drs.srk_cor = dc.srk_cor
    WHERE
        dc.ano = 2023 -- <-- Ajuste a temporada 
)
SELECT ano AS temporada,
       rod,
       nom_cor,
       dp.nom_com AS piloto,
       de.nom_eqp AS equipe,
       pontos_corrida,
       pontos_acumulados
FROM PointsByRound pbr
JOIN gold.dim_pil dp ON pbr.srk_pil = dp.srk_pil
JOIN gold.dim_eqp de ON pbr.srk_eqp = de.srk_eqp
ORDER BY
    temporada,
    piloto,
    rod;


-- 8. Carga de Pit Stop: Volume e Tempo Total por Equipe na Temporada
-- Objetivo: Quantificar o esforço de pit stop por equipe (quantidade, tempo total e médias) em uma temporada.
SELECT * FROM (
    SELECT
        dc.ano AS temporada, 
        'MÉDIA DA EQUIPE' AS piloto, 
        de.nom_eqp AS equipe,
        COUNT(CASE WHEN f.dur_par_seg > 0 THEN 1 END) AS total_paradas,
        ROUND(AVG(CASE WHEN f.dur_par_seg > 0 THEN f.dur_par_seg ELSE NULL END), 3) AS media_duracao_pit_stop_seg
    FROM
        gold.fat_des_volt f
    JOIN
        gold.dim_eqp de ON f.srk_eqp = de.srk_eqp
    JOIN 
        gold.dim_cor dc ON f.srk_cor = dc.srk_cor
    GROUP BY
        dc.ano, 
        de.nom_eqp 
    HAVING
        COUNT(CASE WHEN f.dur_par_seg > 0 THEN 1 END) > 100

    UNION ALL
    
    SELECT
        dc.ano AS temporada, 
        dp.nom_com AS piloto,
        de.nom_eqp AS equipe,
        COUNT(CASE WHEN f.dur_par_seg > 0 THEN 1 END) AS total_paradas,
        ROUND(AVG(CASE WHEN f.dur_par_seg > 0 THEN f.dur_par_seg ELSE NULL END), 3) AS media_duracao_pit_stop_seg
    FROM
        gold.fat_des_volt f
    JOIN
        gold.dim_eqp de ON f.srk_eqp = de.srk_eqp
    JOIN
        gold.dim_pil dp ON f.srk_pil = dp.srk_pil 
    JOIN 
        gold.dim_cor dc ON f.srk_cor = dc.srk_cor
    GROUP BY
        dc.ano, 
        dp.nom_com, 
        de.nom_eqp
    HAVING
        COUNT(CASE WHEN f.dur_par_seg > 0 THEN 1 END) > 20

) AS combined_results 

ORDER BY
    temporada DESC, 
    CASE WHEN piloto = 'MÉDIA DA EQUIPE' THEN 1 ELSE 2 END ASC,
--  equipe ASC,
    media_duracao_pit_stop_seg ASC;