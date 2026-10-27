# Modelo de Datos: Bloqueo Por Momento Jejeejj

- **ID:** 001 | **Spec:** [`spec.md`](./spec.md) | **Plan:** [`plan.md`](./plan.md)

---

## 1. Alcance

Datos locales del dispositivo (sin backend, sin Firestore). La única "tabla" es la
configuración de bloques del usuario.

## 2. Entidades

### Bloqueo (configuración local)

| Campo | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `id` | String (UUID) | Sí | Identificador del bloqueo. |
| `appPackage` | String | Sí | Paquete de la app objetivo (p. ej., `com.instagram.android`). |
| `appName` | String | Sí | Nombre visible de la app. |
| `tipo` | Enum (`horario` \| `tiempo`) | Sí | Cómo se aplica el bloqueo. |
| `diasSemana` | List\<Int\> | Sí | Días de la semana (0=domingo … 6=sábado). |
| `horaInicio` | Int (minutos) | Sí | Hora inicio del bloqueo por horario. |
| `horaFin` | Int (minutos) | Sí | Hora fin del bloqueo por horario. |
| `duracionMinutos` | Int | Sí | Duración del bloqueo por tiempo. |
| `activo` | Bool | Sí | Estado del bloqueo. |

## 3. Reglas de persistencia

- Clave única en `SharedPreferences` (o `flutter_secure_storage` para datos
  sensibles — decisión pendiente en ADR).
- El formato MVP: lista de `Bloqueo`.

## 4. Cálculo de vigencia

```
bloqueoVigente(bloqueo, ahora):
  si tipo == 'tiempo':
    activo si ahora <= bloqueo.creacion + duracionMinutos   (o ventana activa)
  si tipo == 'horario':
    activo si diasSemana contiene ahora.diaSemana Y
           horaInicio <= ahora.minutos < horaFin
```

## 5. Índices / consultas

- Consulta por `activo == true`.
- No hay joins; la app evalúa la vigencia contra la hora actual.
