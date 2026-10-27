# Guía Rápida: <NOMBRE DE LA FUNCIONALIDAD>

- **ID:** <NNN> | **Spec:** [`spec.md`](./spec.md) | **Plan:** [`plan.md`](./plan.md)

---

## 1. Requisitos previos

- Flutter <versión> y Dart <versión>.
- Acceso al proyecto Firebase `aplicativo-de-ventas-d8bcd`.
- Una empresa de prueba (`demo`) y un usuario con el rol necesario.
- <Herramientas extra: emulador, gcloud, etc.>

## 2. Puesta en marcha

```bash
cd app
flutter pub get
flutter run -d chrome --web-port=5000
```

## 3. Datos de prueba

| Qué | Dónde | Valor |
|---|---|---|
| Empresa | `empresas/demo` | ... |
| Usuario | `usuarios/<uid>` | ... |
| Parámetros | `empresas/demo` | ... |

> Nunca escribir contraseñas en este archivo.

## 4. Configuración en Firebase

<Reglas, índices, Functions, claims o datos semilla que deban existir.>

```bash
# Despliegue de reglas (sin CLI, ver skill desplegar-reglas)
```

## 5. Cómo verificar (paso a paso)

1. Entrar con <usuario> y abrir <módulo>.
2. <Acción concreta>.
3. **Resultado esperado:** <qué debe verse en pantalla>.
4. Comprobar en Firestore: <colección y campo>.
5. Comprobar en `_auditoria`: <registro esperado>.

## 6. Problemas frecuentes

| Síntoma | Causa probable | Solución |
|---|---|---|
| «No pudimos verificar tu licencia» | Token sin *custom claims* | Refrescar token / revisar `onUsuarioEscrito` |
| Datos vacíos en Web | Sin conexión o reglas | Revisar consola y reglas |
| ... | ... | ... |

## 7. Limpieza

<Cómo revertir los datos de prueba sin dejar basura.>
