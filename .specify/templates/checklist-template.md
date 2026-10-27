# Checklist de Calidad: <NOMBRE DE LA FUNCIONALIDAD>

- **ID:** <NNN> | **Fecha:** <YYYY-MM-DD> | **Spec:** [`spec.md`](./spec.md)

> Se completa **antes** de dar la funcionalidad por terminada. Cada casilla debe
> poder demostrarse (prueba, consulta o captura), no solo marcarse.

---

## 1. Especificación

- [ ] `spec.md`, `plan.md`, `tasks.md`, `data-model.md` y `contracts/` están actualizados
- [ ] Cada criterio de aceptación tiene su verificación
- [ ] Los ADR nuevos están en el `plan.md` y, si son transversales, en `.specify/memory/adr/`
- [ ] Las decisiones descartadas quedaron en `research.md`

## 2. Multi-tenant y seguridad

- [ ] Toda consulta y escritura filtra por `empresaId`
- [ ] Las reglas de Firestore cubren leer/crear/actualizar/borrar por rol
- [ ] Se probó con **ID tokens reales** (no el token de administrador)
- [ ] Un usuario no puede acceder a datos de otra empresa
- [ ] Un usuario no puede ascender sus propios roles
- [ ] No se subieron secretos (`.env`, llaves, `serviceAccountKey.json`)

## 3. RBAC

- [ ] Los permisos se calculan como **unión** de roles
- [ ] La UI oculta lo que el rol no puede hacer
- [ ] La navegación usa `irAProtegido` / `RutaProtegida`
- [ ] El servidor revalida (la UI no es seguridad)

## 4. Integridad del negocio

- [ ] Las operaciones con dinero o stock usan transacción
- [ ] Los errores no dejan documentos a medias
- [ ] Los documentos con histórico no se borran (estado)
- [ ] Toda escritura relevante queda en `_auditoria`
- [ ] Los cálculos viven en `domain` (no en el widget)

## 5. Offline

- [ ] La pantalla funciona sin red y sincroniza al volver
- [ ] No se rompió la persistencia local de Firestore
- [ ] La caché se limpia al cerrar sesión
- [ ] Los errores de permisos **no** usan la caché

## 6. Formato y calidad

- [ ] Fechas con `core/formato/fechas.dart` (sin `intl`)
- [ ] Cifras con `formatearValor` (miles con punto, decimales con coma)
- [ ] Correos con `esCorreoValido`
- [ ] `flutter analyze` sin errores
- [ ] `flutter test` todo en verde
- [ ] Cada método y clase documentado en español (Principio 11)

## 7. Cierre

- [ ] `tasks.md` marcado
- [ ] `README.md` actualizado si cambió el alcance
- [ ] Commit con `tipo(alcance): descripción`
- [ ] Push a `origin` (`ventas`)
- [ ] Reglas desplegadas si cambiaron
