# Seguridad implementada

- SQLAlchemy enlaza valores en filtros, inserciones y actualizaciones. No se concatena entrada de usuario a SQL. El SQL textual restante es DDL fijo de triggers, PRAGMA y BEGIN IMMEDIATE. El verificador de backup parametriza el tipo de objeto consultado.
- Contraseñas con Werkzeug scrypt; nunca se muestran ni se incluyen en auditoría o logs. No hay contraseña inicial de producción. El primer administrador se crea una sola vez dentro de una transacción.
- Sesiones Flask firmadas con secreto aleatorio persistente. Solo contienen ID de usuario, versión de sesión, CSRF y datos de sesión de Flask, no credenciales. Cookies HttpOnly, SameSite=Strict, duración máxima de 8 horas; Secure no se activa porque el servicio es HTTP exclusivamente local.
- Cada petición vuelve a verificar estado y versión del usuario. Cambios de clave, perfil o estado incrementan la versión, invalidando sesiones previas. Nunca puede quedar sin administrador activo por una edición.
- Toda escritura web exige token CSRF. Cerrar sesión es POST. Ajustes, eliminación/desactivación y cambios administrativos solicitan confirmación de interfaz; la autorización del caso de uso sigue siendo obligatoria.
- Autorización fija centralizada en domain/policy.py; cada caso de uso sensible verifica el permiso y el menú oculta acciones no permitidas. No existe editor de permisos.
- Autoescape Jinja2 y encabezados CSP, X-Frame-Options y nosniff. Las respuestas no se almacenan en caché. Hosts permitidos: 127.0.0.1 y localhost; el servidor escucha únicamente en loopback.
- Las cantidades tienen formato entero acotado; fechas, campos y observaciones se validan antes de persistir. Las transacciones serializadas comprueban la secuencia de saldos, incluidos movimientos retroactivos.
- Claves foráneas habilitadas en cada conexión; CHECK/UNIQUE y triggers impiden actualizar o borrar movimientos y auditoría. No hay rutas para editar o borrar historial.
- CSV protege celdas de texto que comienzan como fórmulas y usa el escapado estándar para comas, comillas y saltos de línea.
- Errores de negocio se muestran con mensajes concretos. Fallos técnicos se registran por clase y ruta, sin volcar parámetros, formularios, claves ni tracebacks al usuario.

## Límite del entorno

Es un sistema local para un computador; no es un servicio expuesto a Internet. SQLite y backups no están cifrados. La protección frente a quien tenga acceso al disco depende de la cuenta, permisos y controles de Windows. No publique ni incluya en el repositorio `database/`, `backups/` ni el secreto. No se implementan módulos ajenos al alcance, como MFA, recuperación por correo o nube.

Los tests verifican login válido/incorrecto/inactivo, sesión, CSRF, hash, invalidación, matriz completa de permisos GET/POST, XSS, entradas de inyección SQL tratadas como datos, restricciones de SQLite e integridad transaccional.
