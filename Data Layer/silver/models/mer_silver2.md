<center>

# Modelo Entidade-Relacionamento

</center>

---

<center>

# O que é?

</center>

> O modelo aqui apresentado é um **Esquema Estrela (Star Schema)**, uma abordagem do Modelo Entidade-Relacionamento otimizada para análise de dados (Data Warehouse). Ele organiza os dados em uma tabela de **Fatos** (contendo métricas quantitativas, como tempos de volta) e múltiplas tabelas de **Dimensão** (contendo atributos descritivos que dão contexto aos fatos).

---

# Entidades

- **Lap_Times** (Tabela Fato)
- **Races** (Dimensão)
- **Drivers** (Dimensão)
- **Circuits** (Dimensão)
- **Seasons** (Dimensão)
- **Constructors** (Dimensão)
- **Status** (Dimensão)
- **Results** (Tabela Ponte/Associativa)

---

# Atributos

* **Lap_Times**: `raceId (FK)`, `driverId (FK)`, lap, position, time, milliseconds
* **Races**: <ins>raceId (PK)</ins>, `year (FK)`, `circuitId (FK)`, round, name, date
* **Drivers**: <ins>driverId (PK)</ins>, driverRef, forename, surname, nationality
* **Circuits**: <ins>circuitId (PK)</ins>, name, location, country
* **Seasons**: <ins>year (PK)</ins>, url
* **Constructors**: <ins>constructorId (PK)</ins>, name, nationality
* **Status**: <ins>statusId (PK)</ins>, status
* **Results**: <ins>resultId (PK)</ins>, `raceId (FK)`, `driverId (FK)`, `constructorId (FK)`, `statusId (FK)`

---

# Relacionamentos

**Races _Contextualiza_ Lap_Times**

- Uma Corrida (`Races`) possui uma ou várias voltas (`Lap_Times`) (1,N)
- Uma Volta (`Lap_Times`) pertence a apenas uma única corrida (`Races`) (1,1)

**Drivers _Realiza_ Lap_Times**

- Um Piloto (`Drivers`) realiza uma ou várias voltas (`Lap_Times`) (1,N)
- Uma Volta (`Lap_Times`) é realizada por apenas um único piloto (`Drivers`) (1,1)

**Circuits _Sedia_ Races**

- Um Circuito (`Circuits`) sedia uma ou várias corridas (`Races`) (1,N)
- Uma Corrida (`Races`) ocorre em apenas um único circuito (`Circuits`) (1,1)

**Seasons _Agrupa_ Races**

- Uma Temporada (`Seasons`) agrupa uma ou várias corridas (`Races`) (1,N)
- Uma Corrida (`Races`) pertence a apenas uma única temporada (`Seasons`) (1,1)

**Results _Liga_ Dimensões**

*A tabela `Results` atua como uma ponte para conectar informações que não estão diretamente na tabela de fatos `Lap_Times`.*

**Races _Possui_ Results**

- Uma Corrida (`Races`) possui um ou vários resultados (`Results`) (1,N)
- Um Resultado (`Results`) pertence a apenas uma única corrida (`Races`) (1,1)

**Drivers _Possui_ Results**

- Um Piloto (`Drivers`) possui um ou vários resultados (`Results`) (1,N)
- Um Resultado (`Results`) pertence a apenas um único piloto (`Drivers`) (1,1)

**Constructors _Possui_ Results**

- Um Construtor (`Constructors`) possui um ou vários resultados (`Results`) (1,N)
- Um Resultado (`Results`) pertence a apenas um único construtor (`Constructors`) (1,1)

**Status _Descreve_ Results**

- Um Status (`Status`) descreve um ou vários resultados (`Results`) (1,N)
- Um Resultado (`Results`) é descrito por apenas um único status (`Status`) (1,1)