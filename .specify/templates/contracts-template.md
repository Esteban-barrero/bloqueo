# Contratos e Interfaces: <NOMBRE DE LA FUNCIONALIDAD>

- **ID:** <NNN> | **Fecha:** <YYYY-MM-DD>

---

## 1. Repositorios (Flutter)

> Firma pública que consume la capa de presentación. Documentar en español
> (Principio 11) y respetar el filtro por `empresaId`.

### `<Nombre>Repository`

| Método | Entrada | Salida | Reglas que aplica |
|---|---|---|---|
| `listar` | `{ filtros }` | `Stream<List<Entidad>>` | RN-... |
| `crear` | `Entidad` | `String id` | RN-..., auditoría |
| `actualizar` | `id`, `{ cambios }` | `void` | RN-... |

---

## 2. Cloud Functions

### `<nombreFuncion>`

- **Tipo:** callable | disparador | programada
- **Región:** `us-central1` | `southamerica-east1`
- **Autorización:** <rol y validación en servidor>
- **Entrada:** `{ ... }`
- **Salida:** `{ ... }`
- **Errores:** `unauthenticated`, `permission-denied`, `invalid-argument`, `failed-precondition`
- **Efectos:** <documentos que escribe y auditoría>

---

## 3. Reglas de Firestore

| Ruta | Leer | Crear | Actualizar | Borrar |
|---|---|---|---|---|
| `<coleccion>/{id}` | <rol + empresaId> | <...> | <...> | <...> |

> Verificar con **ID tokens reales** (el token de administrador ignora las reglas).

---

## 4. Storage

| Ruta | Leer | Escribir | Validaciones |
|---|---|---|---|
| `<ruta>/{archivo}` | ... | ... | tipo, peso, empresa |

---

## 5. Eventos y avisos

| Evento | Canal | Destinatario | Plantilla |
|---|---|---|---|
| ... | in-app / correo / WhatsApp | ... | ... |
