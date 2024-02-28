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

#### *Análise*
A amostra de dados apresenta 7.885 registros pré-processados, porém, alguns anúncios ainda apresentavam informações incoerentes a respeito
da localização, de valores ou metragens, sendo necessário a exclusão diretamente no dashboard, ficando a base então com 7.839 registros.

*Apartamentos:*
- Representam a maior parte dos anúncios: 70,5% (5.503)
- Distribuição de preço m² fica entre R$ 3.315 (inf) e R$ 6.219 (sup) com mediana de R$ 4.475
- Na zona norte (- valorizada) os valores estão 39,7% abaixo em relação à zona sul (+ valorizada). Obs: comparação entre medianas
- Unidades com 1 quarto apresentam maiores valores, chegando a +26,5% em relação a unidades com 2/3 quartos e +20% em relação a 4/5 quartos
- Distribuição de metragens fica entre 72m² (inf) e 175m² (sup) com mediana de 122,5m²
- Top 5 bairros mais caros: todos estão na região sul da cidade (+ valorizada)
- Top 5 bairros mais acessíveis: Distribuição entre Norte, Oeste e Leste. Região Central não aparece nos TOPs
- Itens mais comuns ofertados nas unidades são: Sala de estar, box, sacada, armario, ventilador de teto, iluminação e ar condicionado
- Foi possível observar que a quantidade de itens de lazer não afeta os valores ofertados nos anúncios. O mesmo não ocorre em relação a itens de segurança e codomínio ou itens do imóvel, onde quanto mais itens ofertados, maior o preço do m² dos anúncios

*Casas*
- Representam 24,3% dos anúncios (1.904)
- Apresentam a maior variabilidade de valores (dispersão)
- Distribuição de preço m² fica entre R$ 1.431 (inf) e R$ 2.463 (sup) com mediana de R$ 1.895
- Na zona norte (- valorizada) os valores estão 31,8% abaixo em relação à zona sul (+ valorizada). Obs: comparação entre medianas
- Casas com 3 quartos são mais valorizados, superando em média de +16% em relação às casas com 1,2,4 ou 5 quartos
- Distribuição de metragens fica entre 166m² (inf) e 390m² (sup) com mediana de 268m²
- Top 5 bairros mais caros: 3 bairros situados na região leste e 2 na região sul
- Top 5 bairros mais acessíveis: Distribuição entre Norte, Oeste e Leste. Região Central não aparece nos TOPs
- Itens mais comuns ofertados são: Armários, churrasqueiras, varandas
- Foi possível observar que a quantidade de itens de lazer não afeta os valores ofertados nos anúncios. O mesmo não ocorre em relação a itens de segurança e codomínio ou itens do imóvel, onde quanto mais itens ofertados, maior o preço do m² dos anúncios

#### *Link para Dashboard*

https://public.tableau.com/views/EDAImoveisemRibeiraoPreto/EDAimoveisRibeiroPreto?:language=pt-BR&publish=yes&:sid=&:display_count=n&:origin=viz_share_link

![EDA imoveis Ribeirão Preto](https://github.com/welder-duarte/Portfolio_DataScience/assets/85957982/b1278df7-18ca-4cda-9887-d8a510eadc80)
