### Clusterização de Centros logísticos e TSP [^1]
Esse projeto foi desenvolvido para explorar um problema real.

#### *O Problema*
Com o objetivo de expandir suas operações em São Paulo, uma empresa de logística planeja abrir novos Centros de Distribuição (CDs). 
Esses CDs serão supervisionados por 4 gerentes regionais, ainda não designados, que necessitarão visitar regularmente esses locais para uma gestão de equipe mais próxima. 
O foco deste projeto é otimizar a distribuição dos CDs entre os gerentes, não necessariamente de forma igual, mas visando minimizar os deslocamentos e custos para cada gerente, 
garantindo uma gestão eficiente e reduzindo ao máximo a necessidade de grandes deslocamentos.

#### *Técnicas e tecnologias utilizadas:*
- ``Jupter Notebook (Anaconda)``
- ``Python (Pandas, Numpy)``
- ``APIs Google Maps (Geocode, Distance Matrix)``
- ``Sklearn (Kmeans)``
- ``Folium (Mapas)``
- ``Or-tolls (TSP)``

#### Detalhamento
A partir de uma lista de cidades, buscamos as latitudes e longitudes na API do Google Maps (Geocode), para então podemos realizar a clusterização.

![Mapa1](https://github.com/welder-duarte/Portfolio_DataScience/assets/85957982/60ec8dae-ba8c-48ea-94ab-a004aa0fd571)

Após a clusterização com K-means, dividindo as cidades em 4 clusters (pois serão 4 gerentes regionais) temos esse resultado:

![Mapa2 - Clusterizado](https://github.com/welder-duarte/Portfolio_DataScience/assets/85957982/246a1a47-4c36-41c0-973c-4e57b6d93e9b)
###### Adicionei curcunferências com raios de 150 km para dar uma noção melhor da área de deslocamento em cada cluster.

Com os clusters definidos, foi preciso fazer um pequeno ajuste na base de dados, pois o algoritmo de k-means cria centróides em pontos que não existiam inicialmente, 
uma vez que o K-means busca minimizar as distãncias de cada ponto em relação ao seu centróide. Sabendo disso, definimos como cidade "base" do gerente a cidade da lista inicial
mais próxima ao centróide do k-means. Essas cidades "base" serão os ponto iniciais e finais para o TSP.

Dessa forma podemos aplicar TSP, para buscar uma rota mais otimizada  [^2] de modo que os gerentes possam visitar todas as 
unidaes de sua responsabilidade e retornar à sua cidade base (marcadores em preto no mapa). Podemos ver a sequência da rota encontrada nos marcadores do mapa.

![Mapa3 - Roteirizado](https://github.com/welder-duarte/Portfolio_DataScience/assets/85957982/3c861dc8-1afb-4a5d-a9f0-712685639b78)

Por fim, a distancia total de deslocamento obtido para cada cluster, partindo de suas cidades "bases" e retornando à elas.

Com base nesse resultado, será possível a empresa planejar de forma mais eficiente o itinerário de cada gerente, com pontos de parada e hotéis para pernoite.

![Final](https://github.com/welder-duarte/Portfolio_DataScience/assets/85957982/aff4058e-09e2-4e6b-b6c4-d27b9a5893d8)


#### 📁 Acesso ao projeto
Você pode acessar os arquivos do projeto clicando [aqui](https://github.com/welder-duarte/Portfolio_DataScience/tree/master/Clusters/Agrupamento%20de%20centros%20logisticos)!



[^1]: O Problema do Caixeiro Viajante (TSP - Traveling Salesman Problem) é um desafio de otimização combinatória em que se busca encontrar o caminho mais curto que um vendedor (caixeiro) deve percorrer, passando por todas as cidades uma única vez e retornando à cidade de origem. 
O objetivo é minimizar a distância total percorrida, considerando as distâncias entre todas as cidades.

[^2]: TSP da biblioteca OR-Tools do Google utiliza a Teoria dos Grafos para definir a sequência de pontos a serem percorridas, priorizando a menor distância.
As distâncias entre as cidades obtidas através da API do Google Maps, levam em consideração o trajeto rodoviário e não em linha reta, dessa forma, pontos próximos no mapa não são 
necessariamente a menor distancia entre eles.
