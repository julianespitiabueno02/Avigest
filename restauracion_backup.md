# Restauración de una copia

Las copias son archivos SQLite completos en `backups/`, con fecha y hora local en el nombre. La creación usa la API de backup SQLite; no copia a ciegas un archivo abierto. Antes de confirmar se ejecutan `integrity_check`, `foreign_key_check` y comprobación de tablas requeridas.

## Procedimiento en Windows

1. Cierre la ventana de Avícola (o presione Ctrl+C en su consola). Cierre también otras instancias. No restaure con la aplicación ejecutándose.
2. En el Explorador abra la carpeta de la aplicación. Conserve una copia de seguridad del archivo actual `database/avicola.db`, por ejemplo `backups/antes_restaurar_FECHA.db`. No borre el original sin conservarlo.
3. Elija la copia `backups/avicola_FECHA_HORA.db` correspondiente. **Todos los registros posteriores a esa copia dejarán de estar en la base restaurada.**
4. Copie el archivo elegido a `database/` y renombre la copia como `avicola.db`, reemplazando el archivo actual solo después del paso 2. No mueva ni modifique la copia original del respaldo.
5. El sistema usa el journal normal de SQLite (no WAL). Tras un cierre normal no debería haber archivos `avicola.db-journal`, `avicola.db-wal` ni `avicola.db-shm`. Si los hay, no los mezcle con la copia: solicite revisión técnica antes de reemplazar la base.
6. Reinicie Avícola. Ingrese con un usuario y contraseña que existieran en la fecha del respaldo. Revise inventario, usuarios e historial.
7. Si el resultado no es el esperado, detenga la aplicación y reponga la copia conservada en el paso 2.

El archivo `database/.session-secret` no forma parte de SQLite. Al restaurar una copia se recomienda renombrarlo con la aplicación detenida para que el siguiente arranque genere otro y cierre las sesiones anteriores. Consérvelo si necesita revertir toda la operación. No publique ese archivo.

## Comprobación técnica opcional

Desde la raíz, con Python instalado y entorno preparado:

```powershell
.\.venv\Scripts\python.exe -c "from pathlib import Path; from app.infrastructure.backup.sqlite_backup import SQLiteBackup; SQLiteBackup.verify(Path('database/avicola.db').resolve()); print('Integridad correcta')"
```

El ensayo automatizado `test_backup_complete_valid_and_restore` crea una copia con datos, verifica su integridad, la restaura a otro archivo y consulta sus saldos a través de los repositorios. No modifica la base real del usuario.

Las copias locales protegen frente a errores de operación; para pérdida del disco, conserve periódicamente una copia en un medio externo según el procedimiento de su organización. La aplicación no realiza transferencias automáticas.
