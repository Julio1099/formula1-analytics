# Diagrama Lógico de Dados (DLD)

## 1. Introdução

O Diagrama Lógico de Dados descreve a estrutura física planejada para a camada Silver. Após a orientação do professor, a modelagem lógica foi consolidada em **uma única tabela relacional**, sem chaves estrangeiras nem relacionamentos derivados. O objetivo é disponibilizar um dataset denormalizado pronto para consumo analítico.

## 2. Estrutura Lógica

A tabela `ResultadosCorridas` centraliza os atributos que antes estavam distribuídos entre múltiplas entidades. A seguir, apresentamos os campos, seus tipos de dados e a obrigatoriedade prevista para o armazenamento.

| **Coluna** | **Tipo** | **Permite nulo?** | **Descrição** |
| :--------- | :------- | :---------------- | :------------ |
| `id_corrida` | INTEGER | NÃO | Identificador da corrida. |
| `id_piloto` | INTEGER | NÃO | Identificador do piloto. |
| `id_equipe` | INTEGER | SIM | Identificador da equipe (pode faltar em registros históricos incompletos). |
| `id_status` | INTEGER | SIM | Identificador do status final do piloto. |
| `ano` | INTEGER | NÃO | Ano em que a corrida ocorreu. |
| `rodada` | INTEGER | NÃO | Número da rodada da temporada. |
| `nome_corrida` | VARCHAR(100) | NÃO | Nome do Grande Prêmio. |
| `volta` | INTEGER | SIM | Número da volta; nula quando a informação não está disponível. |
| `posicao_na_volta` | INTEGER | SIM | Posição do piloto na volta registrada. |
| `tempo_volta_ms` | INTEGER | SIM | Tempo da volta em milissegundos. |
| `duracao_parada_seg` | DECIMAL(10,3) | SIM | Duração da parada em segundos. |
| `primeiro_nome_piloto` | VARCHAR(100) | NÃO | Primeiro nome do piloto. |
| `sobrenome_piloto` | VARCHAR(100) | NÃO | Sobrenome do piloto. |
| `nome_equipe` | VARCHAR(100) | SIM | Nome da equipe do piloto. |
| `descricao_status` | VARCHAR(255) | SIM | Descrição textual do status final. |

> Não existe chave primária física no modelo lógico. Quando necessário, a combinação `{id_corrida, id_piloto, volta}` pode ser utilizada como identificador lógico em consultas.

## Histórico de Versão

|  **Data**  | **Versão** |      **Descrição**     |                   **Autor**                   |                   **Revisor**                  |
| :--------: | :--------: | :--------------------: | :-------------------------------------------: | :--------------------------------------------: |
| 09/10/2025 | `1.0`      | Criação do DLD inicial | [Othavio Bolzan](https://github.com/bolzanMGB) | [Júlio Cesar](https://github.com/Julio1099) |
| 24/10/2025 | `1.1`      | Ajuste do DLD para tabela única | [Kaleb Macedo](https://github.com/kalebmacedo) | [Júlio Cesar](https://github.com/Julio1099) |
