
# Modelo Entidade-Relacionamento

## 1. Introdução

O modelo Entidade-Relacionamento tem como objetivo principal representar os elementos envolvidos em um determinado cenário, auxiliando na organização e estruturação de dados em um banco de dados. Neste projeto, ele descreve o domínio das corridas de Fórmula 1, com ênfase nas voltas realizadas pelos pilotos.


## 2. Entidades

As entidades representam os principais objetos ou conceitos do domínio de dados que possuem significado próprio e sobre os quais deseja-se armazenar informações no banco. Cada entidade corresponde a uma tabela no modelo relacional e descreve elementos centrais do contexto da Fórmula 1, como corridas, pilotos, equipes e resultados.

A Tabela 1 apresenta as entidades identificadas e o respectivo significado de cada uma, servindo como base para o mapeamento dos dados do sistema.

<p align="center"> Tabela 1 - Principais Entidades </p>

<div style="margin: 0 auto; width: fit-content;">

| **Entidade**       | **Significado**               |
| ------------------ | ----------------------------- |
| **Race**           | Corrida                       |
| **Driver**         | Piloto                        |
| **Constructor**    | Equipe                        |
| **Status**         | Status                        |
| **Lap_Times_Fact** | Tempos de Volta (Tabela Fato) |
| **Pit_Stop**       | Parada nos Boxes              |
| **Result**         | Resultado                     |

</div>
<p align="center"><b>Fonte: </b>Autoria de  <a href="https://github.com/Julio1099"> Júlio Cezar </a></p>



## 3. Atributos


Os atributos representam as propriedades ou características de cada entidade do modelo, descrevendo as informações que serão armazenadas no banco de dados. Eles incluem tanto identificadores únicos (chaves primárias) quanto relacionamentos com outras entidades (chaves estrangeiras) e, eventualmente, atributos alternativos (chaves candidatas).

- As chaves primárias são representadas com <ins>sublinhado simples</ins>.
- As chaves estrangeiras são representadas com <span style="text-decoration: underline; text-decoration-style: dotted;">sublinhado pontilhado</span>.
- As chaves candidatas são representadas com <span style="text-decoration: underline; text-decoration-style: double;">sublinhado duplo</span>.

A Tabela 2 apresenta as entidades identificadas no modelo de dados, juntamente com seus respectivos atributos e o tipo de chave associada a cada um.
<p align="center"> Tabela 2 - Atributos e Chaves Primárias </p>

<div style="margin: 0 auto; width: fit-content;">

| **Entidade**       | **Atributos**    |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Race**           | <ins>id_corrida</ins>, ano, rodada, nome_corrida        |
| **Driver**         | <ins>id_piloto</ins>, primeiro_nome_piloto, sobrenome_piloto |
| **Constructor**    | <ins>id_equipe</ins>, nome_equipe    |
| **Status**         | <ins>id_status</ins>, descricao_status  |
| **Lap_Times_Fact** | <span style="text-decoration: underline; text-decoration-style: dotted;">id_corrida</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id_piloto</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">volta</span>, posicao_na_volta, tempo_volta_ms  |
| **Pit_Stop**       | <span style="text-decoration: underline; text-decoration-style: dotted;">id_corrida</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id_piloto</span>, duracao_parada_seg    |
| **Result**         | <span style="text-decoration: underline; text-decoration-style: dotted;">id_corrida</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id_piloto</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id_equipe</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id_status</span> |

</div>

<p align="center"><b>Fonte: </b>Autoria de  <a href="https://github.com/Julio1099"> Júlio Cezar </a></p>


## 4. Relacionamentos

Os relacionamentos representam as associações entre entidades, definindo como os elementos de uma se conectam ou interagem com os elementos de outra, e são essenciais para estruturar o banco de dados, capturando regras do mundo real, como um piloto realizando voltas em uma corrida ou uma equipe possuindo resultados. 

A tabela a seguir apresenta os principais relacionamentos do modelo de Fórmula 1. Lap_Times_Fact é a tabela fato central do modelo, registrando cada volta realizada por cada piloto em cada corrida. A cardinalidade de cada relação está representada no formato (mínimo, máximo), indicando o número mínimo e máximo de ocorrências entre as entidades envolvidas.

<p align="center"> Tabela 3- Principais Relacionamentos </p>

<div style="margin: 0 auto; width: fit-content;">

| **Relação**                           | **Cardinalidade Entidade 1** | **Cardinalidade Entidade 2** | **Descrição**                                                                                        |
| ------------------------------------- | ---------------------------- | ---------------------------- | ---------------------------------------------------------------------------------------------------- |
| **Race – Possui – Lap_Times_Fact**    | 0,N                          | 1,1                          | Uma corrida pode ter nenhuma ou várias voltas; cada volta pertence a uma única corrida.              |
| **Driver – Realiza – Lap_Times_Fact** | 0,N                          | 1,1                          | Um piloto pode realizar nenhuma ou várias voltas; cada volta é realizada por um único piloto.        |
| **Race – Possui – Pit_Stop**          | 0,N                          | 1,1                          | Uma corrida pode ter nenhuma ou várias paradas nos boxes; cada parada ocorre em uma única corrida.   |
| **Driver – Realiza – Pit_Stop**       | 0,N                          | 1,1                          | Um piloto pode realizar nenhuma ou várias paradas; cada parada é realizada por um único piloto.      |
| **Race – Possui – Result**            | 1,N                          | 1,1                          | Cada corrida tem pelo menos um resultado; cada resultado pertence a uma única corrida.               |
| **Driver – Participa – Result**       | 0,N                          | 1,1                          | Um piloto pode participar de nenhum ou vários resultados; cada resultado pertence a um único piloto. |
| **Constructor – Possui – Result**     | 0,N                          | 1,1                          | Uma equipe pode possuir nenhum ou vários resultados; cada resultado pertence a uma única equipe.     |
| **Status – Classifica – Result**      | 0,N                          | 1,1                          | Um status pode classificar nenhum ou vários resultados; cada resultado possui um único status.       |

</div>

<p align="center"><b>Fonte: </b>Autoria de  <a href="https://github.com/Julio1099"> Júlio Cezar </a></p>

## 5. Diagrama Conceitual

Finalmente, temos o Diagrama Conceitual que representa visualmente as entidades, seus atributos e os relacionamentos entre elas, permitindo compreender de forma clara como os elementos do modelo de Fórmula 1 se conectam, com Lap_Times_Fact funcionando como a tabela fato central do sistema.

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
     ┌──────▼──────┐(0,N)  │(0,N)  ┌──────▼──────┐
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
<p align="center"><b>Fonte: </b>Autoria de <a href="https://github.com/Julio1099"> Júlio Cezar </a></p>


<center>

## Histórico de versão

</center>

<div style="margin: 0 auto; width: fit-content;">


|    Data    | Versão |                 Descrição                 | Autores                                                                                                                                                                                                 |
|:----------:|:------:|:-----------------------------------------:| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 07/10/2025 | `1.0`  |        Criação do MER para Fórmula 1          | [Júlio Cesar](https://github.com/Julio1099)
| 08/10/2025 | `1.1`  |      Padronização da documentação         | [Othavio Bolzan](https://github.com/bolzanMGB)

</div>