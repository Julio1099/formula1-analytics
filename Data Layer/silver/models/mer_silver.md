# Modelo Entidade-Relacionamento

## 1. Introdução

O modelo Entidade-Relacionamento tem como objetivo principal representar os elementos envolvidos em um determinado cenário, auxiliando na organização e estruturação de dados em um banco de dados. Neste projeto, ele descreve o domínio das corridas de Fórmula 1, com ênfase nas voltas realizadas pelos pilotos.


## 2. Entidades

As entidades representam os principais objetos ou conceitos do domínio de dados que possuem significado próprio e sobre os quais deseja-se armazenar informações no banco. Cada entidade corresponde a uma tabela no modelo relacional e descreve elementos centrais do contexto da Fórmula 1, como corridas, pilotos, equipes e resultados.

A Tabela 1 apresenta as entidades identificadas e o respectivo significado de cada uma, servindo como base para o mapeamento dos dados do sistema.

<p align="center"> Tabela 1 - Principais Entidades </p>

<div style="margin: 0 auto; width: fit-content;">

| **Entidade** | **Significado** |
| :--- | :--- |
| **Race** | Corrida |
| **Driver** | Piloto |
| **Constructor** | Equipe |
| **Status** | Status |
| **Lap\_Times\_Fact**| Tempos de Volta (Tabela Fato) |
| **Pit\_Stops** | Paradas nos Boxes |
| **Results** | Resultados |

</div>
<p align="center"><b>Fonte: </b>Autoria de  <a href="https://github.com/Julio1099"> Júlio Cesar </a></p>



## 3. Atributos


Os atributos representam as propriedades ou características de cada entidade do modelo, descrevendo as informações que serão armazenadas no banco de dados. Eles incluem tanto identificadores únicos (chaves primárias) quanto relacionamentos com outras entidades (chaves estrangeiras) e, eventualmente, atributos alternativos (chaves candidatas).

- As chaves primárias são representadas com <ins>sublinhado simples</ins>.
- As chaves estrangeiras são representadas com <span style="text-decoration: underline; text-decoration-style: dotted;">sublinhado pontilhado</span>.
- As chaves candidatas são representadas com <span style="text-decoration: underline; text-decoration-style: double;">sublinhado duplo</span>.

A Tabela 2 apresenta as entidades identificadas no modelo de dados, juntamente com seus respectivos atributos e o tipo de chave associada a cada um.
<p align="center"> Tabela 2 - Atributos e Chaves Primárias </p>

<div style="margin: 0 auto; width: fit-content;">

| **Entidade** | **Atributos** |
| :--- | :--- |
| **Race** | <ins>id\_corrida</ins>, ano, rodada, nome\_corrida |
| **Driver** | <ins>id\_piloto</ins>, primeiro\_nome\_piloto, sobrenome\_piloto |
| **Constructor** | <ins>id\_equipe</ins>, nome\_equipe |
| **Status** | <ins>id\_status</ins>, descricao\_status |
| **Lap\_Times\_Fact**| <ins><span style="text-decoration: underline; text-decoration-style: dotted;">id\_corrida</span></ins>, <ins><span style="text-decoration: underline; text-decoration-style: dotted;">id\_piloto</span></ins>, <ins>volta</ins>, posicao\_na\_volta, tempo\_volta\_ms |
| **Pit\_Stops** | <ins><span style="text-decoration: underline; text-decoration-style: dotted;">id\_corrida</span></ins>, <ins><span style="text-decoration: underline; text-decoration-style: dotted;">id\_piloto</span></ins>, <ins>numero\_parada</ins>, duracao\_parada\_seg |
| **Results** | <ins><span style="text-decoration: underline; text-decoration-style: dotted;">id\_corrida</span></ins>, <ins><span style="text-decoration: underline; text-decoration-style: dotted;">id\_piloto</span></ins>, <span style="text-decoration: underline; text-decoration-style: dotted;">id\_equipe</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id\_status</span> |

</div>

<p align="center"><b>Fonte: </b>Autoria de  <a href="https://github.com/Julio1099"> Júlio Cesar </a></p>


## 4. Relacionamentos

Os relacionamentos representam as associações entre entidades, definindo como os elementos de uma se conectam ou interagem com os elementos de outra, e são essenciais para estruturar o banco de dados, capturando regras do mundo real, como um piloto realizando voltas em uma corrida ou uma equipe possuindo resultados. 

