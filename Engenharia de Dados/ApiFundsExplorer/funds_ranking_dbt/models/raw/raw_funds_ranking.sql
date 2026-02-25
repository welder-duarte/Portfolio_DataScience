{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['ticker', 'scraping_date']
) }}

SELECT
    SAFE_CAST(post_id AS STRING) AS post_id,
    SAFE_CAST(ticker AS STRING) AS ticker,
    SAFE_CAST(dividendo AS STRING) AS dividendo,
    SAFE_CAST(yeld AS STRING) AS yeld,
    SAFE_CAST(media_yield_3m AS STRING) AS media_yield_3m,
    SAFE_CAST(soma_yield_3m AS STRING) AS soma_yield_3m,
    SAFE_CAST(media_yield_6m AS STRING) AS media_yield_6m,
    SAFE_CAST(soma_yield_6m AS STRING) AS soma_yield_6m,
    SAFE_CAST(media_yield_12m AS STRING) AS media_yield_12m,
    SAFE_CAST(soma_yield_12m AS STRING) AS soma_yield_12m,
    SAFE_CAST(variacao_cotacao_mes AS STRING) AS variacao_cotacao_mes,
    SAFE_CAST(rentabilidade AS STRING) AS rentabilidade,
    SAFE_CAST(rentabilidade_mes AS STRING) AS rentabilidade_mes,
    SAFE_CAST(cotacao_fechamento AS STRING) AS cotacao_fechamento,
    SAFE_CAST(soma_yield_ano_corrente AS STRING) AS soma_yield_ano_corrente,
    SAFE_CAST(ano AS STRING) AS ano,
    SAFE_CAST(vpa_yield AS STRING) AS vpa_yield,
    SAFE_CAST(vpa AS STRING) AS vpa,
    SAFE_CAST(vpa_change AS STRING) AS vpa_change,
    SAFE_CAST(pl AS STRING) AS pl,
    SAFE_CAST(vpa_rent AS STRING) AS vpa_rent,
    SAFE_CAST(vpa_rent_m AS STRING) AS vpa_rent_m,
    SAFE_CAST(yield_vpa_3m_sum AS STRING) AS yield_vpa_3m_sum,
    SAFE_CAST(yield_vpa_3m AS STRING) AS yield_vpa_3m,
    SAFE_CAST(yield_vpa_6m_sum AS STRING) AS yield_vpa_6m_sum,
    SAFE_CAST(yield_vpa_6m AS STRING) AS yield_vpa_6m,
    SAFE_CAST(yield_vpa_12m_sum AS STRING) AS yield_vpa_12m_sum,
    SAFE_CAST(yield_vpa_12m AS STRING) AS yield_vpa_12m,
    SAFE_CAST(setor AS STRING) AS setor,
    SAFE_CAST(setor_slug AS STRING) AS setor_slug,
    SAFE_CAST(valor AS STRING) AS valor,
    SAFE_CAST(liquidezmediadiaria AS STRING) AS liquidezmediadiaria,
    SAFE_CAST(patrimonio AS STRING) AS patrimonio,
    SAFE_CAST(pvp AS STRING) AS pvp,
    SAFE_CAST(p_vpa AS STRING) AS p_vpa,
    SAFE_CAST(post_title AS STRING) AS post_title,
    SAFE_CAST(ativos AS STRING) AS ativos,
    SAFE_CAST(volatility AS STRING) AS volatility,
    SAFE_CAST(numero_cotista AS STRING) AS numero_cotista,
    SAFE_CAST(tx_gestao AS STRING) AS tx_gestao,
    SAFE_CAST(tx_admin AS STRING) AS tx_admin,
    SAFE_CAST(tx_performance AS STRING) AS tx_performance,
    SAFE_CAST(scraping_date AS DATE)                              AS scraping_date,
    TIMESTAMP(CURRENT_DATETIME("America/Sao_Paulo"))         AS dth_processamento
FROM {{ source('funds_explorer', 'funds_external') }}

{% if is_incremental() %}

WHERE CAST(scraping_date AS DATE) >= (SELECT DATE_SUB(MAX(scraping_date), INTERVAL 2 DAY) FROM {{ this }})

{% endif %}
