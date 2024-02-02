### Anúncios de imóveis em Ribeirão Preto (Web Scraping + Paralelismo)
Esse projeto foi desenvolvido para explorar aplicações de EDA (Análise Exploratória de Dados).

#### *O Problema*
Com objetivo aplicar conceitos de EDA em uma base de dados real, coletamos dados de anúncios de vendas de imóvels em uma página 
de uma imobiliaria com web scraping e paralelismo, uma vez que essa tarefa tende a ser demorada. Após a coleta, limpeza e estruturação dos dados,
partimos para a analise exploratória, buscando entender:
- Distribuição de preços dos imóveis por tipo.
- Distribuição geográfica dos imóveis na cidade.
- Relação entre o número de quartos, banheiros, e vagas de garagem com os preços.
- Identificação dos bairros mais caros e mais acessíveis.

#### *Técnicas e tecnologias utilizadas:*
- ``Jupter Notebook (Anaconda)``
- ``Python (Pandas, Numpy, Seaborn, Urllib.Request)``
- ``BeautifulSoup (Scraping)``
- ``Concurrent.futures (Paralelismo)``
- ``Modularização das funções (functions_proj_scraping)``
- ``Dtype-diet (Otimização de tipagem)``

#### *Detalhamento*



[^1]: O Problema do Caixeiro Viajante (TSP - Traveling Salesman Problem) é um desafio de otimização combinatória em que se busca encontrar o caminho mais curto que um vendedor (caixeiro) deve percorrer, passando por todas as cidades uma única vez e retornando à cidade de origem. 
O objetivo é minimizar a distância total percorrida, considerando as distâncias entre todas as cidades.

[^2]: TSP da biblioteca OR-Tools do Google utiliza a Teoria dos Grafos para definir a sequência de pontos a serem percorridas, priorizando a menor distância.
As distâncias entre as cidades obtidas através da API do Google Maps, levam em consideração o trajeto rodoviário e não uma linha reta entre as cidades, dessa forma, pontos próximos no mapa não são necessariamente a menor distância entre eles.
