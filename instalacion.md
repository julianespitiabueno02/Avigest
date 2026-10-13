# Instalación y ejecución

## Distribución portable (usuario final)

1. Extraiga completamente `Avicola-Windows.zip` en una carpeta propia con permisos de escritura.
2. Entre en `Avicola` y abra `Avicola.exe`. Mantenga `_internal` junto al ejecutable.
3. Use la ventana del navegador que se abre, o escriba `http://127.0.0.1:5000` en Chrome o Edge.
4. En el primer inicio cree nombre, usuario y contraseña del administrador y confirme la contraseña.
5. Ingrese al sistema. Registre usuarios, galpones, mínimo y recepciones según corresponda.

No necesita Python, un servidor de bases de datos ni Internet para ejecutar la distribución. El servidor se limita a 127.0.0.1: no habilita acceso desde otros equipos. Los perfiles se prueban mediante sesiones de navegador separadas o cerrando sesión antes de cambiar de usuario.

Para cerrar: cierre la consola del servidor o presione Ctrl+C. Cerrar solo el navegador no detiene el servidor. Las transacciones confirmadas permanecen en `database/avicola.db`.

Si el puerto 5000 ya está ocupado, cierre una instancia anterior o ejecute desde una consola en la carpeta:

```powershell
.\Avicola.exe --port 5002
```

La opción `--no-browser` omite la apertura automática. No cambie el host para exponer el sistema a la red.

## Ejecución y desarrollo desde fuentes

El entorno de referencia es Python 3.12 de 64 bits en Windows. Se incluyen versiones fijadas para las dependencias directas y `requirements-lock.txt` para reproducir el entorno completo validado.

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements-lock.txt
.\.venv\Scripts\python.exe run.py
```

Si ya existe `.venv`, reutilícelo. La instalación inicial descarga paquetes de PyPI; para instalar sin conexión puede preparar previamente un directorio de wheels con `pip download` y utilizar `pip install --no-index --find-links`. El uso normal de la aplicación no hace descargas.

## Archivos persistentes

- `database/avicola.db`: todos los usuarios, movimientos, configuración y auditoría.
- `database/.session-secret`: clave local de firma de sesiones, creada automáticamente.
- `backups/`: copias verificadas de SQLite.
- `logs/avicola.log`: registro técnico rotativo, sin contraseñas ni formularios completos.
- `exports/`: carpeta disponible para guardar las descargas CSV. El navegador elige el destino; puede seleccionar esta carpeta.

En ejecución desde fuentes, estas rutas dependen de la raíz del código, no del directorio actual de la consola. En la distribución dependen de la carpeta del ejecutable. Mantenga su base elegida al actualizar: reemplace el programa y `_internal` con la aplicación detenida, conservando `database`, `backups` y su copia preventiva.

## Diagnóstico

Si no abre la página, revise que la consola continúe abierta y use exactamente la dirección indicada. Si no admite escrituras, revise permisos y espacio disponible. Si el formulario caducó, recargue y repita la operación. No modifique SQLite manualmente para corregir saldos: use ajustes justificados. Para recuperar una copia consulte `restauracion_backup.md`.
