<center>

# Modelo Entidade-Relacionamento

</center>

---

<center>

# O que é?

</center>

> O modelo Entidade-Relacionamento tem como principal função descrever itens, em outras palavras entidades, que são utilizadas para representar participantes de um cenário em um problema que deseja ser resolvido mediante utilização de um banco de dados. Neste caso, o modelo representa o domínio de corridas de Fórmula 1, com foco nas voltas realizadas pelos pilotos.

---

# Entidades

- **Race** (Corrida)
- **Driver** (Piloto)
- **Constructor** (Equipe)
- **Status** (Status)
- **Lap_Times_Fact** (Tempos de Volta - Tabela Fato)
- **Pit_Stop** (Parada nos Boxes)
- **Result** (Resultado)

---

# Atributos

- **Race**: <ins>id_corrida</ins>, ano, rodada, nome_corrida
- **Driver**: <ins>id_piloto</ins>, primeiro_nome_piloto, sobrenome_piloto
- **Constructor**: <ins>id_equipe</ins>, nome_equipe
- **Status**: <ins>id_status</ins>, descricao_status
- **Lap_Times_Fact**: <span style="text-decoration: underline; text-decoration-style: dotted;">id_corrida</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id_piloto</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">volta</span>, posicao_na_volta, tempo_volta_ms
- **Pit_Stop**: <span style="text-decoration: underline; text-decoration-style: dotted;">id_corrida</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id_piloto</span>, duracao_parada_seg
- **Result**: <span style="text-decoration: underline; text-decoration-style: dotted;">id_corrida</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id_piloto</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id_equipe</span>, <span style="text-decoration: underline; text-decoration-style: dotted;">id_status</span>

---

# Relacionamentos

**Race _Possui_ Lap_Times_Fact**

- Race possui nenhuma ou várias voltas registradas (0,N)
- Lap_Times_Fact pertence a apenas uma única corrida (1,1)

**Driver _Realiza_ Lap_Times_Fact**

- Driver realiza nenhuma ou várias voltas (0,N)
- Lap_Times_Fact é realizada por apenas um único piloto (1,1)

**Race _Possui_ Pit_Stop**

- Race possui nenhuma ou várias paradas nos boxes (0,N)
- Pit_Stop ocorre em apenas uma única corrida (1,1)

**Driver _Realiza_ Pit_Stop**

- Driver realiza nenhuma ou várias paradas nos boxes (0,N)
- Pit_Stop é realizada por apenas um único piloto (1,1)

**Race _Possui_ Result**

- Race possui um ou vários resultados (1,N)
- Result pertence a apenas uma única corrida (1,1)

**Driver _Participa_ Result**

- Driver participa de nenhum ou vários resultados (0,N)
- Result pertence a apenas um único piloto (1,1)

**Constructor _Possui_ Result**

- Constructor possui nenhum ou vários resultados (0,N)
- Result pertence a apenas uma única equipe (1,1)

**Status _Classifica_ Result**

- Status classifica nenhum ou vários resultados (0,N)
- Result possui apenas um único status (1,1)

---

<center>

# Diagrama Conceitual

</center>

```
                    ┌─────────────┐
                    │    Race     │
                    │ (Corrida)   │
                    └──────┬──────┘
                           │
            ┌──────────────┼──────────────┐
            │              │              │
            │(1,1)    (1,1)│         (1,1)│
            │              │              │
     ┌──────▼──────┐(0,N)  │(0,N)  ┌──────▼──────┐
     │ Lap_Times   │       │       │  Pit_Stop   │
     │    Fact     │       │       │             │
     │  (FATO)     │       │       └──────┬──────┘
     └──────┬──────┘       │              │
            │              │              │(1,1)
       (1,1)│              │(1,N)         │
            │              │              │
            │         ┌────▼────┐    (0,N)│
            │         │ Result  │         │
            │         │         │         │
            │         └────┬────┘         │
            │              │              │
            │         (1,1)│              │
            │              │              │
            │    ┌─────────┼─────────┐    │
            │    │         │         │    │
       (0,N)│    │(1,1)    │(0,N)    │    │
            │    │         │         │    │
     ┌──────▼────▼───┐     │    ┌────▼────▼───────┐
     │    Driver     │     │    │  Constructor    │
     │   (Piloto)    │     │    │    (Equipe)     │
     └───────────────┘     │    └─────────────────┘
                           │
                      (0,N)│
                           │
                    ┌──────▼──────┐
                    │   Status    │
                    │             │
                    └─────────────┘
```

---

<center>

# Observações

</center>

- **Lap_Times_Fact** é a tabela fato central do modelo, registrando cada volta realizada por cada piloto em cada corrida
- As chaves primárias são representadas com <ins>sublinhado simples</ins>
- As chaves estrangeiras são representadas com <span style="text-decoration: underline; text-decoration-style: dotted;">sublinhado pontilhado</span>
- As chaves candidatas são representadas com <span style="text-decoration: underline; text-decoration-style: double;">sublinhado duplo</span>
- A cardinalidade é representada no formato (mínimo, máximo)

---

<center>

# Histórico de versão

</center>

<div style="margin: 0 auto; width: fit-content;">

|    Data    | Versão |               Descrição               |
|:----------:|:------:|:-------------------------------------:|
| 07/10/2025 | `1.0`  | Criação do MER para Fórmula 1         |

</div>