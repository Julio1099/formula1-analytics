# MER — Camada Silver

# Modelo Entidade-Relacionamento

 > Este modelo representa a estrutura completa para um banco de dados relacional baseado em um dataset de Fórmula 1. Ele é composto por tabelas de **dimensão**, que descrevem entidades (pilotos, circuitos, etc.), e tabelas **fato**, que registram eventos e métricas (resultados, voltas, etc.).

---

## Entidades e Atributos

> Aqui estão todas as entidades (tabelas) com a lista completa de seus atributos. As chaves estão marcadas como: **(PK)** para Chave Primária e *(FK)* para Chave Estrangeira.

### Tabelas de Dimensão
São as tabelas que descrevem as entidades principais e fornecem contexto aos dados.

#### Season
- **year (PK)**: O ano da temporada.
- `url`: Link da Wikipedia para a temporada.

#### Circuit
- **circuitId (PK)**: Identificador único do circuito.
- `circuitRef`: Um identificador de texto curto para o circuito.
- `name`: Nome oficial do circuito.
- `location`: Cidade ou localidade do circuito.
- `country`: País do circuito.
- `lat`: Latitude geográfica.
- `lng`: Longitude geográfica.
- `alt`: Altitude em metros.
- `url`: Link da Wikipedia para o circuito.

#### Driver
- **driverId (PK)**: Identificador único do piloto.
- `driverRef`: Identificador de texto curto para o piloto.
- `number`: Número permanente do carro do piloto (pode ser nulo).
- `code`: Código de três letras do piloto (ex: HAM, VER).
- `forename`: Primeiro nome do piloto.
- `surname`: Sobrenome do piloto.
- `dob`: Data de nascimento.
- `nationality`: Nacionalidade do piloto.
- `url`: Link da Wikipedia para o piloto.

#### Constructor
- **constructorId (PK)**: Identificador único da equipe (construtor).
- `constructorRef`: Identificador de texto curto para a equipe.
- `name`: Nome oficial da equipe.
- `nationality`: Nacionalidade da equipe.
- `url`: Link da Wikipedia para a equipe.

#### Status
- **statusId (PK)**: Identificador único para o status final de uma corrida.
- `status`: Descrição do status (ex: "Finished", "Accident", "+1 Lap").

### Tabela de Dimensão/Evento
Esta tabela descreve um evento principal e conecta a maioria das tabelas fato.

#### Race
- **raceId (PK)**: Identificador único da corrida.
- *year (FK -> Season)*: Ano da temporada em que a corrida ocorreu.
- `round`: Número da rodada da corrida dentro da temporada.
- *circuitId (FK -> Circuit)*: Identificador do circuito onde a corrida foi realizada.
- `name`: Nome oficial do Grande Prêmio.
- `date`: Data da corrida.
- `time`: Hora da corrida (UTC).
- `url`: Link da Wikipedia para a corrida.
- `fp1_date`, `fp1_time`: Data e hora do Treino Livre 1.
- `fp2_date`, `fp2_time`: Data e hora do Treino Livre 2.
- `fp3_date`, `fp3_time`: Data e hora do Treino Livre 3.
- `quali_date`, `quali_time`: Data e hora da Classificação.
- `sprint_date`, `sprint_time`: Data e hora da Corrida Sprint.

### Tabelas Fato
São as tabelas que registram as métricas e os eventos que ocorrem, ligando-se às dimensões.

#### Result
- **resultId (PK)**: Identificador único do resultado.
- *raceId (FK -> Race)*: Corrida à qual o resultado pertence.
- *driverId (FK -> Driver)*: Piloto que alcançou o resultado.
- *constructorId (FK -> Constructor)*: Equipe do piloto.
- *statusId (FK -> Status)*: Status final do piloto na corrida.
- `number`: Número do carro do piloto na corrida.
- `grid`: Posição de largada no grid.
- `position`: Posição final na corrida (pode ser nulo).
- `positionText`: Representação textual da posição final.
- `positionOrder`: Ordem numérica da posição final para classificação.
- `points`: Pontos conquistados na corrida.
- `laps`: Número de voltas completadas.
- `time`: Tempo total de corrida ou diferença para o vencedor.
- `milliseconds`: Tempo total em milissegundos.
- `fastestLap`: Número da volta mais rápida do piloto.
- `rank`: Posição do tempo da volta mais rápida entre todos os pilotos.
- `fastestLapTime`: Tempo da volta mais rápida.
- `fastestLapSpeed`: Velocidade média na volta mais rápida.

