# Especificaciones (SDD)

Índice y estado de las especificaciones del aplicativo **Bloqueo Por Momento
Jejeejj**.

- **Fuente de verdad:** el `spec.md` de cada carpeta.
- **Decisiones:** `plan.md` §10 (ADR locales) y `.specify/memory/adr/` (globales).
- **Terminado:** se mide por las casillas de `tasks.md` (`[x]` hecho, `[~]` parcial, `[ ]` pendiente).

---

## Matriz de estado

| # | Funcionalidad | Estado | Tareas | Pendientes |
|---|---|---|---|---|
| 001 | [Bloqueo por momento Jejeejj](./001-bloqueo-por-momento-jejeejj/) | Borrador | 0/14 | Aprobación de spec y plan |

**Total:** 0 tareas cerradas.

---

## Pendientes reales

| # | Tarea | Por qué falta | Cómo cerrarla |
|---|---|---|---|
| 001 | Spec 001 | En estado Borrador | Aprobar `spec.md` y `plan.md` |

---

## Cómo agregar una spec

1. Crear la carpeta con el siguiente número: `specs/0NN-nombre-en-kebab-case/`.
2. Partir de las plantillas de `.specify/templates/`.
3. Seguir la skill **crear-spec**.
4. Agregar la fila a esta matriz.

> Los números no se reutilizan. Una spec reemplazada queda con estado
> **Reemplazada por 0NN** en su `spec.md`.
