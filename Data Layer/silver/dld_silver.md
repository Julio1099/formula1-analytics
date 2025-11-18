# Diagrama Lógico de Dados (DLD) - Camada Silver

## 1. Introdução
Este documento detalha o Diagrama Lógico de Dados da Camada Silver, que adota uma arquitetura de tabela única e desnormalizada. O foco é na definição das colunas e na rastreabilidade da informação.

## 1. Tabela resultadoscorridas

A tabela a seguir armazena os dados consolidados da Camada Silver. Cada registro combina informações de corrida, piloto, equipe, voltas, paradas nos boxes e resultado final em uma única linha.

Nesta camada, as restrições físicas de FK não são aplicadas. No entanto, os atributos são mantidos para fins de rastreabilidade e como chaves de negócio na carga da Camada Gold. Assim, a coluna lineage indica qual conjunto de dados da Camada Bronze alimentou cada uma das linhas da tabela.

<p align="center"> Tabela 1 - Tabela resultadoscorridas</p>

| Nome | Definição Lógica | Tipo SQL | Restrições de Domínio | Lineage (Origem da Camada Bronze) |
|:---|:---|:---|:---|:---|
| **id\_corrida** | Identificador da corrida | `INTEGER` | FOREIGN KEY (Lógica) | `races.raceId` |
| **id\_piloto** | Identificador do piloto | `INTEGER` | FOREIGN KEY (Lógica) | `drivers.driverId` |
| **id\_equipe** | Identificador da equipe/construtor | `INTEGER` | FOREIGN KEY (Lógica) | `constructors.constructorId` |
| **id\_status** | Identificador do status final/motivo de parada | `INTEGER` | FOREIGN KEY (Lógica) | `status.statusId` |
| **ano** | Ano da corrida | `INTEGER` | NOT NULL | `races.year` |
| **rodada** | Número da rodada na temporada | `INTEGER` | NOT NULL | `races.round` |
| **nome\_corrida** | Nome oficial do Grande Prêmio | `VARCHAR(255)` | NOT NULL | `races.name` |
| **volta** | Número sequencial da volta | `INTEGER` | NULL | `lap_times.lap` |
| **posicao\_na\_volta** | Posição do piloto ao final desta volta | `INTEGER` | NULL | `lap_times.position` |
| **tempo\_volta\_ms** | Tempo da volta em milissegundos | `INTEGER` | NULL | `lap_times.milliseconds` |
| **duracao\_parada\_seg** | Duração da parada nos boxes em segundos | `DECIMAL(10,3)` | NULL | `pit_stops.duration` (Após conversão HH:MM:SS para segundos) |
| **primeiro\_nome\_piloto** | Primeiro nome do piloto (desnormalizado) | `VARCHAR(255)` | NOT NULL | `drivers.forename` |
| **sobrenome\_piloto** | Sobrenome do piloto (desnormalizado) | `VARCHAR(255)` | NOT NULL | `drivers.surname` |
| **nome\_equipe** | Nome da equipe/construtora (desnormalizado) | `VARCHAR(255)` | NOT NULL | `constructors.name` |
| **descricao\_status** | Descrição textual do status (ex: Finished, Accident) | `VARCHAR(255)` | NOT NULL | `status.status` |

<p align="center"><b>Fonte: </b>Autoria de <a href="https://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>


## 2. Histórico de Versão

| Data | Versão | Descrição | Autor | Revisor |
|:---:|:---:|:---:|:---:|:---:|
| 10/10/2025 | `1.0` | Adição inicial do dicionário de dados silver. | [Júlio Cesar](https://github.com/Julio1099)  | [Kaleb Macedo](https://github.com/kalebmacedo) |
| 24/10/2025 | `1.0`      | Ajuste para representação de tabela única | [Júlio Cesar](https://github.com/Julio1099), [Fernando Gabriel](https://github.com/show-dawn)  | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 29/10/2025 | `1.1` | Padronização do formato para alinhamento com a documentação Bronze. | [Júlio Cesar](https://github.com/Julio1099), [Fernando Gabriel](https://github.com/show-dawn) | [Othavio Bolzan](https://github.com/bolzanMGB)|
| 29/10/2025 | **`1.2`** | Adição da coluna Lineage (Origem da Camada Bronze) para rastreabilidade de dados. | [Júlio Cesar](https://github.com/Julio1099)  |  [Kaleb Macedo](https://github.com/kalebmacedo)|
| 31/10/2025 | **`1.2`** | Refatorização da documentação | [Othavio Bolzan](https://github.com/bolzanMGB)|  [Kaleb Macedo](https://github.com/kalebmacedo)|