A tabela a seguir apresenta os principais relacionamentos do modelo de Fórmula 1. Lap\_Times\_Fact é a tabela fato central do modelo, registrando cada volta realizada por cada piloto em cada corrida. A cardinalidade de cada relação está representada no formato (mínimo, máximo), indicando o número mínimo e máximo de ocorrências entre as entidades envolvidas.

<p align="center"> Tabela 3 - Principais Relacionamentos </p>

<div style="margin: 0 auto; width: fit-content;">

| **Relação** | **Cardinalidade Entidade 1** | **Cardinalidade Entidade 2** | **Descrição** |
| :--- | :--- | :--- | :--- |
| **Race – Possui – Lap\_Times\_Fact** | 1,N | 1,1 | Uma corrida possui uma ou várias voltas; cada volta pertence a uma única corrida. |
| **Driver – Realiza – Lap\_Times\_Fact**| 0,N | 1,1 | Um piloto pode realizar nenhuma ou várias voltas; cada volta é realizada por um único piloto. |
| **Race – Possui – Pit\_Stops** | 1,N | 1,1 | Uma corrida pode ter uma ou várias paradas nos boxes; cada parada ocorre em uma única corrida. |
| **Driver – Realiza – Pit\_Stops** | 0,N | 1,1 | Um piloto pode realizar nenhuma ou várias paradas; cada parada é realizada por um único piloto. |
| **Race – Possui – Results** | 1,N | 1,1 | Cada corrida tem pelo menos um resultado; cada resultado pertence a uma única corrida. |
| **Driver – Participa – Results** | 0,N | 1,1 | Um piloto pode participar de nenhum ou vários resultados; cada resultado pertence a um único piloto. |
| **Constructor – Possui – Results** | 0,N | 1,1 | Uma equipe pode possuir nenhum ou vários resultados; cada resultado pertence a uma única equipe. |
| **Status – Classifica – Results** | 0,N | 1,1 | Um status pode classificar nenhum ou vários resultados; cada resultado possui um único status. |

</div>

<p align="center"><b>Fonte: </b>Autoria de  <a href="https://github.com/Julio1099"> Júlio Cesar </a></p>

## 5. Diagrama Conceitual

Finalmente, temos o Diagrama Conceitual que representa visualmente as entidades, seus atributos e os relacionamentos entre elas, permitindo compreender de forma clara como os elementos do modelo de Fórmula 1 se conectam, com Lap\_Times\_Fact funcionando como a tabela fato central do sistema.

<p align="center"> Figura 1 - Diagrama MER </p>

<div style="margin: 0 auto; width: fit-content;">


```
                    ┌─────────────┐
                    │    Race     │
                    │ (Corrida)   │
                    └──────┬──────┘
                           │
            ┌──────────────┼──────────────┐
            │              │              │
            │(1,1)    (1,1)│         (1,1)│
            │              │              │
     ┌──────▼──────┐(1,N)  │(1,N)  ┌──────▼──────┐
     │ Lap_Times   │       │       │  Pit_Stop   │
     │    Fact     │       │       │             │
     │  (FATO)     │       │       └──────┬──────┘
     └──────┬──────┘       │              │
            │              │              │(1,1)
       (1,1)│              │(1,N)         │
            │              │              │
            │         ┌────▼────┐    (0,N)│
            │         │ Result  │         │
            │         │         │         │
            │         └────┬────┘         │
            │              │              │
            │         (1,1)│              │
            │              │              │
            │    ┌─────────┼─────────┐    │
            │    │         │         │    │
       (0,N)│    │(1,1)    │(0,N)    │    │
            │    │         │         │    │
     ┌──────▼────▼───┐     │    ┌────▼────▼───────┐
     │    Driver     │     │    │  Constructor    │
     │   (Piloto)    │     │    │    (Equipe)     │
     └───────────────┘     │    └─────────────────┘
                           │
                      (0,N)│
                           │
                    ┌──────▼──────┐
                    │   Status    │
                    │             │
                    └─────────────┘
```

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="https://github.com/Julio1099"> Júlio Cesar </a></p>


<center>

## Histórico de versão

</center>

<div style="margin: 0 auto; width: fit-content;">


|    Data    | Versão |                 Descrição                 | Autores                                                                                                                                                                                                 |
|:----------:|:------:|:-----------------------------------------:| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 07/10/2025 | `1.0`  |        Criação do MER para Fórmula 1          | [Júlio Cesar](https://github.com/Julio1099)
| 08/10/2025 | `1.1`  |      Padronização da documentação         | [Othavio Bolzan](https://github.com/bolzanMGB)
| 09/10/2025 | `1.2`  |      Correções no MER         | [Othavio Bolzan](https://github.com/Julio1099)

</div>