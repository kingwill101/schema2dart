## [Unreleased]

### Added
- **NEW**: Helper functions generation (`generateHelpers: true`) - Generates convenient `classNameFromJson(String)` and `classNameToJson(ClassName)` top-level functions for easy JSON parsing
- **NEW**: Usage documentation headers (`emitUsageDocs: true`) - Adds comprehensive usage examples to generated file headers
- **NEW**: Sealed class union types - `oneOf` and `anyOf` now generate type-safe sealed class hierarchies with exhaustive pattern matching
- **NEW**: Reserved keyword handling - Automatically escapes Dart reserved words (class, const, if, etc.) with `@JsonKey` annotations
- **NEW**: Mixed-type enum support - Heterogeneous enum values generate sealed class hierarchies

### Changed
- **IMPROVED**: Class name derivation from JSON Schema paths now filters out numeric array indices and union keywords (`oneOf`, `anyOf`, `allOf`). This produces more meaningful class names like `Config` instead of `Class2`, and `WorkflowCall` instead of `Class22WorkflowCall`.
- **IMPROVED**: Union types (`oneOf`/`anyOf`) now generate sealed classes instead of dynamic types for complete type safety
- **IMPROVED**: Enum handling supports mixed types (strings, numbers, booleans) with type-safe sealed class patterns
  
### Impact
- Schemas with `oneOf`/`anyOf`/`allOf` constructs will generate classes with better names
- Union types now provide compile-time type safety and exhaustive pattern matching
- Schemas with reserved keywords as property names now compile without errors
- Helper functions reduce boilerplate for common JSON operations
- Schemas with explicit `title` properties remain unchanged
- Simple schemas without unions remain unchanged
- Generated code will need to be regenerated to benefit from improved naming

### Migration
Regenerate your code with `dart run build_runner build --delete-conflicting-outputs`. Update any imports or references to renamed classes. Union types now use sealed classes instead of dynamic, requiring pattern matching for access. Since generated code is typically not committed and regenerated on build, this should be a smooth transition.

## 1.0.0

- Initial release of `schema2model` (formerly schemamodeschema).
