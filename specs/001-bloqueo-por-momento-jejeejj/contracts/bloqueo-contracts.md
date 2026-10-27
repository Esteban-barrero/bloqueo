# Contratos: Bloqueo Por Momento Jejeejj

- **ID:** 001 | **Spec:** [`spec.md`](./spec.md) | **Plan:** [`plan.md`](./plan.md)

---

## 1. Contratos de repositorio local

### `GestorBloqueos` (local)

```dart
class GestorBloqueos {
  Future<List<Bloqueo>> cargar();          // lee de SharedPreferences
  Future<void> guardar(Bloqueo bloqueo);    // upsert
  Future<void> eliminar(String id);         // delete
  Future<void> limpiar();                   // reset (opcional)
}
```

### `GestorBloqueoVigente` (dominio)

```dart
class GestorBloqueoVigente {
  bool estaActiva(Bloqueo b, DateTime ahora);
}
```

### Bloqueo

- El contrato incluye el campo `mensaje` (RF-07): mensaje de bloqueo mostrado al
  intentar abrir la app bloqueada durante el período vigente.

## 2. Contrato de plataforma (bloqueo nativo)

```dart
abstract class BloqueadorAplicaciones {
  Future<bool> estaInstalada(String appPackage);
  Future<void> bloquear(String appPackage); // Accessibility Service
  Future<void> liberar(String appPackage);
}
```

## 3. Contrato de eventos

- `onAppIntentToBloqueada` → notificar UI para mostrar pantalla de bloqueo.

## 4. Errores

| Código | Origen | Acción |
|---|---|---|
| `APP_NO_INSTALADA` | intento launch de app bloqueada desinstalada | limpiar bloqueo |
| `BLOQUEO_ACTIVO` | launch dentro de ventana | mostrar pantalla de bloqueo |