#### SprintResult
- **resultId (PK)**: Identificador único do resultado da sprint.
- *raceId (FK -> Race)*: Evento de corrida ao qual a sprint pertence.
- *driverId (FK -> Driver)*: Piloto que alcançou o resultado.
- *constructorId (FK -> Constructor)*: Equipe do piloto.
- *statusId (FK -> Status)*: Status final do piloto na sprint.
- `number`: Número do carro do piloto.
- `grid`: Posição de largada na sprint.
- `position`: Posição final.
- `positionText`: Representação textual da posição.
- `positionOrder`: Ordem numérica da posição final.
- `points`: Pontos conquistados na sprint.
- `laps`: Número de voltas completadas.
- `time`: Tempo total ou diferença para o vencedor.
- `milliseconds`: Tempo total em milissegund
- `fastestLap`: Número da volta mais rápida do piloto.
- `fastestLapTime`: Tempo da volta mais rápida.

#### Qualifying
- **qualifyId (PK)**: Identificador único do resultado da classificação.
- *raceId (FK -> Race)*: Corrida à qual a classificação pertence.
- *driverId (FK -> Driver)*: Piloto que participou.
- *constructorId (FK -> Constructor)*: Equipe do piloto.
- `number`: Número do carro do piloto.
- `position`: Posição final na classificação.
- `q1`: Tempo na Sessão de Classificação 1.
- `q2`: Tempo na Sessão de Classificação 2.
- `q3`: Tempo na Sessão de Classificação 3.

#### LapTime
- **raceId (PK, FK -> Race)**: Identificador da corrida.
- **driverId (PK, FK -> Driver)**: Identificador do piloto.
- **lap (PK)**: O número da volta.
- `position`: Posição do piloto ao completar a volta.
- `time`: Tempo da volta (formato string).
- `milliseconds`: Tempo da volta em milissegundos.

#### PitStop
- **raceId (PK, FK -> Race)**: Identificador da corrida.
- **driverId (PK, FK -> Driver)**: Identificador do piloto.
- **stop (PK)**: O número da parada (1ª, 2ª, etc.).
- `lap`: Volta em que a parada ocorreu.
- `time`: Hora do dia em que a parada ocorreu.
- `duration`: Duração da parada (formato string).
- `milliseconds`: Duração da parada em milissegundos.

#### DriverStanding
- **driverStandingsId (PK)**: Identificador único do registro de classificação.
- *raceId (FK -> Race)*: A classificação do piloto *após* esta corrida.
- *driverId (FK -> Driver)*: O piloto em questão.
- `points`: Total de pontos do piloto no campeonato.
- `position`: Posição do piloto no campeonato.
- `positionText`: Representação textual da posição.
- `wins`: Número total de vitórias na temporada.

#### ConstructorStanding
- **constructorStandingsId (PK)**: Identificador único do registro de classificação.
- *raceId (FK -> Race)*: A classificação da equipe *após* esta corrida.
- *constructorId (FK -> Constructor)*: A equipe em questão.
- `points`: Total de pontos da equipe no campeonato.
- `position`: Posição da equipe no campeonato.
- `positionText`: Representação textual da posição.
- `wins`: Número total de vitórias da equipe na temporada.

#### ConstructorResult
- **constructorResultsId (PK)**: Identificador único do resultado da equipe.
- *raceId (FK -> Race)*: Corrida à qual o resultado pertence.
- *constructorId (FK -> Constructor)*: A equipe em questão.
- `points`: Pontos somados pela equipe nesta corrida.
- `status`: Um campo de status textual (raramente usado nos dados).

---

## Relacionamentos e Cardinalidades

- Uma `Season` **tem** `(1,N)` (uma ou muitas) `Race`.
- Uma `Race` **pertence a** `(1,1)` (exatamente uma) `Season`.
- Um `Circuit` **sedia** `(0,N)` (zero ou muitas) `Race`.
- Uma `Race` **ocorre em** `(1,1)` (exatamente um) `Circuit`.
- Uma `Race` **possui** `(0,N)` `Result`, `SprintResult`, `Qualifying`, `LapTime`, `PitStop`, `DriverStanding`, `ConstructorStanding` e `ConstructorResult`.
- Um `Driver` **participa em/obtém** `(0,N)` `Result`, `SprintResult`, `Qualifying`, `LapTime`, `PitStop` e `DriverStanding`.
- Um `Constructor` **participa em/obtém** `(0,N)` `Result`, `SprintResult`, `Qualifying`, `ConstructorStanding` e `ConstructorResult`.
- Um `Status` **descreve** `(0,N)` `Result` e `SprintResult`.
- Cada registro nas tabelas fato (`Result`, `LapTime`, etc.) **refere-se a** `(1,1)` `Race`, `(1,1)` `Driver` e/ou `(1,1)` `Constructor`, conforme aplicável.

