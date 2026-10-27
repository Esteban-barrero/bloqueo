# Investigación y Decisiones: Bloqueo Por Momento Jejeejj

- **ID:** 001 | **Fecha:** 2026-10-27

---

## 1. Contexto

El usuario necesita controlar el tiempo de uso de aplicaciones distractoras
(redes sociales, entretenimiento) mediante bloqueos locales. No se requiere backend:
la configuración es sensible y se guarda en el propio equipo.

Restricciones: sin Firebase (solo local), stack Flutter, interfaz futurista.

## 2. Opciones Evaluadas

### 2.1. Mecanismo de bloqueo

| Opción | Ventajas | Desventajas |
|---|---|---|
| **A. Accessibility Service (Android)** | Bloquea el launch real de la app. | Requiere permisos/servicio especial; iOS limitado. |
| **B. UsageStatsManager (Android)** | Detecta uso; se puede bloquear por ventana. | Menos directo para "bloquear launch". |
| **C. Bloqueo a nivel de launcher/gate** (p. ej., app intermedia) | Simple. | Requiere que el usuario pase por la app bloqueada. |

**Decisión:** Opción A (Accessibility Service) como mecanismo principal para
Android; se documenta la limitación en iOS.

### 2.2. Persistencia de la configuración

| Opción | Ventajas | Desventajas |
|---|---|---|
| **A. SharedPreferences** | Simple, no requiere plugin extra. | Limitado a key-value simple. |
| **B. sqflite / Hive** | Estructurado, consultas. | Más complejidad inicial. |

**Decisión:** SharedPreferences para MVP (bloques como listas simples).

### 2.3. Alcance backend

| Opción | Ventajas | Desventajas |
|---|---|---|
| **A. Local (sin backend)** | Privacidad, sin infraestructura, cumple el requerimiento. | No sincroniza entre dispositivos. |

**Decisión:** Local.

## 3. Preguntas Abiertas

- ¿Cómo manejar iOS (Guided Access / no permitir launch)? → MVP Android, documentar.
- ¿Bloqueo por tiempo cuenta desde la activación del bloqueo o desde el primer intento de launch? → se asume desde la activación/ventana.

## 4. Referencias

- Requerimiento: `Documentacion/requerimiento_bloqueo.docx`.
- Spec: `specs/001-bloqueo-por-momento-jejeejj/spec.md`.
