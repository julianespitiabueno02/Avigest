# Decisiones técnicas y aclaraciones aprobadas

## Decisiones menores propuestas

- Usar directamente la raíz asignada; todas las escrituras, entornos, caches, datos y entregables permanecerán dentro de ella.
- Contratos de repositorios y unidad de trabajo en dominio; adaptadores SQLAlchemy en infraestructura.
- Código de galpón calculado desde ID AUTOINCREMENT; evitar duplicar el código en almacenamiento.
- Saldos y población calculados desde historial; verificar rendimiento con 10.000 movimientos antes de considerar cachés persistentes.
- CSRF, hash Werkzeug y secreto local persistente; sin credenciales reales incorporadas.
- Sin dependencias de frontend externas ni servicios remotos.

## Preguntas iniciales (registro histórico, resueltas abajo)

1. **Saldo vencido:** RF-15 habla de saldos disponibles, RF-14 impide usar alimento vencido y RF-16 permite descontarlo por ajuste. ¿El total y la alerta de mínimo incluyen existencias vencidas hasta su baja, o solo alimento utilizable? Propuesta: mostrar total físico y saldo utilizable por separado; calcular mínimo sobre utilizable. Esto requiere aprobación por afectar la interpretación de inventario.
2. **Identidad de lote y recepciones:** ¿Puede recibirse varias veces el mismo lote comercial? ¿Su referencia es globalmente única, única por proveedor o puede repetirse con vencimientos distintos? Esto define la normalización y restricciones de la base.
3. **Fechas de movimientos y reportes:** ¿Se permiten registros retroactivos y futuros? Si se admiten retroactivos, ¿se exige no dejar saldos negativos en ningún punto del historial o basta el saldo actual? Propuesta para períodos: semana calendario lunes–domingo y mes calendario; confirmar frente a ventanas móviles de 7/30 días.
4. **Permisos operativos:** propuesta: operario consulta galpones/población y lotes con sus saldos/vencimientos para registrar salidas, pero no historial global, reportes ni CSV. Bodega exporta inventario e historial; supervisor exporta también consumo. Administración gestiona cualquier cambio del galpón. Confirmar, porque «consultas operativas» y RF-25 no asignan permisos concretos.

La implementación se detuvo en este punto del diseño inicial para consultar al usuario. Todas estas preguntas quedaron resueltas en la sección siguiente.

## Resoluciones aprobadas por el usuario (2026-09-08)

Las preguntas anteriores quedan resueltas por las respuestas del usuario y su confirmación «de acuerdo con todo»:

- Cada recepción crea un lote nuevo con código interno visible automático L00001, L00002, etc.; no se acumulan recepciones en un lote previo. El proveedor es texto de la recepción.
- Se muestran existencias físicas, utilizables y vencidas por separado. El mínimo y el estado se calculan sobre utilizables. Los vencidos permanecen físicamente hasta descontarlos con ajuste.
- Se admiten fechas pasadas y del día actual, nunca futuras para movimientos. La fecha de vencimiento sí puede ser futura. Se registra además la fecha/hora real de registro.
- Semanas calendario lunes–domingo y meses calendario. Para evitar saldos negativos, las inserciones retroactivas validan toda la secuencia por fecha e ID. Tampoco pueden cambiar el saldo anterior registrado por un ajuste posterior: se rechazan con explicación en vez de reescribir auditoría.
- Operario: galpones, animales, salidas y consulta de lotes para operar; sin reportes ni CSV. Bodega: exportación de inventario e historial. Supervisor: también consumo. Administración: mantenimiento completo de galpones.

## Precisiones de implementación

- Ajustes físicos se registran al día actual, pues corresponden a un conteo actual, con confirmación y justificación. Los movimientos ordinarios admiten registro tardío.
- Una salida solo permite un lote vigente tanto en la fecha operativa como en el día del registro; nunca se habilita el uso de un lote ya vencido por cambiar la fecha.
- Un ajuste queda como diferencia inmutable. El usuario visualiza anterior, resultante, fecha y autor.
- Se agrega audit_events para cambios administrativos sin contraseñas ni hashes en auditoría. Las tablas de movimientos siguen siendo la evidencia operativa.
- Los archivos Python de dominio agrupan entidades, reglas, permisos y contratos por responsabilidad. Se evita crear subcarpetas vacías para cada clase.

## Cierre de integridad (2026-09-15)

Los respaldos conservan fecha/hora legible y agregan un UUID para distinguir incluso dos copias solicitadas durante el mismo instante del reloj de Windows. Se valida con reloj fijo en test_backup_names_unique_with_identical_clock; ninguna copia previa se reemplaza. Los triggers inmutables protegen movimientos y auditoría contra modificaciones accidentales.
