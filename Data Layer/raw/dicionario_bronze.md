# Dicionário de Dados Bronze

## 1. Introdução

Este documento serve como a documentação para o dicionário de dados do sistema. Ele descreve cada elemento de dados utilizado pelo sistema, explicando o que são, onde estão armazenados e como se relacionam. Logo abaixo na Tabela 1 há uma lista das tabelas utilizadas.


<p align="center"> Tabela 1 - Tabelas utilizadas</p>

<div style="margin: 0 auto; width: fit-content;">

| Tabelas                                                |
|:-------------------------------------------------------|
| [Circuits](#tabela-circuits)                           |
| [Constructor_Results](#tabela-constructor_results)     |
| [Constructor_Standings](#tabela-constructor_standings) |
| [Constructors](#tabela-constructors)                   |
| [Driver_Standings](#tabela-driver_standings)           |
| [Drivers](#tabela-drivers)                             |
| [Lap_Times](#tabela-lap_times)                         |
| [Pit_Stops](#tabela-pit_stops)                         |
| [Qualifying](#tabela-qualifying)                       |
| [Races](#tabela-races)                                 |
| [Results](#tabela-results)                             |
| [Seasons](#tabela-seasons)                             |
| [Sprint_Results](#tabela-sprint_results)               |
| [Status](#tabela-status)                               |

</div>

<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>


## 2. Tabela Circuits

Essa tabela Armazena as informações dos circuitos onde as corridas acontecem, cada circuito é identificado de forma única por `circuitId`.     


<p align="center"> Tabela 2 - Tabela Circuits</p>

<div style="margin: 0 auto; width: fit-content;">

| Nome       | Definição Lógica                                             | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:-----------|:-------------------------------------------------------------|:-----------------------|---------|:----------------------|
| circuitId  | Identificador único do circuito                              | SERIAL                 | -       | PRIMARY KEY           |
| circuitRef | Referência curta (slug) do circuito                          | CHAR                | 20       | NOT NULL              |
| name       | Nome oficial do circuito                                     | CHAR                | 45       | NOT NULL              |
| location   | Cidade/localidade do circuito                                | CHAR                | 20       | NOT NULL              |
| country    | País onde o circuito está localizado                         | CHAR                | 15       | NOT NULL              |
| lat        | Latitude geográfica                                          | FLOAT                  | -       | NOT NULL              |
| lng        | Longitude geográfica                                         | FLOAT                  | -       | NOT NULL              |
| alt        | Altitude em metros                                           | INTEGER                | -       | NULL                  |
| url        | Link para a página do circuito (Wikipedia)                   | CHAR                | 150       | NOT NULL              |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 3. Tabela Constructor_Results

Essa tabela registra os resultados obtidos pelos construtores em cada corrida. Ela se relaciona com as tabelas [Races](#tabela-races) e [Constructors](#tabela-constructors). 



<p align="center"> Tabela 3 - Constructor_Results</p>
<div style="margin: 0 auto; width: fit-content;">

| Nome                 | Definição Lógica                                            | Tipo e Formato de Dado | Tamanho | Restrições de Domínio  |
|:---------------------|:------------------------------------------------------------|:-----------------------|---------|:-----------------------|
| constructorResultsId | Identificador único do resultado                            | SERIAL                 | -       | PRIMARY KEY            |
| raceId               | Referência da corrida                                       | INTEGER                | -       | FOREIGN KEY, NOT NULL  |
| constructorId        | Construtor que obteve o resultado                           | INTEGER                | -       | FOREIGN KEY, NOT NULL  |
| points               | Pontos obtidos na corrida                                   | FLOAT                  | -       | NOT NULL               |
| status               | Status do resultado (pode ser nulo)                         | CHAR                | 10       | NULL                   |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 4. Tabela Constructor_Standings

Essa tabela representa a classificação dos construtores em determinado momento da temporada. Ela usa informações de [Races](#tabela-races) e [Constructors](#tabela-constructors).   

<p align="center"> Tabela 4 - Constructor_Standings</p>
<div style="margin: 0 auto; width: fit-content;">



| Nome                  | Definição Lógica                                            | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:----------------------|:------------------------------------------------------------|:-----------------------|---------|:----------------------|
| constructorStandingsId| Identificador único                                         | SERIAL                 | -       | PRIMARY KEY           |
| raceId                | Corrida associada                                          | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| constructorId         | Construtor relacionado                                     | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| points                | Pontos acumulados até a corrida                            | FLOAT                  | -       | NOT NULL              |
| position              | Posição numérica no campeonato                             | INTEGER                | -       | NOT NULL              |
| positionText          | Representação textual da posição                           | CHAR                | 5       | NOT NULL              |
| wins                  | Número de vitórias acumuladas                              | INTEGER                | -       | NOT NULL              |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 5. Tabela Constructors

Essa tabela contém os dados principais dos construtores de Fórmula 1. Ela se relaciona com diversas tabelas de resultados e classificações.   

<p align="center"> Tabela 5 - Constructors </p>
<div style="margin: 0 auto; width: fit-content;">        

| Nome          | Definição Lógica                               | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:--------------|:-----------------------------------------------|:-----------------------|---------|:----------------------|
| constructorId | Identificador único do construtor              | SERIAL                 | -       | PRIMARY KEY           |
| constructorRef| Referência curta (slug)                        | CHAR                | 20       | NOT NULL              |
| name          | Nome oficial do construtor                     | CHAR                | 30       | NOT NULL              |
| nationality   | Nacionalidade do construtor                    | CHAR                | 15       | NOT NULL              |
| url           | Link para página do construtor (Wikipedia)     | CHAR                | 150       | NOT NULL              |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 6. Tabela Driver_Standings


Essa tabela representa a classificação dos pilotos em determinado ponto da temporada. Ela usa informações de [Races](#tabela-races) e [Drivers](#tabela-drivers).          
<p align="center"> Tabela 6 - Driver_Standings </p>
<div style="margin: 0 auto; width: fit-content;">


| Nome             | Definição Lógica                             | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:-----------------|:---------------------------------------------|:-----------------------|---------|:----------------------|
| driverStandingsId| Identificador único                         | SERIAL                 | -       | PRIMARY KEY           |
| raceId           | Corrida associada                           | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| driverId         | Piloto relacionado                          | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| points           | Pontos acumulados                           | FLOAT                  | -       | NOT NULL              |
| position         | Posição numérica                            | INTEGER                | -       | NOT NULL              |
| positionText     | Representação textual da posição            | CHAR                | 5       | NOT NULL              |
| wins             | Número de vitórias acumuladas               | INTEGER                | -       | NOT NULL              |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>


## 7. Tabela Drivers


Essa tabela Contém as informações pessoais e de carreira dos pilotos.Cada piloto é identificado de forma única por `driverId`.                 

<p align="center"> Tabela 7 - Drivers </p>

<div style="margin: 0 auto; width: fit-content;">

| Nome       | Definição Lógica                                   | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:-----------|:---------------------------------------------------|:-----------------------|---------|:----------------------|
| driverId   | Identificador único do piloto                      | SERIAL                 | -       | PRIMARY KEY           |
| driverRef  | Referência curta (slug)                            | CHAR                | 25       | NOT NULL              |
| number     | Número do carro                                    | INTEGER                | -       | NULL                  |
| code       | Código oficial do piloto (ex: HAM, ROS)            | CHAR                | 3       | NOT NULL              |
| forename   | Primeiro nome do piloto                            | CHAR                | 20       | NOT NULL              |
| surname    | Sobrenome do piloto                                | CHAR                | 20       | NOT NULL              |
| dob        | Data de nascimento                                 | DATE                   | -       | NOT NULL              |
| nationality| Nacionalidade do piloto                            | CHAR                | 20       | NOT NULL              |
| url        | Página do piloto (Wikipedia)                       | CHAR                | 150       | NOT NULL              |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 8. Tabela Lap_Times


Essa tabela armazena os tempos de cada volta de cada piloto em determinada corrida. Ela se relaciona [Races](#tabela-races) e [Drivers](#tabela-drivers).   

<p align="center"> Tabela 8 - Lap_Times </p> 
<div style="margin: 0 auto; width: fit-content;">

| Nome        | Definição Lógica                                | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:------------|:------------------------------------------------|:-----------------------|---------|:----------------------|
| raceId      | Referência da corrida                           | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| driverId    | Piloto que realizou a volta                     | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| lap         | Número da volta                                 | INTEGER                | -       | NOT NULL              |
| position    | Posição do piloto nessa volta                   | INTEGER                | -       | NOT NULL              |
| time        | Tempo da volta (formato `M:SS.mmm`)             | CHAR                | 20       | NOT NULL              |
| milliseconds| Tempo da volta em milissegundos                 | INTEGER                | -       | NOT NULL              |

</div>

<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 9. Tabela Pit_Stops



Essa tabela registra as paradas de pit stop realizadas pelos pilotos durante a corrida.   Ela se relaciona com [Races](#tabela-races) e [Drivers](#tabela-drivers).              
<p align="center"> Tabela 9 - Pit_Stops </p>

<div style="margin: 0 auto; width: fit-content;">

| Nome        | Definição Lógica                                | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:------------|:------------------------------------------------|:-----------------------|---------|:----------------------|
| raceId      | Corrida em que o pit stop ocorreu               | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| driverId    | Piloto que realizou o pit stop                  | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| stop        | Número sequencial da parada                     | INTEGER                | -       | NOT NULL              |
| lap         | Volta em que ocorreu o pit stop                  | INTEGER                | -       | NOT NULL              |
| time        | Hora do pit stop (HH:MM:SS)                     | CHAR                | 20       | NOT NULL              |
| duration    | Duração da parada em segundos                   | DECIMAL(5,2)                | -       | NOT NULL              |
| milliseconds| Duração da parada em milissegundos              | INTEGER                | -       | NOT NULL              |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 10. Tabela Qualifying


Essa tabela armazena os resultados das sessões de qualificação.  Ela se relaciona com [Races](#tabela-races), [Drivers](#tabela-drivers) e [Constructors](#tabela-constructors). 

<p align="center"> Tabela 10 - Qualifying </p>

<div style="margin: 0 auto; width: fit-content;">

| Nome        | Definição Lógica                                | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:------------|:------------------------------------------------|:-----------------------|---------|:----------------------|
| qualifyId   | Identificador único da sessão                   | SERIAL                 | -       | PRIMARY KEY           |
| raceId      | Corrida relacionada                             | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| driverId    | Piloto relacionado                              | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| constructorId| Construtor relacionado                         | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| number      | Número do carro                                 | INTEGER                | -       | NOT NULL              |
| position    | Posição de largada definida                     | INTEGER                | -       | NOT NULL              |
| q1          | Tempo obtido na sessão Q1                       | CHAR                | 15       | NULL                  |
| q2          | Tempo obtido na sessão Q2                       | CHAR                | 15       | NULL                  |
| q3          | Tempo obtido na sessão Q3                       | CHAR                | 15       | NULL                  |

</div>

<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 11. Tabela Races

Essa tabela armazena as informações principais das corridas de Fórmula 1.  Ela se relaciona com [Circuits](#tabela-circuits) e diversas tabelas de resultados.  

<p align="center"> Tabela 11 - Races </p>

<div style="margin: 0 auto; width: fit-content;">

| Nome        | Definição Lógica                                | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:------------|:------------------------------------------------|:-----------------------|---------|:----------------------|
| raceId      | Identificador único da corrida                  | SERIAL                 | -       | PRIMARY KEY           |
| year        | Ano da corrida                                  | INTEGER                | -       | NOT NULL              |
| round       | Rodada da temporada                             | INTEGER                | -       | NOT NULL              |
| circuitId   | Circuito associado                              | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| name        | Nome da corrida (GP)                            | CHAR                | 40       | NOT NULL              |
| date        | Data da corrida                                 | DATE                   | -       | NOT NULL              |
| time        | Hora de início                                  | TIME                   | -       | NULL                  |
| url         | Link Wikipedia                                  | CHAR                | 150       | NOT NULL              |
| fp1_date    | Data do treino livre 1                          | DATE                   | -       | NULL                  |
| fp1_time    | Hora do treino livre 1                          | TIME                   | -       | NULL                  |
| fp2_date    | Data do treino livre 2                          | DATE                   | -       | NULL                  |
| fp2_time    | Hora do treino livre 2                          | TIME                   | -       | NULL                  |
| fp3_date    | Data do treino livre 3                          | DATE                   | -       | NULL                  |
| fp3_time    | Hora do treino livre 3                          | TIME                   | -       | NULL                  |
| quali_date  | Data da classificação                           | DATE                   | -       | NULL                  |
| quali_time  | Hora da classificação                           | TIME                   | -       | NULL                  |
| sprint_date | Data da corrida sprint                          | DATE                   | -       | NULL                  |
| sprint_time | Hora da corrida sprint                          | TIME                   | -       | NULL                  |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 12. Tabela Results

Essa tabela armazena os resultados das corridas (classificação final, pontos, voltas, etc.). Ela se relaciona com [Races](#tabela-races), [Drivers](#tabela-drivers), [Constructors](#tabela-constructors) e [Status](#tabela-status). 

<p align="center"> Tabela 12 - Results </p>

<div style="margin: 0 auto; width: fit-content;">

| Nome            | Definição Lógica                                | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:----------------|:------------------------------------------------|:-----------------------|---------|:----------------------|
| resultId        | Identificador único do resultado                | SERIAL                 | -       | PRIMARY KEY           |
| raceId          | Corrida relacionada                             | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| driverId        | Piloto relacionado                              | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| constructorId   | Construtor relacionado                          | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| number          | Número do carro                                 | INTEGER                | -       | NOT NULL              |
| grid            | Posição de largada                              | INTEGER                | -       | NOT NULL              |
| position        | Posição final numérica                          | INTEGER                | -       | NULL                  |
| positionText    | Representação textual da posição                | CHAR                | 5       | NOT NULL              |
| positionOrder   | Ordem final (mesmo se DNF)                      | INTEGER                | -       | NOT NULL              |
| points          | Pontos obtidos                                  | FLOAT                  | -       | NOT NULL              |
| laps            | Voltas completadas                              | INTEGER                | -       | NOT NULL              |
| time            | Tempo total ou diferença                        | CHAR                | 20       | NULL                  |
| milliseconds    | Tempo total em milissegundos                    | INTEGER                | -       | NULL                  |
| fastestLap      | Volta mais rápida                               | INTEGER                | -       | NULL                  |
| rank            | Ranking da volta mais rápida                    | INTEGER                | -       | NULL                  |
| fastestLapTime  | Tempo da volta mais rápida                      | CHAR                | 30       | NULL                  |
| fastestLapSpeed | Velocidade média da volta mais rápida (km/h)    | FLOAT                  | -       | NULL                  |
| statusId        | Status do piloto                                | INTEGER                | -       | FOREIGN KEY, NOT NULL |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 13. Tabela Seasons

Essa tabela representa as temporadas de Fórmula 1, nela cada temporada é identificada pelo ano. 

<p align="center"> Tabela 13 - Seasons </p>

<div style="margin: 0 auto; width: fit-content;">

| Nome | Definição Lógica                     | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:-----|:-------------------------------------|:-----------------------|---------|:----------------------|
| year | Ano da temporada                     | INTEGER                | -       | PRIMARY KEY           |
| url  | Link para Wikipedia                  | CHAR                | 150       | NOT NULL              |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 14. Tabela Sprint_Results

Essa tabela armazena os resultados das corridas sprint. Ela se relaciona com [Races](#tabela-races), [Drivers](#tabela-drivers), [Constructors](#tabela-constructors) e [Status](#tabela-status).

<p align="center"> Tabela 14 - Sprint_Results </p>

<div style="margin: 0 auto; width: fit-content;">

| Nome            | Definição Lógica                                | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:----------------|:------------------------------------------------|:-----------------------|---------|:----------------------|
| sprintResultId  | Identificador único do resultado sprint         | SERIAL                 | -       | PRIMARY KEY           |
| raceId          | Corrida relacionada                             | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| driverId        | Piloto relacionado                              | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| constructorId   | Construtor relacionado                          | INTEGER                | -       | FOREIGN KEY, NOT NULL |
| number          | Número do carro                                 | INTEGER                | -       | NOT NULL              |
| grid            | Posição de largada                              | INTEGER                | -       | NOT NULL              |
| position        | Posição final                                   | INTEGER                | -       | NULL                  |
| positionText    | Representação textual da posição                | CHAR                | 5       | NOT NULL              |
| positionOrder   | Ordem final (mesmo se DNF)                      | INTEGER                | -       | NOT NULL              |
| points          | Pontos obtidos                                  | FLOAT                  | -       | NOT NULL              |
| laps            | Voltas completadas                              | INTEGER                | -       | NOT NULL              |
| time            | Tempo total ou diferença                        | CHAR                | 30       | NULL                  |
| milliseconds    | Tempo total em milissegundos                    | INTEGER                | -       | NULL                  |
| fastestLap      | Volta mais rápida                               | INTEGER                | -       | NULL                  |
| fastestLapTime  | Tempo da volta mais rápida                      | CHAR                | 30       | NULL                  |
| statusId        | Status do piloto                                | INTEGER                | -       | FOREIGN KEY, NOT NULL |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## 15. Tabela Status

Esta tabela contém os diferentes status que um piloto pode ter no final de uma corrida. Ela se relaciona com [Results](#tabela-results) e [Sprint_Results](#tabela-sprint_results). 

<p align="center"> Tabela 15 - Status </p>

<div style="margin: 0 auto; width: fit-content;">

| Nome     | Definição Lógica                       | Tipo e Formato de Dado | Tamanho | Restrições de Domínio |
|:---------|:---------------------------------------|:-----------------------|---------|:----------------------|
| statusId | Identificador único do status          | SERIAL                 | -       | PRIMARY KEY           |
| status   | Descrição textual do status (Finished, DNF, etc.) | CHAR | 15       | NOT NULL              |

</div>
<p align="center"><b>Fonte: </b>Autoria de <a href="ttps://github.com/show-dawn"> Fernando Carrijo</a>. <a href="https://github.com/Julio1099"> Júlio Cezar </a>, <a href="https://github.com/kalebmacedo"> Kaleb Macedo</a> e <a href="https://github.com/bolzanMGB"> Othavio Bolzan</a></p>



## Histórico de versão

|    Data    | Versão |                 Descrição                 |                   Autor                   |                   Revisor                  |
|:----------:|:------:|:-----------------------------------------:|:-----------------------------------------:|:------------------------------------------:|
| 16/09/2025 | `1.0`  |        Adição do dicionário de dados      | [Júlio Cesar](https://github.com/Julio1099), [Fernando Gabriel](https://github.com/show-dawn) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 16/09/2025 | `1.1`  |        Alteração varchar e char do dicionário de dados | [Júlio Cesar](https://github.com/Julio1099), [Fernando Gabriel](https://github.com/show-dawn) | [Othavio Bolzan](https://github.com/bolzanMGB) |
| 08/10/2025 | `1.2`  |        Padronizando a documentação        | [Othavio Bolzan](https://github.com/bolzanMGB) | [Júlio Cesar](https://github.com/Julio1099) |

