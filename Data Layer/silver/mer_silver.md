# Modelo Conceitual de Dados — Camada Silver

## 1. Sumário Executivo

Este documento detalha o modelo conceitual de dados para a Camada Silver do *Data Lakehouse*. Em conformidade com a arquitetura estabelecida, a Camada Silver adota uma **estrutura desnormalizada** (tabela única) para consolidar todos os dados de contexto de Fórmula 1, facilitando a análise e o consumo direto pelas camadas posteriores (Gold/Análise).

## 2. Objetivo e Escopo

O objetivo deste Modelo Entidade-Relacionamento (MER) é descrever a **entidade única e central** que agrega todas as informações tratadas: resultados de corridas, dados de pilotos, detalhes de equipes e informações de *laps* e *pit stops*.

A **decisão arquitetural** foi consolidar todos os dados transacionais e de referência em uma única entidade (`ResultadosCorridas`). Essa abordagem visa:

* **Simplificar Consultas:** Reduzir a complexidade de *JOINs* para usuários da camada analítica.
* **Performance:** Otimizar a velocidade de acesso aos dados pré-unidos.
* **Visão Analítica:** Fornecer um registro *analítico* completo, onde cada linha representa o contexto integral de desempenho de um piloto em uma volta ou corrida.

## 3. Entidade Principal da Camada Silver

A entidade `ResultadosCorridas` é o núcleo da Camada Silver. Ela contém tanto os identificadores (para rastreabilidade) quanto os atributos textuais desnormalizados (para usabilidade analítica).

### Nome da Entidade: `ResultadosCorridas`

| Atributo | Tipo de Dado (Conceitual) | Rastreabilidade | Descrição Conceitual |
| :--- | :--- | :--- | :--- |
| **id\_corrida** | Chave Integrada | Origem: Corridas | Identificador único da corrida do campeonato. |
| **id\_piloto** | Chave Integrada | Origem: Pilotos | Identificador do piloto associado ao registro de desempenho. |
| **id\_equipe** | Chave Integrada | Origem: Equipes | Identificador da equipe (construtora) responsável pelo carro. |
| **id\_status** | Chave Integrada | Origem: Status | Identificador do código de status final do piloto na corrida (ex.: Terminou, Abandono, DSQ). |
| **ano** | Numérico | Origem: Corridas | Ano em que a corrida foi disputada. |
| **rodada** | Numérico | Origem: Corridas | Número da rodada dentro da temporada de F1. |
| **nome\_corrida** | Textual | Origem: Corridas | Nome oficial completo do Grande Prêmio (ex: "Italian Grand Prix"). |
| **volta** | Numérico | Origem: Laps | Número sequencial da volta registrada. **Admite valores nulos** quando o registro consolida o resultado final da corrida. |
| **posicao\_na\_volta** | Numérico | Origem: Laps | Posição ocupada pelo piloto ao final da volta registrada. |
| **tempo\_volta\_ms** | Numérico | Origem: Laps | Tempo de duração da volta em milissegundos. |
| **duracao\_parada\_seg** | Numérico | Origem: Pit Stops | Duração da parada nos boxes em segundos (com precisão decimal). **Admite valores nulos** na maioria dos registros de volta. |
| **primeiro\_nome\_piloto** | Textual | Origem: Pilotos | Primeiro nome do piloto (desnormalizado). |
| **sobrenome\_piloto** | Textual | Origem: Pilotos | Sobrenome do piloto (desnormalizado). |
| **nome\_equipe** | Textual | Origem: Equipes | Nome completo da equipe/construtora (desnormalizado). |
| **descricao\_status** | Textual | Origem: Status | Descrição textual do status final/motivo do fim (desnormalizado). |

> **Nota:** Os atributos marcados como *Chave Integrada* são mantidos para fins de auditoria e rastreabilidade com as tabelas de origem na Camada Bronze.

## 📜 Histórico de Versão

| Data | Versão | Descrição | Autor | Revisor |
| :---: | :---: | :--- | :--- | :--- |
| 07/10/2025 | `1.0` | Criação inicial do MER para Fórmula 1. | [Júlio Cesar](https://github.com/Julio1099) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 08/10/2025 | `1.1` | Padronização da documentação e estilos. | [Othavio Bolzan](https://github.com/bolzanMGB) | [Júlio Cesar](https://github.com/Julio1099) |
| 09/10/2025 | `1.2` | Correções conceituais no MER. | [Júlio Cesar](https://github.com/Julio1099) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 09/10/2025 | `1.3` | Ajustes no diagrama conceitual. | [Kaleb Macedo](https://github.com/kalebmacedo) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 09/10/2025 | `1.4` | Correções adicionais no diagrama (minor fix). | [Kaleb Macedo](https://github.com/kalebmacedo) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 29/10/2025 | **`1.5`** | Reestruturação fundamental para o modelo de Tabela Única (Desnormalizada) na Camada Silver. | [Júlio Cesar](https://github.com/Julio1099) | [Kaleb Macedo](https://github.com/kalebmacedo) |