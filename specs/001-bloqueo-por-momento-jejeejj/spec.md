# Especificación: Bloqueo Por Momento Jejeejj

- **ID:** 001 | **Carpeta:** `specs/001-bloqueo-por-momento-jejeejj/`
- **Fecha:** 2026-10-27
- **Estado:** Borrador
- **Responsable:** Esteban Barrero

---

## 1. Resumen

La aplicación **Bloqueo Por Momento Jejeejj** permite al usuario bloquear el
acceso a aplicaciones que considera distractoras sobre el propio dispositivo.

El usuario ingresa a la aplicación, selecciona la aplicación objetivo a bloquear
(p. ej., Instagram, TikTok), define el tipo de bloqueo (por **horario** o por
**tiempo de uso**) y lo confirma. Cuando el usuario intenta abrir la aplicación
bloqueada dentro del período de bloqueo, la aplicación muestra una **pantalla de
bloqueo**.

## 2. Objetivo

- Que el usuario controle el tiempo de consumo de aplicaciones distractoras.
- Soporte de bloqueo por **horario** (ej. lunes a viernes, 22:00 → 04:00) y por
  **tiempo de uso** (ej. bloquear Instagram por 2 horas).
- Configuración **100% local y privada**, sin backend ni base de datos.

## 3. Actores / Roles

| Rol | Acción |
|---|---|
| **Usuario** | Configura bloqueos, consulta estado y cancela bloqueos. |

## 4. Historias de Usuario

- **Como** usuario, **quiero** bloquear una aplicación por un tiempo definido
  (ej. 2 horas) **para** recuperar la productividad.
- **Como** usuario, **quiero** configurar un horario de bloqueo (ej. sueño:
  lun–vie 22:00 → 04:00) **para** no caer en distracciones.
- **Como** usuario, **quiero** tener varios bloques activos (ej. varios horarios
  de trabajo) **para** cubrir distintas franjas.

## 5. Requisitos Funcionales

- RF-01: El sistema debe permitir seleccionar la aplicación objetivo a bloquear,
  obtenida de las aplicaciones instaladas en el dispositivo.
- RF-02: El sistema debe permitir definir un bloqueo por **horario**
  (día(s) de la semana, hora inicio y hora fin).
- RF-03: El sistema debe permitir definir un bloqueo por **tiempo de uso**
  (duración en minutos u horas durante la cual la app permanece bloqueada).
- RF-04: El sistema debe detectar el intento de apertura de una aplicación
  bloqueada dentro del período vigente y mostrar la pantalla de bloqueo.
- RF-05: El sistema debe persistir la configuración del bloqueo en el dispositivo
  (sin backend).
- RF-06: El sistema debe permitir consultar el estado y cancelar/eliminar un
  bloqueo.

- RF-07: El sistema debe permitir configurar el **mensaje de bloqueo** al crear
  el bloqueo (por horario o por tiempo), con un mensaje predeterminado. El
  mensaje se muestra al intentar abrir una aplicación bloqueada en el período de
  bloqueo y debe poder editarse desde la pantalla de bloqueo. **Mensaje
  predeterminado:** «Oye, no pierdas el tiempo...».

## 6. Reglas de Negocio

- RN-01: Un bloqueo se aplica a una o varias aplicaciones seleccionadas.
- RN-02: Un bloqueo por horario solo se aplica en los días y horas definidos.
- RN-03: Un bloqueo por tiempo se libera al cumplirse la duración.
- RN-04: Si existen varios bloques, se aplica el que esté vigente
  (coincidencia día/hora o ventana de tiempo).

## 7. Criterios de Aceptación

- [ ] CA-01: Al configurar un bloqueo por tiempo y vencerlo, la aplicación queda
      bloqueada durante ese tiempo y se libera al cumplirse.
- [ ] CA-02: Al intentar abrir una app bloqueada dentro del horario, se muestra la
      pantalla de bloqueo.
- [ ] CA-03: Fuera del período definido, la app no se bloquea.
- [ ] CA-04: La configuración persiste en el dispositivo y sobrevive a reinicio.
- [ ] CA-05: El mensaje configurado se muestra al intentar abrir una aplicación
      bloqueada dentro del período de bloqueo.
- [ ] CA-06: Desde la pantalla de bloqueo debe existir un botón **Desbloquear**
      que permita desbloquear la aplicación.

## 8. Datos Involucrados

- Configuración local de bloqueos (persistencia en dispositivo):
  - `bloqueos[]`: id, appPackage, appName, tipo (`horario` | `tiempo`),
    diasSemana[], horaInicio, horaFin, duracionMinutos, activo, mensaje.

## 9. Casos Borde / Errores

- La aplicación objetivo se desinstala mientras tiene bloqueo vigente.
- Intento de apertura de app bloqueada fuera del período → sin bloqueo.
- Usuario cancela el bloqueo → la app deja de bloquearse.

## 10. Fuera de Alcance

- Sincronización multi-dispositivo.
- Backend, base de datos central ni análisis de uso.
- Integraciones con otras plataformas de productividad.

## 11. Dependencias

- Capacidades nativas del sistema operativo para detectar y bloquear la apertura
  de aplicaciones (p. ej., Android Accessibility / Usage; ver plan).
