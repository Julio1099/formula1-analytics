#  Diagrama Lógico de Dados (DDL)

## 1. Introdução

**DDL (Data Definition Language)** é um subconjunto da linguagem **SQL (Structured Query Language)** usado para **definir e gerenciar a estrutura** de bancos de dados relacionais.
Com comandos DDL, é possível **criar, alterar e excluir** objetos no banco, como tabelas, índices, e restrições.

Principais comandos:

* `CREATE` — cria objetos no banco de dados.
* `ALTER` — modifica objetos existentes.
* `DROP` — remove objetos do banco de dados.


## 2. Estrutura do Banco de Dados

Abaixo estão as definições das tabelas criadas para o nosso **projeto Fórmula 1 Analytics**, com suas chaves primárias, estrangeiras e restrições de integridade.


### 2.1 Tabela `Race`
Armazena as informações das corridas de Fórmula 1.
```sql
CREATE TABLE Race (
    id_corrida INT PRIMARY KEY,
    ano SMALLINT NOT NULL CHECK (ano >= 1950),
    rodada SMALLINT NOT NULL CHECK (rodada > 0),
    nome_corrida VARCHAR(100) NOT NULL
);
```


### 2.2 Tabela `Driver`
Armazena os dados básicos dos pilotos.
```sql
CREATE TABLE Driver (
    id_piloto INT PRIMARY KEY,
    primeiro_nome_piloto VARCHAR(50) NOT NULL,
    sobrenome_piloto VARCHAR(50) NOT NULL,
    CONSTRAINT uq_driver_nome UNIQUE (primeiro_nome_piloto, sobrenome_piloto)
);
```


### 2.3 Tabela `Constructor`
Representa as equipes (construtores) que participam das corridas.
```sql
CREATE TABLE Constructor (
    id_equipe INT PRIMARY KEY,
    nome_equipe VARCHAR(100) NOT NULL UNIQUE
);
```



### 2.4 Tabela `Status`
Define o status final de um piloto em uma corrida (ex.: “Concluiu”, “Abandonou”, “Acidente”).

```sql
CREATE TABLE Status (
    id_status INT PRIMARY KEY,
    descricao_status VARCHAR(50) NOT NULL UNIQUE
);

```

### 2.5 Tabela `Lap_Times_Fact`
Armazena o tempo de cada volta dos pilotos em cada corrida.
```sql
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
```

### 2.6 Tabela `Pit_Stop`
Registra as paradas nos boxes realizadas por cada piloto durante uma corrida.
```sql
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
```



### 2.7 Tabela `Result`

Armazena o resultado final dos pilotos em cada corrida.

```sql
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
```


<center>

## Histórico de versão

</center>

<div style="margin: 0 auto; width: fit-content;">



|    Data    | Versão |                 Descrição                 | Autores                                                                                                                                                                                                 |
|:----------:|:------:|:-----------------------------------------:| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 09/10/2025 | `1.0`  |        Criação do ddl para Fórmula 1          | [Fernando Gabriel](https://github.com/show-dawn)
| 09/10/2025 | `1.1`  |      Fix da documentação           | [Fernando Gabriel](https://github.com/show-dawn)
| 09/10/2025 | `1.2`  |      Dix historico de versão       | [Fernando Gabriel](https://github.com/show-dawn)
| 09/10/2025 | `1.3`  |      Padronização da documentação  | [Fernando Gabriel](https://github.com/show-dawn)