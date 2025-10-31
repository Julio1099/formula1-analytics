# Diagrama Entidade-Relacionamento (DER) — Camada Gold

## 1. Introdução

Este documento descreve o **Diagrama Entidade-Relacionamento (DER)** da Camada Gold do data lakehouse de Fórmula 1. O objetivo é apresentar uma visão lógica e visual do **Star Schema** que sustenta o modelo analítico, permitindo rápidas iterações de BI e governança consistente com o MER documentado em `mer_gold.md`.

A Camada Gold agrega métricas e dimensões já tratadas, otimizadas para consumo em dashboards que comparam pilotos, equipes, pit stops e incidentes. O DER garante que todos entendam a estrutura dimensional, as cardinalidades e os atributos fundamentais que suportam as consultas analíticas.

## 2. Visão Geral do DER

<p align="center"><b>Figura 1</b> – <a href="assets/DERgold01.png">DER da Camada Gold</a></p>

![DERgold](assets/DERgold01.png)

<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>

## 3. Componentes do Diagrama

**FT_VOLTAS_TEMPO_PARADA** :
É a tabela de fato central. Cada linha representa a menor granularidade disponível (volta do piloto na corrida) e carrega métricas de tempo, pit stop, pontos e vitórias.


**Dimensões** (`DM_PILOTO`, `DM_EQUIPE`, `DM_CORRIDA`, `DM_STATUS`): 
Oferecem contexto descritivo. Todas utilizam *surrogate keys* (`SRK`) e mantêm a *business key* (`chave_*_origem`) para rastreabilidade.

**Cardinalidades**:
 As relações são `1:N`, partindo das dimensões (1) para a fato (N). Assim, um piloto pode existir sem registros na fato (0..N), mas cada ocorrência da fato referencia obrigatoriamente uma dimensão.
 
 **Integridade**: A fato possui a restrição única `(srk_piloto, srk_corrida, volta)`, garantindo unicidade do evento analítico.


## 3. Histórico de Versões

| Data | Versão | Descrição | Autor | Revisor |
| :--: | :----: | :-------- | :---- | :----- |
| 31/10/2025 | `1.0` | Documentação do DER. | [Kaleb Macedo](https://github.com/kalebmacedo), [Othavio Bolzan](https://github.com/bolzanMGB) |  |

