# JSON Schema to Dart - TODO List

Generated: 2025-12-05

## Critical Issues (High Priority)

### 1. ❌ OneOf/AnyOf Union Type Handling
**Current State**: We generate `dynamic` types for oneOf/anyOf, losing all type safety.

**Example Problem**:
```dart
// Our output (wrong):
class UnionTypes {
  final dynamic value;  // ❌ No type safety
}

// Should be (like quicktype):
// Generate sealed classes with discriminated unions
```

**Required**:
- [ ] Generate sealed classes for oneOf/anyOf/allOf
- [ ] Implement discriminator logic based on:
  - `const` values (highest priority)
  - Required properties
  - Property name differences
- [ ] Add ambiguity detection and error messages
- [ ] Support nested unions

**Proposal**: `openspec/improve-union-type-generation.md`

---

### 2. ❌ Enum Support
**Current State**: Enums are completely ignored.

**Required**:
- [ ] String enums → Dart `enum`
- [ ] Mixed-type enums → sealed classes (like quicktype)
- [ ] Preserve enum value documentation
- [ ] Handle const enums

**Example**:
```json
{"enum": ["active", "inactive", "pending"]}
```
Should generate:
```dart
enum Status {
  active,
  inactive,
  pending
}
```

**Proposal**: `openspec/support-enum-sealed-classes.md` (created)

---

### 3. ⚠️ Nullable Type Handling
**Current State**: We use `T?` for optional properties but don't properly handle `type: [T, "null"]`.

**Required**:
- [ ] Detect `type: ["string", "null"]` and generate `String?`
- [ ] Support `nullable: true` (OpenAPI extension)
- [ ] Handle combinations with default values

---

### 4. ⚠️ Class Naming Issues
**Current State**: Classes get numeric prefixes like `Class22WorkflowCall`.

**Root Cause**: Anonymous schemas get auto-generated names that collide.

**Required**:
- [ ] Better naming heuristics for anonymous schemas
- [ ] Use property names as hints
- [ ] Detect and resolve naming conflicts
- [ ] Remove numeric prefixes unless truly necessary

---

## Feature Gaps (Medium Priority)

### 5. ⚠️ AllOf Composition
**Current State**: Basic support exists but not tested.

**Required**:
- [ ] Comprehensive allOf tests
- [ ] Merge properties correctly
- [ ] Handle conflicting property types
- [ ] Support allOf with $ref

---

### 6. ⚠️ Content Encoding/Media Type
**Current State**: Partially implemented but not complete.

**Required**:
- [x] contentMediaType support
- [x] contentEncoding: base64
- [ ] contentEncoding: base16
- [ ] contentEncoding: base32
- [ ] contentEncoding: quoted-printable
- [ ] contentSchema validation
- [ ] Integration tests

**Proposal**: `openspec/support-content-keywords.md` (created)

---

### 7. ❌ Pattern Properties
**Current State**: Not supported at all.

**Required**:
- [ ] Generate `Map<String, T>` for pattern properties
- [ ] Combine with additionalProperties
- [ ] Validate regex patterns

**Example**:
```json
{
  "patternProperties": {
    "^[a-z]+$": {"type": "string"}
  }
}
```

---

### 8. ❌ Conditional Schemas (if/then/else)
**Current State**: Not supported.

**Required**:
- [ ] Parse if/then/else keywords
- [ ] Generate appropriate validation logic
- [ ] Document limitations

---

### 9. ⚠️ ReadOnly/WriteOnly
**Current State**: Parsed but not used in code generation.

**Required**:
- [ ] Add `@JsonKey(readOnly: true)` annotations
- [ ] Generate separate request/response classes
- [ ] Document usage patterns

---

### 10. ❌ Format Validation
**Current State**: Format strings are ignored.

**Required**:
- [ ] date-time → DateTime
- [ ] date → DateTime (date only)
- [ ] uri/email → String with validation
- [ ] uuid → String with pattern
- [ ] Custom format handlers

---

## JSON Schema Standard Compliance

### 11. ⚠️ Anchors and Dynamic References
**Current State**: Basic $anchor support exists.

**Required**:
- [ ] Test $anchor resolution
- [ ] Support $dynamicAnchor
- [ ] Support $dynamicRef
- [ ] Cross-file anchor references

---

### 12. ❌ Unevaluated Properties/Items
**Current State**: Not implemented.

**Required**:
- [ ] unevaluatedProperties support
- [ ] unevaluatedItems support
- [ ] Interaction with anyOf/allOf

---

### 13. ⚠️ Numeric Constraints
**Current State**: Partially documented in comments.

**Required**:
- [ ] minimum/maximum validation
- [ ] multipleOf validation
- [ ] exclusiveMinimum/exclusiveMaximum
- [ ] Runtime or build-time checks?

---

### 14. ⚠️ String Constraints
**Current State**: Partially documented in comments.

