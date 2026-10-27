# Reglas de programación — Aplicativo de Ventas

> Cómo se escribe el código de este repositorio. Complementa la constitución
> (`.specify/memory/constitution.md`) y los ADR (`.specify/memory/adr/`).
>
> **Prioridad en caso de conflicto:** constitución → ADR → este documento →
> convención local de la spec. Si una regla de aquí contradice un ADR, gana el
> ADR y hay que corregir este documento.

---

## 1. Alcance

Aplica a **todo** el código versionado: `app/` (Dart/Flutter) y `functions/`
(TypeScript). No aplica a `build/`, `.dart_tool/` ni `node_modules/`.

---

## 2. Nomenclatura

| Elemento | Convención | Ejemplo |
|---|---|---|
| Archivos Dart | `snake_case.dart` | `pedido_detalle_screen.dart` |
| Clases | `UpperCamelCase`, en español si es del dominio | `MovimientoDinero`, `Pedido` |
| Métodos y variables | `lowerCamelCase` | `registrarMovimiento`, `saldoPorUbicacion` |
| Constantes | `lowerCamelCase` | `maximoFotos` |
| Colecciones Firestore | `snake_case` en plural | `movimientos_dinero`, `cuentas_por_pagar` |
| Campos Firestore | `lowerCamelCase` | `empresaId`, `montoDeclarado` |
| Archivos TS | `camelCase.ts` | `notificarPedido.ts` |

- **Identificadores en inglés solo cuando son técnicos** (`repository`,
  `controller`, `provider`); el dominio va en **español** (`Venta`, `Caja`,
  `Rendicion`). No mezclar dentro del mismo nombre.
- Nunca abreviaturas opacas: `mov`, `usr`, `emp`. Sí se aceptan las de dominio
  ya establecidas: `empresaId`, `uid`, `pct`.

---

## 3. Estructura y capas

```
lib/features/<feature>/
├── domain/        Entidades inmutables y reglas de negocio puras (sin Flutter)
├── data/          Repositorios: Firestore, Storage, serialización
└── presentation/  Pantallas y widgets (StatefulWidget)
```

- **`domain` no importa `package:flutter/*`** ni `cloud_firestore`. Debe poder
  probarse con `dart test` puro.
- **`presentation` no habla con Firestore directamente**: siempre pasa por un
  repositorio de `data`.
- Lo transversal va a `lib/core/` (formato, validación, errores, navegación).
- **Prohibido** crear utilidades nuevas si ya existe una en `core/`
  (ver §7 y §8).

**Antes de crear un archivo, pregúntate:** ¿ya existe algo que hace esto? Si la
respuesta es "creo que sí", búscalo (`grep`) antes de duplicarlo.

---

## 4. Estilo Dart

- Comillas **simples** (`'texto'`), salvo que el texto contenga una.
- **Siempre** declarar el tipo de retorno, también en `void` explícito.
- Preferir `final` en locales que no cambian.
- Imports ordenados: `dart:` → `package:` → relativos, separados por línea en
  blanco.
- Nada de `print` en código de producción: usar `debugPrint` o el registro de
  logs (spec 013).
- Un widget por archivo cuando la pantalla es grande; los widgets privados van
  en el mismo archivo con prefijo `_`.
- No usar `dynamic` salvo en fronteras de serialización (`Map<String, dynamic>`).

> **Formato (`dart format`) — deuda conocida (2026-10-21).** El código actual
> **no** está formateado con `dart format`: aplicarlo cambiaría ~193 de 226
> archivos. Por eso **no** se exige en cada commit ni en CI. Cuando se haga, debe
> ser un **commit aislado** (`chore(formato): aplicar dart format`) sin cambios
> de lógica, y solo entonces se activará la verificación.

---

## 5. Documentación (Principio 11)

- **Toda** clase, método y función —pública o privada— lleva comentario en
  **español**.
- API pública: docstring `///` con qué hace, parámetros, retorno y la
  spec/RF/RN/ADR que lo respalda.
