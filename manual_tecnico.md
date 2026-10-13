# Manual técnico

## Composición

`app.create_app(config)` configura rutas persistentes, crea motor/esquema y compone casos de uso con la fábrica de unidad de trabajo, hasher, generador CSV y adaptador de backup. Los blueprints solo traducen HTTP a parámetros de casos de uso y presentan sus resultados.

El dominio usa Python estándar: Actor, códigos visibles, permisos, errores, cálculos, validaciones y contratos Protocol. Las entidades persistentes se representan mediante modelos SQLAlchemy únicamente en infraestructura; los repositorios retornan diccionarios de valores, nunca objetos ORM hacia presentación. Se utiliza CsvDocument como DTO para exportaciones. No se replica cada modelo como una clase vacía en todas las capas.

## Transacciones e historial

`SqlAlchemyUnitOfWork(write=True)` inicia BEGIN IMMEDIATE antes de leer saldos; evita que dos escrituras validen sobre el mismo saldo antiguo. Inserta movimientos, valida secuencias y hace commit solo al terminar sin errores. Cualquier excepción provoca rollback y cierre de sesión.

Una recepción inserta lote y entrada juntos. Una salida inserta efecto negativo y valida saldo histórico. Un traslado es un movimiento con origen y destino, interpretado como dos efectos; valida ambas secuencias dentro de la misma transacción. Ajustes guardan anterior, nuevo y diferencia. Las lecturas agregan cantidades con GROUP BY; no hay totales redundantes persistidos.

Orden histórico: fecha operativa e ID ascendente para registros del mismo día. Un movimiento retroactivo se rechaza si deja saldo negativo o cambia la base de un ajuste ya registrado. No se recalculan ni editan silenciosamente ajustes posteriores.

## Persistencia e inicialización

Esquema centralizado en infrastructure/database/models.py y connection.py, con triggers en integrity.py. La inicialización es idempotente y crea cuatro perfiles y un singleton de configuración. El registro de administrador está en el caso de uso Auth.setup. Las rutas no crean tablas.

Esta primera versión utiliza creación reproducible de esquema, sin Alembic: no hay migraciones de datos previos de otra versión. `create_all` no migra columnas existentes. Si se cambia el esquema en una versión futura, deberá desarrollarse y probarse una migración explícita con backup previo; no se deben borrar archivos de datos para actualizar.

Instantes de auditoría: UTC sin zona almacenado, convertido a la zona local de Windows al mostrar/exportar. Fechas operativas: DATE local. Mantenga fecha y zona del computador correctamente configuradas (en el entorno revisado: Colombia, UTC−05:00).

## Añadir o mantener un módulo

1. Revisar alcance y trazabilidad.
2. Definir la regla pura y contratos en dominio cuando sea necesario.
3. Implementar el caso de uso y su autorización/transacción.
4. Extender el repositorio sin filtrar ORM hacia las rutas.
5. Añadir blueprint, formulario y presentación con CSRF y navegación por permiso.
6. Probar casos válidos, límites, denegaciones y rollback; actualizar documentación.

## Pruebas y rendimiento

`python -m pytest -q` ejecuta pruebas sobre archivos SQLite temporales bajo `.test-tmp`. Cada fixture usa una fábrica aislada y fecha controlada. Hay pruebas de aplicación y cliente Flask, restricciones reales de SQLite, concurrencia, copia/restauración y rendimiento con 10.000 movimientos. Ver informe_pruebas.md para los resultados registrados y la revisión visual.

La revisión visual usa `python -m tests.browser_server` (puerto 5010) con datos ficticios en `.cache/browser-review`. Nunca apunta a la base principal.

## Empaquetado

`scripts/build_windows.py` ejecuta PyInstaller en modo carpeta, incluye plantillas y estáticos, copia documentación y produce un ZIP portable. No incluye bases, usuarios, backups ni secretos de desarrollo. La caché, build y dist se mantienen bajo la raíz.

El modo carpeta evita extracción temporal de ejecutables en ubicaciones externas. La ruta de datos se calcula desde el ejecutable. El script de smoke test copia la distribución a `.cache/package-smoke`, ejecuta el binario con PATH reducido, crea datos ficticios por HTTP, reinicia y comprueba persistencia; no modifica la distribución final.
