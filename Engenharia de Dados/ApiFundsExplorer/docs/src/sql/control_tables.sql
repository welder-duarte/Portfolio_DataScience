(SELECT
'RAW' AS origem,
scraping_date AS dt_scraping,
COUNT(DISTINCT ticker) AS qtd_fundos,
FROM `apifundsexplorer.funds_explorer.funds_ranking_raw`
GROUP BY 1, 2)

UNION ALL

(SELECT
'SILVER' AS origem,
scraping_date AS dt_scraping,
COUNT(DISTINCT fundos) AS qtd_fundos,
FROM `apifundsexplorer.funds_explorer.funds_ranking_silver`
GROUP BY 1, 2)