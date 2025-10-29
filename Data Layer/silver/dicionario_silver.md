# Dicionário de Dados Silver

## 1. Introdução

Este documento serve como a documentação para o dicionário de dados da **Camada Silver** do sistema. Esta camada representa uma visão desnormalizada e integrada dos dados, pronta para análises. A Tabela 1 indica a única entidade central desta camada.

<p align="center"> Tabela 1 - Tabelas utilizadas</p>

<div style="margin: 0 auto; width: fit-content;">

| Tabelas |
|:---|
| [resultadoscorridas](#tabela-resultadoscorridas) |

</div>

<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cesar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>

---

## 2. Tabela resultadoscorridas

Essa tabela armazena os dados consolidados da Camada Silver. Cada registro combina informações de corrida, piloto, equipe, voltas (*lap times*), paradas nos boxes (*pit stops*) e resultado final em uma única linha.

<p align="center"> Tabela 2 - Tabela resultadoscorridas</p>

<div style="margin: 0 auto; width: fit-content;">

| Nome | Definição Lógica | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:---|:---|:---|:---|:---|
| **id\_corrida** | Identificador da corrida | `INTEGER` | - | FOREIGN KEY |
| **id\_piloto** | Identificador do piloto | `INTEGER` | - | FOREIGN KEY |
| **id\_equipe** | Identificador da equipe/construtor | `INTEGER` | - | FOREIGN KEY |
| **id\_status** | Identificador do status final/motivo de parada | `INTEGER` | - | FOREIGN KEY |
| **ano** | Ano da corrida | `INTEGER` | - | NOT NULL |
| **rodada** | Número da rodada na temporada | `INTEGER` | - | NOT NULL |
| **nome\_corrida** | Nome oficial do Grande Prêmio | `VARCHAR` | 100 | NOT NULL |
| **volta** | Número sequencial da volta | `INTEGER` | - | NULL (Se for registro de resultado final) |
| **posicao\_na\_volta** | Posição do piloto ao final desta volta | `INTEGER` | - | NULL (Se for registro de resultado final) |
| **tempo\_volta\_ms** | Tempo da volta em milissegundos | `INTEGER` | - | NULL (Se for registro de resultado final) |
| **duracao\_parada\_seg** | Duração da parada nos boxes em segundos | `NUMERIC` | 10,3 | NULL (Se não houve pit stop) |
| **primeiro\_nome\_piloto** | Primeiro nome do piloto (desnormalizado) | `VARCHAR` | 100 | NOT NULL |
| **sobrenome\_piloto** | Sobrenome do piloto (desnormalizado) | `VARCHAR` | 100 | NOT NULL |
| **nome\_equipe** | Nome da equipe/construtora (desnormalizado) | `VARCHAR` | 100 | NOT NULL |
| **descricao\_status** | Descrição textual do status (ex: Finished, Accident) | `VARCHAR` | 255 | NOT NULL |

</div>

<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cesar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>

---

## Histórico de versão

| Data | Versão | Descrição | Autor | Revisor |
|:---:|:---:|:---:|:---:|:---:|
| 10/10/2025 | `1.0` | Adição do dicionário de dados silver | [Júlio Cesar](https://github.com/Julio1099), [Fernando Gabriel](https://github.com/show-dawn) | [Othavio Bolzan](https://github.com/bolzanMGB), [Kaleb Macedo](https://github.com/kalebmacedo) |
| 29/10/2025 | **`1.1`** | Padronização do formato para alinhamento com a documentação Bronze. | [Júlio Cesar](https://github.com/Julio1099), [Fernando Gabriel](https://github.com/show-dawn) | [Othavio Bolzan](https://github.com/bolzanMGB), [Kaleb Macedo](https://github.com/kalebmacedo) |