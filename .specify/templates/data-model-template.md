# Modelo de Datos: <NOMBRE DE LA FUNCIONALIDAD>

- **ID:** <NNN> | **Fecha:** <YYYY-MM-DD>

---

## Convenciones

- Toda colección de negocio lleva **`empresaId`** (ADR-0001).
- Los documentos con histórico **no se borran**: usan estado (ADR-0007).
- `fecha` y marcas de tiempo usan `FieldValue.serverTimestamp()`.
- Los montos son `number` (no `string`) y se muestran con `formatearValor`.

---

## `<coleccion>/{<id>}`

<Para qué existe la colección y con qué otras se relaciona.>

| Campo | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| id | string | sí | Identificador |
| empresaId | string | sí | Empresa propietaria |
| ... | ... | ... | ... |

**Índices:** `<campo1>` + `<campo2>` (motivo de la consulta).
**Reglas:** quién puede leer / crear / actualizar / borrar y con qué condición.
**Inmutabilidad:** <si aplica, qué campos no se pueden modificar.>

---

## Subcolecciones

### `<padre>/{id}/<hijo>/{id}`

<Por qué es subcolección y no colección raíz (ADR-0014).>

---

## Relaciones

```
empresas/{empresaId}
  └── <coleccion>/{id}        (empresaId)
        └── <hijo>/{id}       (subcolección)
```

---

## Cálculos derivados

<Toda cifra que no se guarda y se calcula en `domain`, con su fórmula.>

```
<fórmula>
```

---

## Volumen y retención

- <Estimación de documentos por empresa y por mes.>
- <TTL o política de retención si aplica.>
