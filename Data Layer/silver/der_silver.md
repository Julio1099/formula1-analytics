# Diagrama Entidade-Relacionamento (DER) - Camada Silver

## 1. Introdução

O DER da camada Silver evidencia que o modelo conceitual foi simplificado para uma única entidade. Não há relacionamentos, cardinalidades ou entidades auxiliares: todo o contexto necessário para análises está materializado na tabela `ResultadosCorridas`.

## 2. Estrutura do Diagrama

O diagrama reduzido apresenta somente a entidade e seus atributos principais. Optamos por manter a indicação visual em texto, já que não existem vínculos a representar.

<p align="center"> Tabela 1 - DER Silver</p>

```mermaid
erDiagram
    %% A camada Silver é denormalizada, consistindo em uma única entidade.
    %% Não há relações com outras entidades dentro desta camada.
    
    ResultadosCorridas {
        INTEGER id_corrida "Chave de Negócio (BK) | FK Lógico"
        INTEGER id_piloto "Chave de Negócio (BK) | FK Lógico"
        INTEGER id_equipe "Chave de Negócio (BK) | FK Lógico"
        INTEGER id_status "Chave de Negócio (BK) | FK Lógico"
        
        INTEGER ano
        INTEGER rodada
        VARCHAR nome_corrida
        
        INTEGER volta
        INTEGER posicao_na_volta
        INTEGER tempo_volta_ms "Fato: tempo da volta em ms"
        DECIMAL duracao_parada_seg "Fato: duração do pit stop em segundos"
        
        VARCHAR primeiro_nome_piloto "Atributo Desnormalizado"
        VARCHAR sobrenome_piloto "Atributo Desnormalizado"
        VARCHAR nome_equipe "Atributo Desnormalizado"
        VARCHAR descricao_status "Atributo Desnormalizado"
    }

```
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cesar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>

> Nota: Todos os relacionamentos originalmente planejados na modelagem conceitual foram incorporados no processo de transformação (Bronze → Silver), e por isso não aparecem no diagrama.

## Histórico de Versão

|  **Data**  | **Versão** |            **Descrição**            |                    **Autor**                   | **Revisor** |
| :--------: | :--------: | :---------------------------------: | :--------------------------------------------: | :---------: |
| 09/10/2025 | `1.0`      | Documentação inicial do DER         | [Othavio Bolzan](https://github.com/bolzanMGB) | [Kaleb Macedo](https://github.com/kalebmacedo) |
| 09/10/2025 | `1.1`      | Criação do diagrama DER             | [Othavio Bolzan](https://github.com/bolzanMGB), [Kaleb Macedo](https://github.com/kalebmacedo) | [Júlio Cesar](https://github.com/Julio1099)  |
| 24/10/2025 | `1.2`      | Ajuste para representação de tabela única | [Kaleb Macedo](https://github.com/kalebmacedo) | [Júlio Cesar](https://github.com/Julio1099) |
| 31/10/2025 | **`1.6`** | Refatorização da documentação | [Othavio Bolzan](https://github.com/bolzanMGB) | [Kaleb Macedo](https://github.com/kalebmacedo) |