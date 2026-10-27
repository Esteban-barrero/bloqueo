# Tareas: Bloqueo Por Momento Jejeejj

- **ID:** 001 | **Plan:** [`plan.md`](./plan.md)
- **Fecha:** 2026-10-27

> Marca `[x]` cuando la tarea esté terminada y verificada.

---

## Fase 1 — Preparación

- [ ] T001 Crear estructura de carpetas `features/bloqueo/{data,domain,presentation}`
- [ ] T002 Definir entidades `Bloqueo` y lógica de vigencia (`domain`)
- [ ] T003 Definir contrato local `GestorBloqueos` + persistencia (`data`)

## Fase 2 — Lógica de Negocio

- [ ] T010 Implementar `GestorBloqueoVigente.estaActiva` (horario / tiempo)
- [ ] T011 Implementar caso de uso `crearBloqueo`
- [ ] T012 Implementar `eliminarBloqueo`

## Fase 3 — Interfaz de Usuario

- [ ] T020 Lista de apps instaladas + selección objetivo
- [ ] T021 Editor de bloqueo (horario / tiempo)
- [ ] T022 Pantalla de bloqueo al intentar abrir app bloqueada

## Fase 4 — Seguridad y Privacidad

- [ ] T030 Garantizar persistencia local con datos sensibles del usuario

## Fase 5 — Pruebas y Cierre

- [ ] T040 Pruebas unitarias de vigencia
- [ ] T041 Pruebas de widget (editor + pantalla de bloqueo)
- [ ] T042 Ejecutar `flutter analyze` y `flutter test`
- [ ] T043 Documentar métodos y clases (Principio 11)
- [ ] T044 Actualizar documentación

---

## Criterio de Terminado (Definition of Done)

- [ ] Criterios de aceptación de `spec.md` cumplidos
- [ ] `flutter analyze` sin errores
- [ ] Pruebas pasando
- [ ] Código documentado: cada método y clase comentado en español (Principio 11)
- [ ] Commit y push realizados
