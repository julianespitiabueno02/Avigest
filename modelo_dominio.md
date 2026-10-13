# Modelo de dominio definitivo

## Entidades y relaciones

| Concepto | Atributos y responsabilidad |
| --- | --- |
| Perfil | ID y nombre; catálogo de cuatro perfiles exactos, permisos fijos. Un perfil tiene muchos usuarios. |
| Usuario | ID, nombre, username único normalizado a minúsculas, hash, perfil, estado y versión de sesión. Autor de movimientos y auditoría. |
| Galpón | ID AUTOINCREMENT, código visible G001 derivado del ID, nombre opcional, registro y estado. Su población se obtiene de movimientos. |
| MovimientoAnimal | ID, tipo, origen, destino opcional, cantidad, diferencia, anterior/nuevo opcionales, fecha operativa, instante de registro, autor y observación. |
| LoteAlimento | ID AUTOINCREMENT, código visible L00001, proveedor, recepción y vencimiento. Cada recepción es un lote independiente; no agrupa camiones. |
| MovimientoAlimento | ID, entrada/salida/ajuste, lote, galpón opcional, cantidad, diferencia, anterior/nuevo opcionales, fecha operativa, registro, autor y observación/justificación. |
| Configuración | Singleton con nivel mínimo entero no negativo. |
| EventoAuditoría | Autor, acción, objeto afectado, detalle no sensible e instante real; registra cambios administrativos. |

Galpón tiene muchos movimientos animales como origen y/o destino, y muchas salidas de alimento. Lote tiene muchos movimientos de alimento y una única entrada inicial mediante el caso de uso. Ninguna entidad referenciada por historial se borra en cascada.

## Invariantes

- Galpones inactivos no reciben nuevos movimientos operativos. Sin historial pueden eliminarse; con historial se desactivan. La eliminación no reutiliza códigos.
- Cantidades ordinarias enteras positivas. Muerte/venta/traslado no superan población; traslado exige dos galpones distintos activos y confirma ambos efectos juntos.
- Ajuste de animales: la entrada es nueva población no negativa; registra anterior/nueva/diferencia y justificación. Solo administrador.
- Entrada de alimento: cantidad positiva, proveedor y vencimiento requeridos, vencimiento >= recepción; lote y movimiento se crean atómicamente.
- Salida de alimento: galpón activo, lote vigente con saldo suficiente; una salida por lote. No se permiten bultos fraccionarios ni selección automática FIFO/FEFO.
- Ajuste de alimento: diferencia positiva a aumentar/disminuir, justificación, anterior/resultante y autor; no negativo. Solo administrador.
- Historial confirmado es inmutable. Fecha operativa pasada o actual; fecha/hora real UTC separada. El orden para validar registros atrasados es fecha/ID. Un ajuste posterior no puede alterar silenciosamente su saldo anterior.
- Inventario físico = suma de saldos; utilizable = saldos de lotes con vencimiento >= hoy; vencido = diferencia. El mínimo utiliza exclusivamente utilizable. Los vencidos se retiran mediante ajuste.
- Estado Agotado si utilizable=0; Bajo si 0<utilizable<=mínimo; Normal si supera mínimo.
- Próximo a vencer: hoy hasta hoy+30 inclusive. Vencido: fecha anterior a hoy. Solo se alertan saldos >0.
- Consumo: únicamente salidas confirmadas en período inclusivo. Diario, semana lunes–domingo o mes calendario. Indicador aproximado = consumo/población actual; cuatro decimales o No calculable si cero.

La representación de reglas no depende de la persistencia. Actor es una entidad inmutable de contexto de autorización; los registros de negocio son valores simples retornados por contratos de repositorios. Los modelos ORM residen únicamente en infraestructura.
