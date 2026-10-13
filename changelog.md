# Historial de cambios

## 2026-09-08 — Preparación y diseño inicial

- Leído completamente el maestro e inspeccionada la carpeta, que solo contenía dicho archivo.
- Documentadas estructura propuesta, arquitectura por capas, dominio y esquema preliminar con restricciones y cardinalidades.
- Creada matriz inicial de todos los RF-01–26 y RNF-01–16 con verificaciones previstas.
- Registradas preguntas sobre inventario vencido, identidad de lotes, fechas y permisos antes de implementar.
- No se ha creado código ni base de datos. No hay pruebas ejecutables todavía y no se declara ningún requisito implementado.

## 2026-09-08 — Inicialización, autenticación y usuarios

- Inicialización SQLite reproducible y validaciones puras: 7 pruebas aprobadas.
- Autenticación, sesión, CSRF, hash y cambio de clave: regresión de 12 pruebas aprobadas.
- Usuarios/perfiles fijos, restablecimiento, desactivación y preservación del último administrador activo: regresión de 18 pruebas aprobadas.
- Entorno virtual y caché instalados dentro del proyecto. No se han creado usuarios de producción.

## 2026-09-08 — Galpones y animales

- Galpones: 20 pruebas acumuladas aprobadas, con edición, borrado restringido, desactivación y códigos no reutilizables.
- Animales: 28 pruebas acumuladas aprobadas. Ingreso/muerte/venta/traslado/ajuste; validación retroactiva y rollback inducido después de insertar un traslado.
- Revisada separación: rutas delegan casos de uso, repositorios encapsulan ORM, dominio valida secuencias y autorización. No se añaden consultas SQL a rutas.

## 2026-09-14 — Reanudación, inventario y alertas

- Se confirmó la regresión previa de 34 pruebas. La base de trabajo existente está vacía; no se modificaron registros de usuario.
- Inventario: entradas por recepción independiente, salidas, ajustes, consulta, clasificación y filtros de historial implementados. Pruebas de saldo, vencimiento, transacción y galpón inactivo.
- Corregida validación de números vacíos y excesivamente largos: 38 pruebas aprobadas.
- Dashboard por perfil, navegación y alertas: 47 pruebas aprobadas. Incluye límites de hoy, 30 y 31 días, saldo cero y mínimo calculado sobre alimento utilizable.

## 2026-09-14 — Reportes y exportación CSV

- Reportes diario/semanal/mensual, filtro por galpón e indicador aproximado: 52 pruebas acumuladas aprobadas.
- CSV reutiliza consultas de inventario, historial y reportes, con filtros, UTF-8 y protección contra fórmulas de hoja de cálculo. No escribe en SQLite; la igualdad binaria antes/después se verifica en pruebas.

## 2026-09-15 — Cierre de módulos y validación

- Suite completa: 70 pruebas aprobadas en 44,48 s. Pip check sin conflictos.
- Pruebas completas de permisos GET/POST, integridad referencial, historial inmutable, concurrencia y rollback.
- Comprobados reinicio y funcionamiento sin conexiones externas en tests/test_runtime.py.
- Corregida colisión de nombres de respaldo con UUID y prueba con reloj fijo.
- Documentación técnica, manuales, trazabilidad completa de RF/RNF y siete fuentes Mermaid actualizados.
- Empaquetado en preparación; el ensayo del ejecutable se registra por separado en smoke_windows.json.

## 2026-09-15 — Empaquetado y entrega

- PyInstaller 6.16 generó Avicola.exe en modo carpeta para Windows x64. Corregidas rutas absolutas de recursos al construir desde build/.
- Ensayo del binario aprobado en una copia aislada, sin Python en PATH: inicialización, operaciones HTTP, CSV, respaldo y persistencia tras reinicio.
- ZIP portable sin base, credenciales ni datos ficticios; documentación y licencias incluidas.
- Resultado completo de pruebas: 70 aprobadas. No hay fallos conocidos pendientes. Chrome/Edge y Windows 10 no se verificaron directamente; revisión visual en navegador integrado y ejecución en Windows 11.
