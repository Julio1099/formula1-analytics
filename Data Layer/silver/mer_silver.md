# Modelo Entidade-Relacionamento

## 1. Objetivo

A camada Silver passou a consolidar **todos os dados tratados em uma única entidade**. O modelo conceitual precisa refletir essa decisão acadêmica: manter uma visão denormalizada, sem relacionamentos, que já combine informações de corridas, pilotos, equipes, tempos de volta, resultados e paradas nos boxes. Assim, o MER descreve apenas a entidade central que representa o registro analítico pronto para as camadas superiores.

## 2. Entidade da Camada Silver

A entidade `ResultadosCorridas` agrupa, em cada linha, o contexto completo de desempenho de um piloto em uma corrida e (quando existir) a volta correspondente. Essa estrutura facilita consultas diretas durante a etapa analítica, ao custo de duplicar dados textuais herdados das tabelas de referência.

| **Atributo** | **Descrição conceitual** |
| :----------- | :----------------------- |
| `id_corrida` | Identificador da corrida do campeonato. |
| `id_piloto` | Identificador do piloto associado ao registro. |
| `id_equipe` | Identificador da equipe responsável pelo carro do piloto. |
| `id_status` | Identificador do status final do piloto na corrida (ex.: terminou, abandono). |
| `ano` | Ano em que a corrida foi disputada. |
| `rodada` | Número da rodada dentro da temporada. |
| `nome_corrida` | Nome oficial do Grande Prêmio. |
| `volta` | Número da volta; admite valores nulos quando o dado é consolidado por resultado. |
| `posicao_na_volta` | Posição ocupada pelo piloto na volta registrada. |
| `tempo_volta_ms` | Tempo da volta em milissegundos. |
| `duracao_parada_seg` | Duração da parada nos boxes em segundos (quando houver). |
| `primeiro_nome_piloto` | Primeiro nome do piloto. |
| `sobrenome_piloto` | Sobrenome do piloto. |
| `nome_equipe` | Nome da equipe/construtora. |
| `descricao_status` | Descrição textual do status final. |

> **Observação:** não há chaves estrangeiras, e a entidade não define uma chave primária física. A unicidade pode ser tratada a partir do trio {`id_corrida`, `id_piloto`, `volta`} quando relevante, porém a ausência de restrição facilita a ingestão de registros sem volta informada.

## 3. Representação Conceitual

A figura abaixo ilustra o MER reduzido para a tabela única.

```
+--------------------------------------------------------------+
|                    ResultadosCorridas                        |
|--------------------------------------------------------------|
| id_corrida, ano, rodada, nome_corrida                        |
| id_piloto, primeiro_nome_piloto, sobrenome_piloto            |
| id_equipe, nome_equipe                                       |
| id_status, descricao_status                                  |
| volta, posicao_na_volta, tempo_volta_ms, duracao_parada_seg  |
+--------------------------------------------------------------+
```

Não existem relacionamentos a serem representados, apenas os atributos que compõem a entidade da camada Silver.

## Histórico de versão
|    Data    | Versão |                 Descrição                 |                   Autor                   |                   Revisor                  |
|:----------:|:------:|:-----------------------------------------:|:-----------------------------------------:|:------------------------------------------:|
| 07/10/2025 | `1.0`  | Criação do MER para Fórmula 1             | [Júlio Cesar](https://github.com/Julio1099) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 08/10/2025 | `1.1`  | Padronização da documentação              | [Othavio Bolzan](https://github.com/bolzanMGB) | [Júlio Cesar](https://github.com/Julio1099) |
| 09/10/2025 | `1.2`  | Correções no MER                          | [Júlio Cesar](https://github.com/Julio1099) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 09/10/2025 | `1.3`  | Ajustes no diagrama do MER                | [Kaleb Macedo](https://github.com/kalebmacedo) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 09/10/2025 | `1.4`  | Correções adicionais no diagrama          | [Kaleb Macedo](https://github.com/kalebmacedo) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 24/10/2025 | `1.5`  | Reestruturação para modelo de tabela única| [Kaleb Macedo](https://github.com/kalebmacedo) | [Júlio Cesar](https://github.com/Julio1099) |
