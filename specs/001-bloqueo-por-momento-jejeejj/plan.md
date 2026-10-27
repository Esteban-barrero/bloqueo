# Plan Técnico: Bloqueo Por Momento Jejeejj

- **ID:** 001 | **Spec:** [`spec.md`](./spec.md)
- **Fecha:** 2026-10-27
- **Estado:** Borrador

---

## 1. Resumen Técnico

Aplicación Flutter local que gestiona un catálogo de bloqueos de aplicaciones
instaladas. La lógica de "bloqueo vigente" se evalúa contra la configuración
local (tipo horario o tiempo) y, si aplica, se intercepta el launch mediante un
servicio nativo (Accessibility Service en Android).

## 2. Arquitectura

```
Flutter (app Bloqueo)
   │
   ├─ data/     → GestiónLocalBloqueos (SharedPreferences) + BloqueoRepository
   ├─ domain/   → Entidades Bloqueo, Casos de uso: crearBloqueo, estaActiva(Bloqueo, ahora)
   └─ presentation/ → Pantalla lista de apps, editor de bloqueo, pantalla de bloqueo
        │
        └─ (PlatformChannel) Accessibility Service (nativo Android) → intercept launch
```

## 3. Estructura de Carpetas (Flutter)

```
lib/features/bloqueo/
├── data/
│   ├── modelos/bloqueo_modelo.dart
│   └── repositorios/gestor_bloqueos.dart
├── domain/
│   ├── entidades/bloqueo.dart
│   └── casos_de_uso/crear_bloqueo.dart, bloquearAplicacion.dart, esta_activa.dart
└── presentation/
    ├── bloquear_app_lista_screen.dart
    ├── bloquear_app_editar_screen.dart
    └── bloquear_app_pantalla.dart
```

## 4. Modelo de Datos

Ver [`data-model.md`](./data-model.md). Configuración local de bloques.

## 5. Contratos / Interfaces

Ver [`contracts/bloqueo-contracts.md`](./contracts/bloqueo-contracts.md).

- `GestorBloqueos.cargar(): List<Bloqueo>`
- `GestorBloqueos.guardar(Bloqueo)`
- `GestorBloqueos.eliminar(id)`

## 6. Reglas de Seguridad

- Configuración local del usuario; sin autenticación por ahora.
- El bloqueo aplica solo al usuario local del dispositivo.

## 7. Dependencias y Librerías

- `shared_preferences`
- `flutter` (nativo Android: Accessibility Service)
- `provider` / `riverpod` → según convención del proyecto (StatefulWidget + repos).

## 8. Estrategia de Pruebas

- Unit: lógica de vigencia (`estaActiva`).
- Widget: editor de bloqueo y pantalla de bloqueo.

## 9. Riesgos

- Capacidad nativa de bloquear en Android/iOS.
- Precisión del servicio de accesibilidad.

## 10. Decisiones Técnicas (ADR)

- **ADR-001:** Bloqueo vía Accessibility Service (Android) + captura de launch.
- **ADR-002:** Persistencia local con SharedPreferences (sin backend).
- **ADR-003:** Mensaje de bloqueo configurable por bloqueo (RF-07), con mensaje
  predeterminado.
