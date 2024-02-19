### Anúncios de imóveis em Ribeirão Preto (Web Scraping + Paralelismo)
Esse projeto foi desenvolvido para explorar aplicações de EDA (Análise Exploratória de Dados).

#### *O Problema*
Com objetivo aplicar conceitos de EDA em uma base de dados real, coletamos dados de anúncios de vendas de imóvels em uma página 
de uma imobiliaria com web scraping e paralelismo, uma vez que essa tarefa tende a ser demorada. Após a coleta, limpeza e estruturação dos dados,
partimos para a analise exploratória, buscando entender:
- Distribuição de preços dos imóveis por tipo.
- Distribuição geográfica dos imóveis na cidade.
- Relação da região do imóvel com os preços.
- Identificação dos bairros mais caros e mais acessíveis.
- Relação entre o número de quartos com os preços.
- Valores dos imóveis pelo tipo e quantidade de itens (lazer, segurança, condomínio).

#### *Técnicas e tecnologias utilizadas:*
- ``Jupter Notebook (Anaconda)``
- ``Python (Pandas, Numpy, Seaborn, Urllib.Request)``
- ``BeautifulSoup (Scraping)``
- ``Concurrent.futures (Paralelismo)``
- ``Modularização das funções (functions_proj_scraping)``
- ``Dtype-diet (Otimização de tipagem)``
- ``Api Google Maps (Definição de Lat e Long dos bairros)``

#### *Link para Dashboard*

https://public.tableau.com/views/EDAImoveisemRibeiraoPreto/EDAimoveisRibeiroPreto?:language=pt-BR&publish=yes&:sid=&:display_count=n&:origin=viz_share_link

![EDA imoveis Ribeirão Preto](https://github.com/welder-duarte/Portfolio_DataScience/assets/85957982/b1278df7-18ca-4cda-9887-d8a510eadc80)
