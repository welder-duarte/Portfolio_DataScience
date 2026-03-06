### *Criação Api com dados de fundos imobiliarios*
Este projeto foi desenvolvido com o objetivo de aplicar na prática conceitos e ferramentas de Engenharia de Dados, incluindo ingestão de dados, processamento analítico, orquestração e disponibilização via API.

#### Visão Geral do Projeto:
O projeto realiza a coleta automatizada de dados de Fundos de Investimento Imobiliário (FIIs) a partir do site: https://www.fundsexplorer.com

O site mantém uma tabela denominada Ranking de Fundos, contendo diversas métricas relevantes para investidores, como:
- Dividend Yield (DY)
- Preço da cota
- Ultimo dividendo pago
- Patrimônio Liquido
- Liquidez Diária do fundo
- Número de cotistas e ativos
- Indicadores de rentabilidade (VPA, P/VP, entre outros)

Esses dados são coletados, processados e disponibilizados através de uma API REST hospedada no Google Cloud Run.

#### Fluxo:
1. A coleta de dados é feita através de webscraping usando playwright.
2. Os dados coletados são armazenados no Google Storage, como objetos em formato de csv.
3. Os arquivos são lidos pelo DBT [^1], que fica responsável por transformar, testar e gerenciar as cargas incrementais dos dados nas camadas Raw, Silver e Gold (camada analítica).
4. DBT persiste os dados no BiqQuery do GCP [^2].
5. ApiRest responde às chamadas consumindo dados da camada gold do BigQuery.
6. Tudo orquestrado pelo Cloud Run (Docker + Python) e Cloud Scheduler.
7. CI/CD habilitado no Cloud Build.

#### Técnicas e tecnologias utilizadas:
Cloud:
- `GCP: Storage (Armazenamento) + Run (Servless) + Artifact Registry (Conteiners) + Scheduler (Agendador) + Build (CI/CD) + BigQuery (Data Warehouse)`

Engenharia:
- `Python`
- `Playwrite (Web Scraping)`
- `Sql`
- `DBT (Data build tool)`

Infra/Ops:
- `Docker`
- `CI/CD`
- `Github`

BackEnd:
- `Flask (Api)`

#### Arquitetura:
Projeto seguiu a arquitetura abaixo.
![Proj Api](https://github.com/welder-duarte/Portfolio_Dados/blob/master/Engenharia%20de%20Dados/ApiFundsExplorer/docs/Arquitetura%20Api.png?raw=true)


### *Documentação API de Fundos Imobiliários:*

API REST para consulta de dados de Fundos de Investimento Imobiliário (FIIs).

##### Base URL (endpoint):

https://funds-api-187304865067.us-west1.run.app

##### Health:

Verificar disponibilidade da api

Request
```python
GET /health
```
Response
```json
{
  "status": "ok"
}
```


##### Parâmetros:

| Parâmetro | Tipo | Obrigatório | Descrição |
| :--- | :---: | :---: | :---: |
| listar_fundos | flag | não | Retorna lista de fundos disponíveis e seus setores |
| fundo | string | não | Filtra por ticker do fundo (completo ou parcial) |
| setor | string | não | Filtra por setor do fundo (compeleto ou parcial) |
| limite |	int | não | Limita a quantidade de registros retornados (default = 600) |


#### Exemplo de uso:

Listar fundos

Request
```python
GET /v1/fundos?listar_fundos
```
Response
```json
{
  "data": [
    {
      "fundos": "HGLG11",
      "setor": "IMOVEIS INDUSTRIAIS E LOGISTICOS"
    },
    {
      "fundos": "MXRF11",
      "setor": "PAPEIS"
    },
    {
      "fundos": "XPML11",
      "setor": "SHOPPINGS"
    }
  ],
"success": true,
"total": 3
}
```

Buscar por fundos (completo ou parcial)

Request
```python
GET /v1/fundos?fundo=MXRF
```
Response
```json
{
  "data": [
    {
      "ativos": 3,
      "dividend_yield": 1.04,
      "dt_atualizacao": "2026-03-06",
      "dy_12m_acum": 12.92,
      "dy_12m_med": 1.0767,
      "dy_3m_acum": 3.13,
      "dy_3m_med": 1.0433,
      "dy_6m_acum": 6.29,
      "dy_6m_med": 1.0483,
      "dy_ano": 2.09,
      "fundos": "MXRF11",
      "liquidez_diaria": 16308025.9,
      "numero_cotista": 1389786,
      "p_vpa": 1.03194888178914,
      "patrimonio": 4356171528.14,
      "patrimonio_liquido": 4319978973.41,
      "preco_atual": 9.69,
      "preco_fechamento": 9.62,
      "pvp": 1.0211,
      "rentab_acum": 1.9949,
      "rentab_periodo": 1.8873,
      "setor": "PAPEIS",
      "tx_admin": 0.9,
      "tx_gestao": 0,
      "tx_performance": 0,
      "ultimo_dividendo": 0.1,
      "variacao_preco_m": 0.8386,
      "variacao_preco_ult_pregao": 0.73,
      "volatilidade": 730.97970272018,
      "vpa": 9.39,
      "vpa_change": -7.1217,
      "vpa_rent": -0.6522,
      "vpa_rent_m": -6.1325,
      "vpa_yield": 1.065
    }
  ],
  "success": true,
  "total": 1
}
```

Combinando parâmetros: Buscar por setores (parcial) + limitando a resposta

Request
```python
GET /v1/fundos?setor=banc&limite=1
```
Response
```json
{
  "data": [
    {
      "ativos": 21,
      "dividend_yield": 1.03,
      "dt_atualizacao": "2026-03-06",
      "dy_12m_acum": 14.04,
      "dy_12m_med": 1.17,
      "dy_3m_acum": 4.14,
      "dy_3m_med": 1.38,
      "dy_6m_acum": 7.38,
      "dy_6m_med": 1.23,
      "dy_ano": 3.07,
      "fundos": "BBRC11",
      "liquidez_diaria": 114251.33,
      "numero_cotista": 8766,
      "p_vpa": 1.00285415279231,
      "patrimonio": 167125202.99,
      "patrimonio_liquido": 167125202.99,
      "preco_atual": 105.41,
      "preco_fechamento": 102.02,
      "pvp": 0.9899,
      "rentab_acum": 6.8945,
      "rentab_periodo": 0.0687,
      "setor": "AGENCIAS DE BANCOS",
      "tx_admin": 0.6,
      "tx_gestao": 0,
      "tx_performance": 0,
      "ultimo_dividendo": 1.05,
      "variacao_preco_m": -0.9515,
      "variacao_preco_ult_pregao": 3.32,
      "volatilidade": 1793.5329197996,
      "vpa": 105.11,
      "vpa_change": -2.3686,
      "vpa_rent": 10.9151,
      "vpa_rent_m": -0.418,
      "vpa_yield": 1.9979
    }
  ],
  "success": true,
  "total": 1
}
```

[^1]: Data Build Tool (DBT): Ferramenta de transformação de dados que permite transformar, testar, documentar e versionar dados.
[^2]: Google Cloud Platform (GCP) é um conjunto de serviços de nuvem do Google como infraestrutura, APIs para computação, armazenamento, análise de dados e machine learning.
