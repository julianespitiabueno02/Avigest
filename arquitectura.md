# Arquitectura definitiva

Fuente principal: PROMPT_MAESTRO_COWORK_AVICOLA.md, leído completamente antes de implementar. La carpeta original solo contenía ese documento; se conservó. Las decisiones de negocio se confirmaron con el usuario antes de programar.

## Estructura real

```text
app/
  __init__.py                  # fábrica y composición
  config/settings.py           # raíz y secreto persistente
  domain/
    entities.py                # Actor y códigos visibles
    rules.py                   # validación, fechas, saldos, indicadores
    policy.py                  # cuatro perfiles y permisos
    errors.py                  # errores de negocio
    ports.py                   # contratos de repositorios/UoW/seguridad
  application/
    dto/export.py              # documento CSV
    use_cases/                 # auth, users, pens, animals, inventory,
                               # configuration, dashboard, reports,
                               # exports y backup
  infrastructure/
    database/                  # modelos, conexión, integridad, UoW
    repositories/              # consultas y persistencia SQLAlchemy
    security/                  # hash Werkzeug
    backup/                    # API backup SQLite + verificación
    csv_export.py              # codificación y escapado CSV
  web/
    routes/                    # blueprints
    templates/                 # Jinja2 por módulo y parciales
    static/css/ y static/js/   # recursos propios locales
    navigation.py              # navegación según permisos
run.py
requirements.txt / requirements-dev.txt / requirements-lock.txt
scripts/                       # construcción y verificación portable
README.md
database/ backups/ exports/ logs/
tests/
docs/ y docs/diagrams/
```

Se agrupan responsabilidades pequeñas en archivos, en lugar de crear carpetas vacías para entidades, enums, exceptions o forms. Las validaciones están centralizadas en dominio; los controles HTML están en plantillas. Esto conserva modularidad sin abstraer cada campo o duplicar cada entidad.

## Regla de dependencias

Presentación → aplicación → dominio. Infraestructura implementa los contratos del dominio. Solo la fábrica conoce las implementaciones concretas e inyecta las dependencias. Dominio y aplicación no importan Flask, SQLite ni SQLAlchemy; presentación no importa persistencia. Una prueba de imports comprueba estas fronteras.

Las rutas convierten petición a argumentos, llaman un caso de uso y generan una respuesta; no contienen reglas operativas ni acceso a datos. Los casos de uso comprueban permisos, coordinan repositorios y aplican reglas. La unidad de trabajo gestiona commit/rollback; los repositorios usan consultas enlazadas.

El dominio representa las reglas y conceptos independientes del ORM; los datos de persistencia cruzan a aplicación como valores simples. No se introduce microservicio, contenedor, cola, bus de eventos ni servidor externo.

## Ejecución y seguridad

Waitress sirve Flask en 127.0.0.1, HTML Jinja2 y recursos estáticos locales. SQLite es archivo persistente. Sesiones firmadas, hash scrypt, CSRF, autorización de backend, historial inmutable y errores centralizados. La interfaz adapta menú y botones al perfil.

Los detalles, cardinalidades e invariantes están en modelo_dominio.md y base_datos.md. El orden de desarrollo y las pruebas por fase constan en changelog.md. La matriz de trazabilidad relaciona todos los RF/RNF con sus implementaciones y verificaciones.
