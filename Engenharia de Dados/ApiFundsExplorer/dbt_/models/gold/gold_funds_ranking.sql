{{ config(
    materialized='table'
) }}

WITH ult_scraping AS (

    SELECT
        max(scraping_date) AS max_date
    FROM {{ ref('silver_funds_ranking') }}

), historico AS (

    SELECT * FROM {{ ref('silver_funds_ranking') }}

), complemento_dados AS (

    SELECT
        UPPER(fundos)                                                                                                                                    AS fundos,
        UPPER(REGEXP_REPLACE(NORMALIZE(setor, NFD),r'\pM',''))                                                                                           AS setor,
        scraping_date                                                                                                                                    AS dt_atualizacao,
        LAST_VALUE(ultimo_dividendo IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)     AS ultimo_dividendo,
        LAST_VALUE(dividend_yield IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)       AS dividend_yield,
        LAST_VALUE(dy_ano IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)               AS dy_ano,
        LAST_VALUE(dy_3m_med IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)            AS dy_3m_med,
        LAST_VALUE(dy_3m_acum IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)           AS dy_3m_acum,
        LAST_VALUE(dy_6m_med IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)            AS dy_6m_med,
        LAST_VALUE(dy_6m_acum IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)           AS dy_6m_acum,
        LAST_VALUE(dy_12m_med IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)           AS dy_12m_med,
        LAST_VALUE(dy_12m_acum IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)          AS dy_12m_acum,
        LAST_VALUE(preco_atual IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)          AS preco_atual,
        LAST_VALUE(preco_fechamento IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)     AS preco_fechamento,
        LAST_VALUE(variacao_preco_m IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)     AS variacao_preco_m,
        LAST_VALUE(volatilidade IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)         AS volatilidade,
        LAST_VALUE(rentab_acum IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)          AS rentab_acum,
        LAST_VALUE(rentab_periodo IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)       AS rentab_periodo,
        LAST_VALUE(patrimonio IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)           AS patrimonio,
        LAST_VALUE(patrimonio_liquido IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)   AS patrimonio_liquido,
        LAST_VALUE(vpa IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)                  AS vpa,
        LAST_VALUE(pvp IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)                  AS pvp,
        LAST_VALUE(p_vpa IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)                AS p_vpa,
        LAST_VALUE(vpa_yield IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)            AS vpa_yield,
        LAST_VALUE(vpa_change IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)           AS vpa_change,
        LAST_VALUE(vpa_rent IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)             AS vpa_rent,
        LAST_VALUE(vpa_rent_m IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)           AS vpa_rent_m,
        LAST_VALUE(liquidez_diaria IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)      AS liquidez_diaria,
        LAST_VALUE(numero_cotista IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)       AS numero_cotista,
        LAST_VALUE(ativos IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)               AS ativos,
        LAST_VALUE(tx_gestao IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)            AS tx_gestao,
        LAST_VALUE(tx_admin IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)             AS tx_admin,
        LAST_VALUE(tx_performance IGNORE NULLS) OVER (PARTITION BY fundos ORDER BY scraping_date ROWS BETWEEN UNBOUNDED PRECEDING AND current ROW)       AS tx_performance
    FROM historico

)

SELECT 
    c.*,
    ROUND(COALESCE((preco_atual - preco_fechamento) / NULLIF(preco_fechamento,0),0)*100,2) AS variacao_preco_ult_pregao
FROM complemento_dados c
JOIN ult_scraping us
    ON c.dt_atualizacao = us.max_date