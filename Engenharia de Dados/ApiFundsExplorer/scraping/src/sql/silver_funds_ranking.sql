--DDL CRIACAO SCHEMA SILVER
CREATE OR REPLACE TABLE `funds_explorer.funds_ranking_silver`
(
  post_id INT64,
  post_title STRING,
  fundos STRING,
  setor STRING,
  setor_slug STRING,

  ultimo_dividendo FLOAT64,
  dividend_yield FLOAT64,

  dy_3m_med FLOAT64,
  dy_3m_acum FLOAT64,

  dy_6m_med FLOAT64,
  dy_6m_acum FLOAT64,

  dy_12m_med FLOAT64,
  dy_12m_acum FLOAT64,

  variacao_preco FLOAT64,
  rentab_acum FLOAT64,
  rentab_periodo FLOAT64,

  preco_atual FLOAT64,
  preco_fechamento FLOAT64,
  dy_ano FLOAT64,

  ano INT64,

  patrimonio_liquido FLOAT64,
  patrimonio FLOAT64,
  pvp FLOAT64,
  p_vpa FLOAT64,

  vpa_yield FLOAT64,
  vpa FLOAT64,
  vpa_change FLOAT64,

  vpa_rent FLOAT64,
  vpa_rent_m FLOAT64,

  yield_vpa_3m_sum FLOAT64,
  yield_vpa_3m FLOAT64,

  yield_vpa_6m_sum FLOAT64,
  yield_vpa_6m FLOAT64,

  yield_vpa_12m_sum FLOAT64,
  yield_vpa_12m FLOAT64,

  liquidez_diaria FLOAT64,

  volatility FLOAT64,
  numero_cotista INT64,
  ativos INT64,

  tx_gestao FLOAT64,
  tx_admin FLOAT64,
  tx_performance FLOAT64,

  scraping_date DATE,
  ingestion_timestamp TIMESTAMP
)
PARTITION BY scraping_date
CLUSTER BY fundos;