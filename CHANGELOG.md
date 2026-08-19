## 1.0.2

- Fix `default` values on **array** properties whose item type is an enum or
  union (e.g. a `List<InputModality>` with `default: ["text", "image"]`):
  elements now convert through the item type (`.fromJson(...)`) instead of
  being emitted as raw untyped literals, which produced invalid Dart. Arrays
  containing only const-able literals still emit `const [...]`.

## 1.0.1

- Fix call sites for refs to unions with primitive variants (e.g. `string | int`
  like a JSON-RPC `RequestId`): `ObjectTypeRef.deserializeInline` no longer casts
  the wire value to a `Map`, which threw at runtime for primitive values. The raw
  value is now passed to the union's `fromJson(dynamic)`.
- Fix property keys containing `$` (e.g. `$schema`): generated string literals now
  escape the dollar instead of emitting Dart interpolation that referenced the
  local variable being declared.
- Both fixes are applied everywhere property keys are emitted: property access,
  `remaining.remove(...)`, `keys.contains(...)` heuristics, const-value matching,
  and validation-helper paths.

## 1.0.0

- Initial release.
