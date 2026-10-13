# Base de datos definitiva

SQLite físico: `database/avicola.db`. Esquema SQL de referencia en `esquema.sql`; la fuente ejecutable es `app/infrastructure/database/models.py`. No se guardan saldos o poblaciones redundantes.

## configuration

| Columna | Tipo | Nulo | Clave / valor por defecto |
| --- | --- | --- | --- |
| id | INTEGER | No | PK |
| minimum | INTEGER | No | default 0 |

- CHECK: `id = 1`.
- CHECK: `minimum >= 0`.

## feed_lots

| Columna | Tipo | Nulo | Clave / valor por defecto |
| --- | --- | --- | --- |
| id | INTEGER | No | PK |
| supplier | VARCHAR(200) | No |  |
| received_on | DATE | No |  |
| expires_on | DATE | No |  |

- CHECK: `expires_on >= received_on`.
- Índice `ix_feed_lots_expires_on`: expires_on.

## pens

| Columna | Tipo | Nulo | Clave / valor por defecto |
| --- | --- | --- | --- |
| id | INTEGER | No | PK |
| name | VARCHAR(120) | No | default  |
| registered_at | DATETIME | No | default utcnow |
| active | BOOLEAN | No | default True |


## profiles

| Columna | Tipo | Nulo | Clave / valor por defecto |
| --- | --- | --- | --- |
| id | INTEGER | No | PK |
| name | VARCHAR(60) | No | UNIQUE |


## users

| Columna | Tipo | Nulo | Clave / valor por defecto |
| --- | --- | --- | --- |
| id | INTEGER | No | PK |
| name | VARCHAR(120) | No |  |
| username | VARCHAR(80) | No | UNIQUE |
| password_hash | VARCHAR(255) | No |  |
| role_id | INTEGER | No | FK → profiles.id (RESTRICT) |
| active | BOOLEAN | No | default True |
| session_version | INTEGER | No | default 1 |


## animal_movements

| Columna | Tipo | Nulo | Clave / valor por defecto |
| --- | --- | --- | --- |
| id | INTEGER | No | PK |
| kind | VARCHAR(20) | No |  |
| pen_id | INTEGER | No | FK → pens.id (RESTRICT) |
| destination_id | INTEGER | Sí | FK → pens.id (RESTRICT) |
| quantity | INTEGER | No |  |
| delta | INTEGER | No |  |
| before | INTEGER | Sí |  |
| after | INTEGER | Sí |  |
| occurred_on | DATE | No |  |
| recorded_at | DATETIME | No | default utcnow |
| user_id | INTEGER | No | FK → users.id (RESTRICT) |
| note | VARCHAR(500) | No | default  |

- CHECK: `kind IN ('ingreso','muerte','venta','traslado','ajuste')`.
- CHECK: `quantity >= 0 AND (kind = 'ajuste' OR quantity > 0)`.
- CHECK: `(kind = 'traslado' AND destination_id IS NOT NULL AND destination_id != pen_id) OR (kind != 'traslado' AND destination_id IS NULL)`.
- CHECK: `kind != 'ajuste' OR (before IS NOT NULL AND after IS NOT NULL AND before >= 0 AND after >= 0 AND length(trim(note)) > 0 AND delta = after - before)`.
- CHECK: `kind = 'ajuste' OR (kind IN ('ingreso') AND delta = quantity) OR (kind IN ('muerte','venta','traslado') AND delta = -quantity)`.
- Índice `ix_animal_pen_date`: pen_id, occurred_on.
- Índice `ix_animal_destination_date`: destination_id, occurred_on.

## audit_events

| Columna | Tipo | Nulo | Clave / valor por defecto |
| --- | --- | --- | --- |
| id | INTEGER | No | PK |
| user_id | INTEGER | No | FK → users.id (RESTRICT) |
| action | VARCHAR(80) | No |  |
| target | VARCHAR(100) | No |  |
| detail | VARCHAR(500) | No | default  |
| recorded_at | DATETIME | No | default utcnow |


## feed_movements

| Columna | Tipo | Nulo | Clave / valor por defecto |
| --- | --- | --- | --- |
| id | INTEGER | No | PK |
| kind | VARCHAR(20) | No |  |
| lot_id | INTEGER | No | FK → feed_lots.id (RESTRICT) |
| pen_id | INTEGER | Sí | FK → pens.id (RESTRICT) |
| quantity | INTEGER | No |  |
| delta | INTEGER | No |  |
| before | INTEGER | Sí |  |
| after | INTEGER | Sí |  |
| occurred_on | DATE | No |  |
| recorded_at | DATETIME | No | default utcnow |
| user_id | INTEGER | No | FK → users.id (RESTRICT) |
| note | VARCHAR(500) | No | default  |

- CHECK: `kind != 'ajuste' OR (before IS NOT NULL AND after IS NOT NULL AND before >= 0 AND after >= 0 AND length(trim(note)) > 0 AND delta = after - before)`.
- CHECK: `(kind = 'entrada' AND delta = quantity) OR (kind = 'salida' AND delta = -quantity) OR (kind = 'ajuste' AND (delta = quantity OR delta = -quantity))`.
- CHECK: `kind IN ('entrada','salida','ajuste')`.
- CHECK: `quantity > 0`.
- CHECK: `(kind = 'salida' AND pen_id IS NOT NULL) OR (kind != 'salida' AND pen_id IS NULL)`.
- Índice `ix_feed_lot_date`: lot_id, occurred_on.
- Índice `ix_feed_date`: occurred_on.
- Índice `ix_feed_pen_date`: pen_id, occurred_on.

## Integridad y normalización

- Perfiles 1:N usuarios; usuarios 1:N movimientos de ambas clases y eventos de auditoría.
- Galpones 1:N movimientos de animales (origen/destino) y 1:N salidas de alimento. Lotes 1:N movimientos de alimento.
- Cada llegada genera lote nuevo y una entrada inicial en la misma transacción. Código de lote y galpón se derivan de IDs AUTOINCREMENT, sin COUNT ni columna duplicada.
- Configuración tiene exclusivamente ID=1. Los nombres de proveedor son atributos de la recepción, sin módulo independiente.
- Claves foráneas activas en todas las conexiones. No hay borrado en cascada. Los movimientos y la auditoría tienen triggers contra UPDATE y DELETE.
- Saldos y población son agregaciones de diferencias del historial; los traslados agregan su cantidad al destino. Anterior/resultante de ajustes se conserva deliberadamente como evidencia.
- SQLAlchemy utiliza parámetros enlazados. La unidad de trabajo inicia BEGIN IMMEDIATE para serializar comprobación/escritura y hace rollback ante fallos.
- Fechas operativas DATE; instantes de registro UTC en DATETIME sin zona, convertidos a hora local al mostrar. Los movimientos retroactivos se validan por fecha/ID.
- Se utiliza journal normal SQLite; backup consistente mediante API SQLite. No hay migración automática de columnas: cambios futuros requerirán migración explícita y copia previa.
