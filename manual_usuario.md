# Manual de usuario

## Inicio y perfiles

En el primer arranque se crea un administrador con credenciales elegidas por usted. Luego ingrese con usuario y contraseña. Un usuario inactivo no puede entrar. Use **Cerrar sesión** al terminar; la siguiente persona debe iniciar su propia sesión. En **Cambiar contraseña** ingrese la actual y repita la nueva.

| Perfil | Trabajo permitido |
| --- | --- |
| Administrador | Todas las funciones, ajustes, usuarios, mantenimiento de galpones, mínimo y backup. |
| Encargado de bodega | Entradas, inventario, lotes, vencimientos, alertas, historial y CSV de inventario/historial. |
| Operario de granja | Consulta de galpones y lotes; salidas de alimento; ingresos, muertes, ventas y traslados de animales. Sin ajustes, reportes ni CSV. |
| Supervisor de produccion | Inventario, galpones, lotes, alertas, historial, reportes y sus exportaciones. Sin escrituras operativas. |

El menú se adapta al perfil. El servidor también verifica permisos al abrir una dirección directamente.

## Usuarios y galpones

Administrador: en **Usuarios** cree nombre, usuario único, perfil y contraseña confirmada. En **Administrar** puede editar o desactivar; los registros históricos permanecen. **Restablecer** asigna una contraseña temporal elegida por el administrador; comuníquela por el procedimiento de la empresa y solicite cambiarla al ingresar. Cambiar perfil, estado o credenciales cierra las sesiones anteriores. Debe quedar al menos un administrador activo.

En **Galpones**, registre un nombre opcional. El código G001, G002… se asigna automáticamente y no se reutiliza tras una eliminación. Puede cambiar el nombre o desactivar/activar. Solo se elimina si no tiene movimientos de animales ni alimento; con historial se desactiva. Un galpón inactivo conserva su población e historial, pero no admite movimientos nuevos.

La tabla muestra población actual y bultos consumidos hoy, en la semana y en el mes calendario. La población total incluye los animales registrados en galpones inactivos para no ocultarlos.

## Animales

En **Animales** elija tipo, fecha, galpón y cantidad entera positiva. Para traslado, seleccione además otro galpón activo como destino. Muerte, venta y traslado no pueden superar la población disponible. El traslado confirma ambos efectos juntos o ninguno.

En un **ajuste**, exclusivo del administrador, la cantidad significa **nueva población total contada**, no cuántos animales sumar/restar. Puede ser cero. Use la fecha actual y una justificación obligatoria; confirme la acción. Se guardan anterior, nueva, diferencia, autor y hora.

Los movimientos ordinarios admiten fecha anterior o de hoy. Un registro tardío no puede dejar un saldo negativo en ninguna fecha ni alterar el valor anterior de un ajuste posterior. Si se rechaza, revise fechas y cantidades; nunca se reescribe el historial automáticamente.

## Alimento por lote

**Entradas:** ingrese fecha de recepción, proveedor, cantidad entera de bultos, vencimiento y observación opcional. Cada recepción crea un lote nuevo L00001, L00002… aunque el proveedor sea el mismo y hayan llegado camiones el mismo día. El vencimiento no puede ser anterior a la recepción.

**Salidas:** seleccione fecha, lote vigente con saldo y galpón activo. Indique bultos enteros positivos. La salida reduce el lote y aparece como consumo del galpón. Si utiliza dos lotes, registre dos salidas. Nunca se permite un lote ya vencido, ni usando una fecha anterior para evitar la restricción.

**Ajustar lote:** administrador elige aumentar/disminuir, cantidad y justificación (conteo, deterioro, vencimiento, etc.). La cantidad es la diferencia a aplicar, a diferencia del ajuste de animales. Se guardan fecha actual, hora, saldo anterior y resultante. No se permite saldo negativo.

## Inventario y alertas

- **Existencias físicas:** todos los bultos que siguen registrados, incluso vencidos.
- **Utilizables:** bultos de lotes que no han vencido.
- **Vencidos:** siguen físicamente en inventario hasta su baja mediante ajuste; no se pueden entregar.
- **Normal:** utilizable mayor que el mínimo. **Bajo:** mayor que cero y menor o igual al mínimo. **Agotado:** cero utilizable.

Un lote vence después de su fecha de vencimiento: ese mismo día todavía es utilizable. Se alerta **Próximo a vencer** entre hoy y 30 días inclusive. Se alerta **Vencido** si su fecha ya pasó. Solo aparecen alertas de lotes con saldo positivo. Consulte la lista ordenada por vencimiento en **Lotes** y **Vencimientos y alertas**.

En **Configuración**, el administrador define un mínimo global entero no negativo.

## Historial, reportes y CSV

**Historial** filtra por fecha operativa inicial/final, tipo, galpón y lote; los extremos se incluyen. Distingue la fecha de la operación de la hora real en que se registró. Los movimientos confirmados no se editan ni eliminan.

En **Reportes** elija diario, semanal o mensual, una fecha dentro del período y un galpón o todos. Semana significa lunes a domingo; mes significa calendario. El reporte incluye solo salidas de alimento y conserva galpones inactivos.

El indicador aproximado divide los bultos del período entre los animales **actuales**. Se presenta con cuatro decimales; con cero animales muestra «No calculable». No es consumo individual medido ni reconstrucción de población histórica.

**Exportar esta consulta** conserva sus filtros. Los CSV se descargan por el navegador, en UTF-8; seleccione `exports/` si quiere guardarlos junto al programa. La exportación no modifica la base. Textos que podrían ejecutarse como fórmulas en una hoja de cálculo reciben una comilla inicial de protección.

## Respaldo

Administrador: entre en **Copia de seguridad** y pulse **Crear copia de seguridad**. Espere el mensaje de copia creada y verificada y compruebe el nombre en la tabla. La copia queda en `backups/`. Para recuperar datos siga `restauracion_backup.md` con la aplicación detenida.
