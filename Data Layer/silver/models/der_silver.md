# DER — Camada Silver (Template)

- **Chaves**:
  - `DIM_TEMPO(id_tempo)`
  - `DIM_ENTIDADE(id_entidade)`
  - `FATO_MEDIDA(id_fato)`
- **Relacionamentos**:
  - `FATO_MEDIDA.id_tempo → DIM_TEMPO.id_tempo`
  - `FATO_MEDIDA.id_entidade → DIM_ENTIDADE.id_entidade`

> Ajuste tipos, cardinalidades e nomenclaturas para refletir o seu dataset.