- Métodos privados y bloques no obvios: comentario `//` explicando el **por qué**.
- No repetir lo que el código ya dice (`// incrementa i`). Explicar la intención,
  el caso borde o la regla de negocio.
- Todo `TODO` debe decir **qué falta** y **qué spec lo cubre**:
  `// TODO(010): enviar por Telegram cuando exista el bot.`

---

## 6. Errores y registro

- Los errores de Firebase se clasifican con `core/firebase/errores.dart`; no
  comparar códigos a mano en cada pantalla.
- **Un error de permisos nunca cae a la caché**; solo los de red
  (`unavailable`, `deadline-exceeded`, `network-request-failed`).
- *Fail-closed*: si no se puede verificar algo crítico (licencia), se **bloquea**,
  no se deja pasar.
- Los errores no esperados se registran en `logs_errores` (spec 013) con
  contexto suficiente para reproducirlos; nunca incluir contraseñas, tokens ni
  datos sensibles.
- No silenciar errores con `catch (_) {}`. Si se ignora, se comenta por qué.

---

## 7. Firestore: multi-tenant, dinero y auditoría

- **Toda** consulta y escritura filtra por `empresaId` (ADR-0001). El
  `empresaId` sale del perfil/claim, **nunca** de un parámetro del usuario.
- Operaciones que muevan **dinero o stock** van en `runTransaction` (ADR-0008).
  Nunca `update` de un saldo calculado en el cliente.
- Los documentos con histórico **no se borran**: estado (ADR-0007).
- Los libros (kardex, movimientos de dinero, auditoría) son **inmutables**;
  se corrige con un movimiento contrario (ADR-0009, ADR-0017).
- Toda escritura relevante deja rastro en `_auditoria` con la fecha del
  **servidor** (ADR-0010).
- Los montos se guardan como `number` en pesos enteros; el redondeo se hace una
  sola vez, al final del cálculo.
- No romper la persistencia offline: no usar `Source.server` salvo para datos
  que deban ser frescos (licencia, claims).

---

## 8. Estado y UI

- Patrón **`StatefulWidget` + repositorio**. Nada de Riverpod, Bloc ni Provider
  (ADR-0013).
- La pantalla guarda estado de presentación; **las reglas de negocio viven en
  `domain`**.
- Todo acceso a pantalla pasa por `irAProtegido` / `RutaProtegida`; la UI
  **oculta** acciones sin permiso (ADR-0002).
- Nunca usar `context` después de un `await` sin comprobar `mounted`.
- Mensajes al usuario en **español**, claros y sin tecnicismos.
- Formularios: validar en el `Form` y **volver a validar en el dominio**.

---

## 9. Formato de datos para el usuario

- Fechas: `core/formato/fechas.dart` (`dd/MM/yyyy`). **No** `intl`.
- Cifras y dinero: `formatearValor` (miles con punto, decimales con coma).
  Aplica a precios, descuentos, costos, subtotales, impuestos, totales y saldos.
- Correos: `esCorreoValido` (`core/validacion/correo.dart`). No basta con
  comprobar que el texto tenga `@`.
- Entradas de dinero: `entrada_miles.dart` para el separador de miles.

---

## 10. Pruebas

- Cada funcionalidad incluye pruebas; no se cierra una tarea sin ellas.
- **Dominio:** obligatorio (cálculos de precios, cuotas, mora, saldos).
- **Widget:** para pantallas con lógica de presentación (filtros, validaciones,
  estados vacíos).
- **Integración/emulador:** para transacciones de stock y reglas.
- Las pruebas son deterministas: sin fechas "de hoy" sin inyectar, sin red, sin
  depender del orden de ejecución.
- Nombre descriptivo en español: `test('no permite trasladar más que el saldo', ...)`.
- `flutter test` debe pasar **completo** antes del commit.

---

## 11. TypeScript / Cloud Functions

