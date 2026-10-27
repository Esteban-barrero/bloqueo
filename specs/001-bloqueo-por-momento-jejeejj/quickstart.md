# Quickstart: Bloqueo Por Momento Jejeejj

- **ID:** 001 | **Spec:** [`spec.md`](./spec.md) | **Plan:** [`plan.md`](./plan.md)

---

## 1. Requisitos

- Flutter (SDK local).
- Android (Accessibility Service para bloquear launches).
- Sin Firebase / backend.

## 2. Puesta en marcha

1. `flutter create .` o estructura del proyecto local.
2. Configurar `shared_preferences` / plugin nativo de accesibilidad.
3. Registrar el servicio de accesibilidad en Android.

## 3. Verificación

- CA-01: Configurar bloqueo por tiempo 2 h → esperar → app bloqueada → se libera.
- CA-02: Configurar horario (ej. 22:00–04:00) → intentar abrir app → pantalla de bloqueo.
- CA-03: Fuera del horario → no hay bloqueo.
- CA-04: Reiniciar app/dispositivo → la configuración persiste.
- CA-05: Al crear el bloqueo, ingresar un mensaje (o usar el predeterminado) → al
  intentar abrir la app bloqueada en el período, mostrarse el mensaje configurado.

## 4. Problemas frecuentes

- Accesibilidad no habilitada → instructivo para habilitar.
- iOS no soporta el mismo mecanismo → documentar limitación.
