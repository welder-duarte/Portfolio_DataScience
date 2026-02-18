MERGE `funds_explorer.funds_ranking_silver` AS tgt
USING (

  SELECT
    SAFE_CAST(post_id AS INT64) AS post_id,
    post_title,
    ticker AS fundos,
    setor,
    setor_slug,

    SAFE_CAST(REPLACE(dividendo, ',', '.') AS FLOAT64)                  AS ultimo_dividendo,
    SAFE_CAST(REPLACE(yeld, ',', '.') AS FLOAT64)                       AS dividend_yield,

    SAFE_CAST(REPLACE(media_yield_3m, ',', '.') AS FLOAT64)             AS dy_3m_med,
    SAFE_CAST(REPLACE(soma_yield_3m, ',', '.') AS FLOAT64)              AS dy_3m_acum,

    SAFE_CAST(REPLACE(media_yield_6m, ',', '.') AS FLOAT64)             AS dy_6m_med,
    SAFE_CAST(REPLACE(soma_yield_6m, ',', '.') AS FLOAT64)              AS dy_6m_acum,

    SAFE_CAST(REPLACE(media_yield_12m, ',', '.') AS FLOAT64)            AS dy_12m_med,
    SAFE_CAST(REPLACE(soma_yield_12m, ',', '.') AS FLOAT64)             AS dy_12m_acum,

    SAFE_CAST(REPLACE(variacao_cotacao_mes, ',', '.') AS FLOAT64)       AS variacao_preco,
    SAFE_CAST(REPLACE(rentabilidade, ',', '.') AS FLOAT64)              AS rentab_acum,
    SAFE_CAST(REPLACE(rentabilidade_mes, ',', '.') AS FLOAT64)          AS rentab_periodo,

    SAFE_CAST(REPLACE(valor, ',', '.') AS FLOAT64)                     AS preco_atual,
    SAFE_CAST(REPLACE(cotacao_fechamento, ',', '.') AS FLOAT64)         AS preco_fechamento,
    SAFE_CAST(REPLACE(soma_yield_ano_corrente, ',', '.') AS FLOAT64)    AS dy_ano,

    SAFE_CAST(ano AS INT64)                                             AS ano,

    SAFE_CAST(REPLACE(pl, ',', '.') AS FLOAT64)                         AS patrimonio_liquido,
    SAFE_CAST(REPLACE(patrimonio, ',', '.') AS FLOAT64)                 AS patrimonio,
    SAFE_CAST(REPLACE(pvp, ',', '.') AS FLOAT64)                        AS pvp,
    SAFE_CAST(REPLACE(p_vpa, ',', '.') AS FLOAT64)                      AS p_vpa,

    SAFE_CAST(REPLACE(vpa_yield, ',', '.') AS FLOAT64)                  AS vpa_yield,
    SAFE_CAST(REPLACE(vpa, ',', '.') AS FLOAT64)                        AS vpa,
    SAFE_CAST(REPLACE(vpa_change, ',', '.') AS FLOAT64)                 AS vpa_change,

    SAFE_CAST(REPLACE(vpa_rent, ',', '.') AS FLOAT64)                   AS vpa_rent,
    SAFE_CAST(REPLACE(vpa_rent_m, ',', '.') AS FLOAT64)                 AS vpa_rent_m,

    SAFE_CAST(REPLACE(yield_vpa_3m_sum, ',', '.') AS FLOAT64)           AS yield_vpa_3m_sum,
    SAFE_CAST(REPLACE(yield_vpa_3m, ',', '.') AS FLOAT64)               AS yield_vpa_3m,

    SAFE_CAST(REPLACE(yield_vpa_6m_sum, ',', '.') AS FLOAT64)           AS yield_vpa_6m_sum,
    SAFE_CAST(REPLACE(yield_vpa_6m, ',', '.') AS FLOAT64)               AS yield_vpa_6m,

    SAFE_CAST(REPLACE(yield_vpa_12m_sum, ',', '.') AS FLOAT64)          AS yield_vpa_12m_sum,
    SAFE_CAST(REPLACE(yield_vpa_12m, ',', '.') AS FLOAT64)              AS yield_vpa_12m,

    SAFE_CAST(REPLACE(liquidezmediadiaria, ',', '.') AS FLOAT64)        AS liquidez_diaria,

    SAFE_CAST(REPLACE(volatility, ',', '.') AS FLOAT64)                 AS volatility,
    SAFE_CAST(numero_cotista AS INT64)                                  AS numero_cotista,
    SAFE_CAST(ativos AS INT64)                                          AS ativos,

    SAFE_CAST(REPLACE(tx_gestao, ',', '.') AS FLOAT64)                  AS tx_gestao,
    SAFE_CAST(REPLACE(tx_admin, ',', '.') AS FLOAT64)                   AS tx_admin,
    SAFE_CAST(REPLACE(tx_performance, ',', '.') AS FLOAT64)             AS tx_performance,

    SAFE_CAST(scraping_date AS DATE)                                    AS scraping_date,
    TIMESTAMP(CURRENT_DATETIME("America/Sao_Paulo"))                    AS ingestion_timestamp

  FROM `funds_explorer.funds_ranking_raw`
  WHERE DATE(scraping_date) = @scraping_date

) AS src

ON tgt.fundos = src.fundos
AND tgt.scraping_date = src.scraping_date

WHEN NOT MATCHED THEN
  INSERT ROW;