# Matriz de trazabilidad RF/RNF

Fuente: archivo maestro y aclaraciones aprobadas por el usuario. Los módulos están implementados; las pruebas se ubican en tests/. Consulte informe_pruebas.md para resultados de ejecución y límites de verificación. Los nombres abreviados de pruebas se resuelven en el archivo indicado o mediante pytest --collect-only.

## Requisitos funcionales

| Requisito | Módulo / caso de uso | Pruebas |
| --- | --- | --- |
| RF-01 | Auth.login / actor | test_auth.py::test_login_logout_protected; test_wrong_inactive_and_sql_injection |
| RF-02 | Auth + POST /logout | test_auth.py::test_login_logout_protected |
| RF-03 | Users.save / list | test_users.py::test_create_edit_unique_deactivate_reset; test_preserve_last_administrator |
| RF-04 | policy / Users.save | test_users.py::test_authorization_roles; test_security_integrity.py::test_all_routes_and_post_permissions |
| RF-05 | Auth.change_password / Users.reset_password | test_auth.py::test_password_hash_change_confirmation; test_users.py::test_create_edit_unique_deactivate_reset |
| RF-06 | Pens.save / pen_code | test_pens.py::test_codes_edit_delete_no_reuse; test_foundation.py::test_dates_and_codes |
| RF-07 | Pens.change_state / save | test_pens.py::test_pen_with_history_cannot_delete; test_codes_edit_delete_no_reuse |
| RF-08 | Animals.register (ingreso) | test_animals.py::test_income_death_sale_transfer |
| RF-09 | Animals.register (muerte/venta) | test_animals.py::test_income_death_sale_transfer; test_insufficient_animals |
| RF-10 | Animals.register (traslado) / UoW | test_animals.py::test_transfer_rollback_after_insert; test_inactive_same_destination_invalid_quantity |
| RF-11 | Animals.register (ajuste) | test_animals.py::test_adjustment_authorization_and_history |
| RF-12 | Pens.list | test_inventory.py::test_entry_output_distinct_lots_consumption; test_pens.py |
| RF-13 | Inventory.receive | test_inventory.py::test_entry_output_distinct_lots_consumption; test_entry_rollback_lot_and_movement |
| RF-14 | Inventory.deliver | test_inventory.py::test_insufficient_zero_fraction_negative; test_expired_and_reception_dates; test_filters_and_inactive_pen |
| RF-15 | Feed.balances / Inventory._snapshot | test_inventory.py::test_entry_output_distinct_lots_consumption; test_security_integrity.py::test_concurrent_outputs_cannot_overdraw |
| RF-16 | Inventory.adjust | test_inventory.py::test_adjustment_and_minimum; test_security_integrity.py::test_adjustment_rollback_after_insert |
| RF-17 | Inventory.snapshot | test_inventory.py::test_entry_output_distinct_lots_consumption; test_expired_and_reception_dates |
| RF-18 | Inventory.lots / expiry_status | test_alerts.py::test_expiry_boundaries; test_low_exhausted_expired_and_zero_hidden |
| RF-19 | Dashboard.alerts / summary | test_alerts.py::test_low_exhausted_expired_and_zero_hidden; test_dashboard_visibility_and_navigation |
| RF-20 | Inventory.history / Feed.history | test_inventory.py::test_filters_and_inactive_pen; test_security_integrity.py::test_immutable_history_and_foreign_keys |
| RF-21 | Reports.consumption | test_reports.py::test_period_consumption_and_indicator; test_selected_pen_current_population_inactive_history; test_calendar_boundaries |
| RF-22 | approximate_ratio / Reports | test_reports.py::test_period_consumption_and_indicator; test_selected_pen_current_population_inactive_history |
| RF-23 | Configuration.set_minimum | test_inventory.py::test_adjustment_and_minimum; test_foundation.py::test_required_zero_allowed_integer_still_rejects_empty |
| RF-24 | inventory_status / Dashboard | test_alerts.py::test_low_exhausted_expired_and_zero_hidden |
| RF-25 | Exports / encode_csv | test_exports.py::test_csv_matches_query_filters_no_db_changes; test_csv_quoting_unicode_and_formula_protection |
| RF-26 | Backup / SQLiteBackup | test_backup.py::test_backup_complete_valid_and_restore; test_backup_denied_and_failed_copy_not_listed |

## Requisitos no funcionales

| Requisito | Implementación | Verificación / alcance |
| --- | --- | --- |
| RNF-01 | Estáticos propios y servicio local | test_runtime.py::test_functions_do_not_need_outbound_network; revisión del navegador |
| RNF-02 | run.py / sesiones Flask | test_security_integrity.py::test_all_routes_and_post_permissions; servicio en 127.0.0.1 |
| RNF-03 | Portable Windows / navegador HTML | Windows 11 ejecutado; navegador integrado revisado; Chrome/Edge no conectados para prueba directa |
| RNF-04 | SQLite archivo físico | test_foundation.py::test_sqlite_initialization_persistence |
| RNF-05 | Agregaciones e índices | test_performance.py::test_ten_thousand_movements_performance (límites 3/5 segundos) |
| RNF-06 | SqlAlchemyUnitOfWork / BEGIN IMMEDIATE | test_transfer_rollback_after_insert; test_entry_rollback_lot_and_movement; test_adjustment_rollback_after_insert; test_concurrent_outputs_cannot_overdraw |
| RNF-07 | domain/rules.py y casos de uso | test_foundation.py; test_animals.py; test_inventory.py |
| RNF-08 | WerkzeugHasher / Auth / Users | test_auth.py::test_password_hash_change_confirmation |
| RNF-09 | domain/policy.py / navegación | test_security_integrity.py::test_all_routes_and_post_permissions; test_all_routes_require_session |
| RNF-10 | Movimientos y audit_events | test_security_integrity.py::test_immutable_history_and_foreign_keys; pruebas de ajustes; fecha UTC y autor obligatorios |
| RNF-11 | Formularios, mensajes y confirmaciones | Recorrido de navegador: login/recepción/salida/reportes/backup; data-confirm en ajustes y cambios sensibles |
| RNF-12 | SQLiteBackup / procedimiento | test_backup.py::test_backup_complete_valid_and_restore; docs/restauracion_backup.md |
| RNF-13 | Raíz persistente y ejecución local | test_runtime.py::test_restart_preserves_data_secret_and_login; scripts/smoke_windows.py |
| RNF-14 | Capas, módulos y documentación | test_security_integrity.py::test_clean_layer_imports; manuales y diagramas |
| RNF-15 | CSS compartido y navegación por permiso | test_alerts.py::test_dashboard_visibility_and_navigation; revisión visual |
| RNF-16 | Dependencias y distribución | docs/licencias.md y docs/third_party/; tecnologías gratuitas y de código abierto |

## Reglas aclaradas

- Recepción independiente por lote: test_entry_output_distinct_lots_consumption.
- Existencia física / utilizable / vencida: test_expired_and_reception_dates y test_low_exhausted_expired_and_zero_hidden.
- Registros atrasados sin alterar ajustes ni saldos históricos: test_backdated_move_checks_entire_history y test_adjustment_authorization_and_history.
- Semanas y meses calendario: test_calendar_boundaries.
- Permisos acordados para operario, bodega y supervisor: test_all_routes_and_post_permissions.