**Required**:
- [ ] minLength/maxLength validation
- [ ] pattern (regex) validation
- [ ] Build-time vs runtime strategy

---

### 15. ⚠️ Array Constraints
**Current State**: Partially supported.

**Required**:
- [ ] minItems/maxItems
- [ ] uniqueItems
- [ ] prefixItems (tuple validation)
- [ ] contains

---

## Code Quality Improvements

### 16. ⚠️ Better Documentation Generation
**Current State**: Basic comments only.

**Required**:
- [ ] Generate DartDoc from schema descriptions
- [ ] Include examples in docs
- [ ] Document constraints clearly
- [ ] Add @deprecated annotations

---

### 17. ⚠️ Serialization Improvements
**Current State**: Custom toJson/fromJson implementation.

**Required**:
- [ ] Option to use json_serializable
- [ ] Support freezed
- [ ] Custom serialization hooks
- [ ] Performance optimization

---

### 18. ⚠️ Error Messages
**Current State**: Generic errors during generation.

**Required**:
- [ ] Better error messages with schema path
- [ ] Warnings for unsupported features
- [ ] Suggestions for fixes
- [ ] --strict mode to fail on warnings

---

### 19. ⚠️ Testing
**Current State**: Basic tests exist.

**Required**:
- [x] Content encoding tests
- [x] Enum tests
- [x] Nullable tests
- [ ] Union type tests
- [ ] AllOf/anyOf/oneOf tests
- [ ] Pattern properties tests
- [ ] Conditional schema tests
- [ ] Integration tests with real schemas

---

### 20. ⚠️ Performance
**Required**:
- [ ] Profile large schema processing
- [ ] Optimize walker algorithm
- [ ] Cache parsed schemas
- [ ] Parallel processing for multiple schemas

---

## Comparison with Quicktype

### What Quicktype Does Better:
1. ✅ **Union types**: Proper sealed classes with discriminators
2. ✅ **Enums**: Full support including mixed types
3. ✅ **Naming**: Better heuristics for anonymous schemas
4. ✅ **Top-level helpers**: Generated `fromJson`/`toJson` functions
5. ✅ **Null safety**: Proper handling of nullable unions

### What We Do Better:
1. ✅ **Const constructors**: Our classes use const
2. ✅ **Null safety**: Native Dart null safety (not just `?`)
3. ✅ **AnyOf detection**: We attempt discriminated unions (though incomplete)
4. ✅ **Build integration**: Works with build_runner
5. ✅ **Remaining properties tracking**: We track unused keys

### Feature Parity Needed:
- [ ] Union type generation (Critical!)
- [ ] Enum support (Critical!)
- [ ] Better naming (High priority)
- [ ] Top-level helper functions (Nice to have)

---

## Documentation TODO

### 21. Update README
- [ ] Add feature matrix (supported vs unsupported)
- [ ] Comparison with quicktype
- [ ] Migration guide from quicktype
- [ ] Known limitations section
- [ ] Performance characteristics

### 22. Update LIMITATIONS.md
- [ ] Document all unsupported keywords
- [ ] Explain workarounds
- [ ] Link to proposals for planned features

### 23. Create COMPARISON.md
- [ ] Detailed comparison with quicktype
- [ ] When to use each tool
- [ ] Feature matrix

---

## Priority Order

### Phase 1 (Urgent - breaks type safety):
1. Union types (oneOf/anyOf) → sealed classes
2. Enum support
3. Fix class naming

### Phase 2 (Important - missing features):
4. Nullable type handling
5. AllOf composition
6. Pattern properties
7. Format validation

### Phase 3 (Nice to have):
8. Content encoding completion
9. Conditional schemas
10. Constraint validation

### Phase 4 (Polish):
11. Better docs
12. Error messages
13. Performance
14. Testing

---

## Quick Wins (Easy fixes):
- [ ] Remove numeric class prefixes where possible
- [ ] Add top-level helper functions like quicktype
- [ ] Better default values handling
- [ ] Improve comment generation

---

## Notes from Comparison

### Union Types Schema:
```json
{
  "oneOf": [
    {"type": "string"},
    {"type": "number"}
  ]
}
```

**Quicktype output**: Wraps in classes, still not ideal
**Our output**: `dynamic` (wrong)
**Needed**: Sealed class with proper variants

### AnyOf Objects Schema:
**Quicktype output**: Wraps schema metadata, not actual data
**Our output**: Proper sealed classes with discriminators! 🎉
**Status**: We actually do this BETTER than quicktype!

### Key Insight:
Our anyOf handling is actually quite good! We generate proper sealed classes with discriminated unions. We just need to:
1. Apply the same logic to oneOf
2. Add comprehensive tests
3. Document the behavior

---

## Action Items for Next Session:
1. Create proposal for oneOf/allOf support (reusing anyOf logic)
2. Implement enum support with sealed classes
3. Fix class naming heuristics
4. Add comprehensive union type tests
5. Update README with feature matrix
