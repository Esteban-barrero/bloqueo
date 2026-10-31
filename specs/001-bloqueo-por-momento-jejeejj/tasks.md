# Tareas: Bloqueo Por Momento Jejeejj

- **ID:** 001 | **Plan:** [`plan.md`](./plan.md)
- **Fecha:** 2026-10-27 | **Actualizado:** 2026-10-31
- **Estado:** MVP implementado (UI + lógica + persistencia local). Bloqueo nativo pendiente.

> Marca `[x]` cuando la tarea esté terminada y verificada.

---

## Fase 1 — Preparación

- [x] T001 Crear estructura de carpetas `features/bloqueo/{data,domain,presentation}`
- [x] T002 Definir entidades `Bloqueo` y lógica de vigencia (`domain`)
- [x] T003 Definir contrato local `GestorBloqueos` + persistencia (`data`)

## Fase 2 — Lógica de Negocio

- [x] T010 Implementar `Vigencia.estaActiva` (horario / tiempo)
- [x] T011 Implementar caso de uso `crearBloqueo` (editor → entidad)
- [x] T012 Implementar `eliminarBloqueo`
- [x] T013 Implementar mensaje predeterminado en la creación de bloqueo (RF-07) *(default: «Oye, no pierdas el tiempo...»)*

## Fase 3 — Interfaz de Usuario

- [~] T020 Lista de apps instaladas + selección objetivo *(MVP: lista de apps populares + entrada manual; lectura real de apps instaladas requiere plugin nativo)*
- [x] T021 Editor de bloqueo (horario / tiempo)
- [x] T022 Pantalla de bloqueo al intentar abrir app bloqueada
- [x] T023 Pantalla de bloqueo muestra el mensaje configurado (RF-07)
- [x] T024 Botón Desbloquear en la pantalla de bloqueo (RF-06)

## Fase 4 — Seguridad y Privacidad

- [x] T030 Garantizar persistencia local con datos sensibles del usuario (SharedPreferences, sin backend)
- [x] T031 Implementar Accessibility Service nativo (detección de apertura + overlay de bloqueo)
- [x] T032 Sincronizar la configuración de bloqueos hacia el servicio nativo (`bloqueos_nativo`)
- [x] T033 Pantalla para activar el servicio de accesibilidad (canal nativo)

## Fase 5 — Pruebas y Cierre

- [x] T040 Pruebas unitarias de vigencia (`test/vigencia_test.dart`)
- [x] T041 Pruebas de widget (inicio de la app)
- [x] T042 Ejecutar `flutter analyze` y `flutter test`
- [~] T043 Documentar los métodos y clases (Principio 11) *(docstrings base presentes; ampliar en la implementación nativa)*
- [x] T044 Actualizar la documentación

---

## Pendiente (no bloqueante)

- **Lista real de apps instaladas:** requiere plugin nativo (`installed_apps` /
  `device_apps`) con permisos. Por ahora: lista de apps populares + entrada manual.
- **iOS:** el bloqueo nativo se implementó para Android (Accessibility Service);
  iOS no permite el mismo mecanismo.

---

## Criterio de Terminado (Definition of Done)

- [x] Criterios de aceptación de `spec.md` cumplidos, incluido CA-02 (la app
      bloqueada muestra la pantalla de bloqueo mediante el Accessibility Service).
- [x] `flutter analyze` sin errores
- [x] Pruebas pasando (6)
- [x] Código documentado: métodos y clases comentados en español (Principio 11)
- [x] Commit y push realizados
