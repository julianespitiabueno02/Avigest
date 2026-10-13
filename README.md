# Avícola — gestión local de alimento y galpones

Aplicación académica para un computador Windows. Python, Flask, Jinja2, HTML/CSS/JavaScript local, SQLAlchemy y SQLite. Sin servicios externos durante su uso.

## Inicio sencillo en Windows

Abra la carpeta `dist/Avicola` y ejecute **Avicola.exe**. Conserve toda la carpeta, incluido `_internal`. El navegador abre `http://127.0.0.1:5000`. En el primer inicio, cree su propio administrador: **no hay contraseñas predeterminadas**.

La base queda junto al ejecutable, en `database/avicola.db`. Cerrar la ventana del servidor detiene la aplicación y conserva los datos. No ejecute desde dentro del ZIP ni desde una ubicación sin permisos de escritura.

## Ejecución desde código

Python 3.12 recomendado. Desde la raíz del proyecto:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe run.py
```

La instalación inicial de paquetes requiere Internet, o paquetes previamente descargados. El ejecutable incluye las dependencias y funciona sin instalar Python ni usar Internet. La base de la ejecución desde código está en `database/avicola.db` de esta raíz; es independiente de la base de la distribución portable.

## Alcance

Autenticación y cuatro perfiles; usuarios; galpones; ingreso, muerte, venta, traslado y ajuste de animales; recepciones por lote; salidas y ajustes de alimento; inventario físico/utilizable/vencido; alertas; historial; reportes; CSV; mínimo global y backup manual.

Cada recepción es un lote independiente. El estado de mínimo usa alimento utilizable; el vencido sigue en existencias físicas hasta un ajuste de baja. Se permiten registros atrasados que mantengan íntegro el historial; no movimientos futuros. Los ajustes físicos se registran hoy. Semanas lunes–domingo y meses calendario.

## Pruebas

```powershell
.\.venv\Scripts\python.exe -m pip install -r requirements-dev.txt
.\.venv\Scripts\python.exe -m pytest -q
```

Las bases de prueba se crean en `.test-tmp/`. No se cargan datos ficticios en la base principal. El servidor opcional `python -m tests.browser_server` usa exclusivamente `.cache/browser-review` y el puerto 5010; sus credenciales ficticias son `revision` / `solo-prueba-visual` y no pertenecen al producto.

## Documentación

- [Instalación y ejecución](docs/instalacion.md)
- [Manual de usuario](docs/manual_usuario.md)
- [Manual técnico](docs/manual_tecnico.md)
- [Arquitectura](docs/arquitectura.md), [dominio](docs/modelo_dominio.md) y [base de datos](docs/base_datos.md)
- [Seguridad](docs/seguridad.md) y [restauración](docs/restauracion_backup.md)
- [Trazabilidad RF/RNF](docs/trazabilidad.md) e [informe de pruebas](docs/informe_pruebas.md)
- [Decisiones](docs/decisiones_tecnicas.md), [cambios](docs/changelog.md), [licencias](docs/licencias.md)
- Fuentes de diagramas en `docs/diagrams/`.
