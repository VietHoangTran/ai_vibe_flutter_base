# API Contract: <feature or endpoint group>

> Copy this template to `docs/specs/<NNNN>-api-contract.md` when a feature
> integrates an API. Generate models/datasources from this contract instead of
> guessing field names. If a real OpenAPI/Swagger spec exists, link it and only
> record deltas here.

## Base

- Base URL source: `AppConfig` (env define) — never hardcode
- Auth: Bearer token via `AuthInterceptor` | none
- Content type: `application/json`

## Endpoints

### <METHOD> <path>

Purpose: <one line>

Request:

```json
{
  "field": "type/example"
}
```

Response 200:

```json
{
  "field": "type/example"
}
```

Errors:

| Status | Body / code | App behavior |
| --- | --- | --- |
| 401 | — | token refresh flow, then sign-out on failure |
| 422 | `{ "errors": { ... } }` | field-level validation messages |
| 5xx | — | friendly retry state via `AsyncValueView` |

Notes:

- Nullable fields: <list>
- Pagination: <none / page+limit / cursor>

## Mapping

| API field | DTO (data/models) | Domain entity field |
| --- | --- | --- |
| `user_name` | `userName` | `name` |
