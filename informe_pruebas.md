# Informe de verificación

## Entorno y resultado automatizado

Windows 11, Python 3.12.4, dependencias fijadas en requirements-lock.txt. Última suite completa ejecutada el 2026-09-15:

```text
.venv/Scripts/python.exe -m pytest -q -s
70 passed in 44.48s
```

`pip check`: No broken requirements found.

Las pruebas usan archivos SQLite reales en `.test-tmp/`, con fecha controlada y sin datos de producción. Cubren autenticación, hash, CSRF, permisos de todos los GET/POST sensibles, usuarios, galpones, movimientos, saldos, fechas, reportes, CSV, integridad, concurrencia, backup/restauración, reinicio y funcionamiento sin conexiones externas.

## Rendimiento observado

Medición con 10.000 movimientos, fuera del tiempo de preparación de datos:

| Operación | Medido | Límite requerido |
| --- | --- | --- |
| Reporte mensual servido por cliente Flask | 0,0697 s | 5 s |
| Salida con comprobación del historial | 0,2986 s | 3 s |
| Consulta de inventario | 0,0269 s | 3 s |

Son mediciones de este equipo; no una garantía para hardware distinto. El test incorpora aserciones sobre los límites y sobre los valores del reporte.

## Fallos detectados y corregidos

- Campos numéricos vacíos interpretados como cero: ahora se rechazan, incluso cuando cero es un valor válido.
- Manejo de un Host no autorizado: se devuelve una respuesta 400 clara sin intentar construir URLs sobre una petición inválida.
- Dos respaldos rápidos con el mismo timestamp del reloj de Windows: nombres con UUID, probados con reloj fijo. Se conservan ambas copias.

Se verificó rollback tras fallos inducidos en recepción, traslado y ajuste; dos salidas concurrentes no pueden consumir el mismo saldo. Los triggers impiden actualizar o borrar movimientos y auditoría. CSV conserva el archivo SQLite idéntico antes/después de exportar.

## Revisión de navegador

El 2026-09-14 se ejecutó un servidor aislado en el puerto 5010 con datos ficticios bajo `.cache/browser-review`. Se revisó visualmente el dashboard y se recorrieron:

- Login y menú del administrador.
- Recepción de 50 bultos, nuevo lote y aumento inmediato de existencias.
- Salida de 5 bultos: lote de 68 a 63; el lote vencido no aparecía entre opciones de salida.
- Reporte de 17 bultos e indicador 0,0142 para 1.200 animales; filtro semanal y galpón único.
- Creación desde la interfaz de una copia con mensaje de verificación y archivo visible.

Se utilizó el navegador integrado de Codex. Chrome no estaba conectado a las herramientas; no se declara una prueba directa en Chrome/Edge ni en Windows 10. Las pruebas HTTP y la revisión visual complementan, pero no sustituyen, la aceptación del usuario en su navegador habitual.

## Distribución Windows

El resultado del ensayo del ejecutable se registra en `smoke_windows.json` al finalizar `scripts/smoke_windows.py`. Este ensayo utiliza una copia aislada de la distribución, PATH sin Python, arranque real por HTTP, escrituras, exportación, respaldo y reinicio para verificar persistencia. La distribución entregada queda sin usuarios ni datos ficticios.

### Resultado del ejecutable — 2026-09-15

**Aprobado**: scripts/smoke_windows.py terminó con código 0. Se comprobó arranque real con PATH limitado a System32, creación inicial, login, galpón, entrada, salida, inventario, reportes, CSV, backup, CSS y persistencia tras detener y volver a iniciar el proceso. Resultado estructurado en smoke_windows.json. El ZIP final y dist/Avicola se entregan sin archivos de datos ni secretos.