- JSDoc `/** ... */` en cada función exportada (Principio 11).
- Tipos explícitos en parámetros y retorno; evitar `any`.
- Las funciones programadas fijan zona horaria `America/Bogota`.
- Región: `us-central1` para callables y programadas; `southamerica-east1` para
  disparadores de Firestore.
- Validar **todo** lo que llega del cliente; el servidor no confía en la UI.
- No versionar secretos: credenciales SMTP y similares van en configuración o en
  `privado/` (Firestore) según corresponda.

> **Gate actual:** `tsc` con `strict`, `noImplicitReturns` y `noUnusedLocals`
> (`npm run build`, también en CI). **No** hay ESLint instalado; si se agrega,
> hay que ejecutar `npm install` para sincronizar `package-lock.json`, o `npm ci`
> fallará en CI.

---

## 12. Dependencias

- No agregar un paquete si se resuelve con lo que ya hay (ver `pubspec.yaml`).
- Antes de agregar: revisar mantenimiento, licencia, tamaño y soporte Web.
- Toda dependencia nueva se justifica en el `plan.md` de la spec.
- Prohibido `intl` para fechas (ver §9).

---

## 13. Git

- Ramas: `main` (producción), `develop` (desarrollo), `feature/<nombre>`.
- Commits: `tipo(alcance): descripción` en español.
  Tipos: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`.
- Un commit = un cambio coherente. No mezclar refactor con funcionalidad.
- No subir: `.env`, llaves, `serviceAccountKey.json`, `auth_usuarios*.json`,
  logs ni imágenes sueltas de la raíz.
- **Sí** se versionan `google-services.json` y `firebase_options.dart`
  (excepción documentada en `AGENTS.md` §4).

---

## 14. Definition of Done (único)

Una tarea está terminada cuando:

- [ ] Cumple los criterios de aceptación de su `spec.md`.
- [ ] `flutter analyze` sin errores.
- [ ] `flutter test` en verde.
- [ ] Cada método y clase documentado en español (Principio 11).
- [ ] Consultas y escrituras filtran por `empresaId`.
- [ ] Permisos validados en UI **y** en reglas.
- [ ] Escrituras de dinero/stock en transacción y auditadas.
- [ ] Fechas y cifras con los helpers de `core/formato/`.
- [ ] `tasks.md` actualizado y `checklist.md` de la spec completo.
- [ ] Commit y push; reglas desplegadas si cambiaron.

---

## 15. Cómo se verifica

| Regla | Verificación |
|---|---|
| Estilo y tipos | `flutter analyze` (el formato con `dart format` es deuda, ver §4) |
| Documentación | revisión en el `checklist.md` de la spec |
| Multi-tenant / RBAC | pruebas con ID tokens reales + revisión de reglas |
| Dinero / stock | pruebas de dominio y de emulador |
| Formato de cifras | `app/test/formato_test.dart` |
| Funcionalidad | `flutter test` y prueba manual según `quickstart.md` |

---

## 16. Reglas del analizador: estado

`app/analysis_options.yaml` activa: `always_declare_return_types`,
`unawaited_futures`, `avoid_print`, `prefer_final_locals`,
`prefer_single_quotes` y `directives_ordering`. Con eso, `flutter analyze`
termina en **0 issues**.

Queda **una** regla desactivada a propósito:

| Regla | Avisos (2026-10-21) | Para activarla |
|---|---|---|
| `public_member_api_docs` | 1257 | Documentar con `///` la API pública, empezando por `core/` y `domain/`. |

Y una deuda de herramientas (no es un lint):

| Herramienta | Alcance | Plan |
|---|---|---|
| `dart format` | 193 de 226 archivos cambiarían | Un commit aislado `chore(formato)` sin cambios de lógica; después se activa la verificación. |

**Procedimiento para activar una regla:** corregir sus avisos → descomentarla en
`analysis_options.yaml` → `flutter analyze` debe quedar en 0 → actualizar esta
tabla y el commit.

> Mientras `public_member_api_docs` siga desactivada, el Principio 11 se
> verifica en el `checklist.md` de cada spec.

