### Diagrama Lógico de Dados (DLD) — Fórmula 1

## 1. Introdução

O Diagrama Lógico de Dados (DLD) traduz o Modelo Entidade-Relacionamento para uma representação relacional pronta para implementação. Este DLD cobre o domínio das corridas de Fórmula 1, contemplando corridas, pilotos, equipes, tempos de volta (tabela fato), paradas em boxes e resultados individuais dos pilotos.

---

```sql
BEGIN TRANSACTION;

-- TABELA: Race
CREATE TABLE Race (
    id_corrida INT PRIMARY KEY,
    ano SMALLINT NOT NULL CHECK (ano >= 1950),
    rodada SMALLINT NOT NULL CHECK (rodada > 0),
    nome_corrida VARCHAR(100) NOT NULL
);

-- TABELA: Driver
CREATE TABLE Driver (
    id_piloto INT PRIMARY KEY,
    primeiro_nome_piloto VARCHAR(50) NOT NULL,
    sobrenome_piloto VARCHAR(50) NOT NULL,
    CONSTRAINT uq_driver_nome UNIQUE (primeiro_nome_piloto, sobrenome_piloto)
);

-- TABELA: Constructor
CREATE TABLE Constructor (
    id_equipe INT PRIMARY KEY,
    nome_equipe VARCHAR(100) NOT NULL UNIQUE
);

-- TABELA: Status
CREATE TABLE Status (
    id_status INT PRIMARY KEY,
    descricao_status VARCHAR(50) NOT NULL UNIQUE
);

-- TABELA: Lap_Times_Fact
CREATE TABLE Lap_Times_Fact (
    id_corrida INT NOT NULL,
    id_piloto INT NOT NULL,
    volta INT NOT NULL CHECK (volta > 0),
    posicao_na_volta SMALLINT CHECK (posicao_na_volta >= 1),
    tempo_volta_ms INT CHECK (tempo_volta_ms > 0),
    PRIMARY KEY (id_corrida, id_piloto, volta),
    FOREIGN KEY (id_corrida) REFERENCES Race(id_corrida)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_piloto) REFERENCES Driver(id_piloto)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABELA: Pit_Stop
CREATE TABLE Pit_Stop (
    id_corrida INT NOT NULL,
    id_piloto INT NOT NULL,
    numero_parada SMALLINT NOT NULL CHECK (numero_parada > 0),
    duracao_parada_seg DECIMAL(6,3) CHECK (duracao_parada_seg > 0),
    PRIMARY KEY (id_corrida, id_piloto, numero_parada),
    FOREIGN KEY (id_corrida) REFERENCES Race(id_corrida)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_piloto) REFERENCES Driver(id_piloto)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABELA: Result
CREATE TABLE Result (
    id_corrida INT NOT NULL,
    id_piloto INT NOT NULL,
    id_equipe INT NOT NULL,
    id_status INT NOT NULL,
    PRIMARY KEY (id_corrida, id_piloto),
    FOREIGN KEY (id_corrida) REFERENCES Race(id_corrida)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_piloto) REFERENCES Driver(id_piloto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_equipe) REFERENCES Constructor(id_equipe)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_status) REFERENCES Status(id_status)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMIT;

```
---

## Histórico de versão

</center>

<div style="margin: 0 auto; width: fit-content;">


|    Data    | Versão |                 Descrição                 | Autores                                                                                                                                                                                                 |
|:----------:|:------:|:-----------------------------------------:| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 09/10/2025 | `1.0`  |        Criação do MER para Fórmula 1          | [Fernando Gabriel](https://github.com/show-dawn)
| 09/10/2025 | `1.1`  |      fix da documentação         | [Fernando Gabriel](https://github.com/show-dawn)