# Project Status - Schema2Model

**Last Updated**: 2025-12-05  
**Test Status**: ✅ 141/141 tests passing

## Overview

Schema2Model is a comprehensive Dart code generator for JSON Schema with excellent JSON Schema support and modern Dart features.

## Completed Features ✅

### Core JSON Schema Support
- ✅ **Object schemas** with properties, required fields, additionalProperties
- ✅ **Array schemas** with items, uniqueItems
- ✅ **Primitive types**: string, number, integer, boolean, null
- ✅ **Type arrays**: `["string", "null"]` for nullable types
- ✅ **Enum support**: String enums with proper code generation
- ✅ **$ref resolution**: Local, cross-document, and pointer-based references
- ✅ **$id and $anchor** support for schema identification
- ✅ **allOf composition**: Merges schemas correctly
- ✅ **oneOf/anyOf unions**: Generates sealed classes for type-safe unions
- ✅ **Nested schemas**: Generates appropriate nested classes
- ✅ **Default values**: Generates initializers with default values

### Modern Dart Features
- ✅ **Sealed class unions**: Type-safe oneOf/anyOf with pattern matching
- ✅ **Null safety**: Full support for Dart 3.x null safety
- ✅ **json_serializable**: Integration with json_annotation
- ✅ **Reserved keyword handling**: Automatic escaping with @JsonKey
- ✅ **Immutable classes**: const constructors where applicable

### Code Generation Options
- ✅ **Helper functions**: Optional top-level fromJson/toJson helpers
- ✅ **Usage documentation**: Optional header comments with usage examples
- ✅ **Custom class names**: `root_class` option
- ✅ **Camel case conversion**: `prefer_camel_case` option
- ✅ **Documentation**: `emit_docs` option for schema descriptions
- ✅ **Single file output**: Combine all classes into one file

### OpenAPI Extensions
- ✅ **nullable keyword**: OpenAPI 3.0 nullable support
- ✅ **x-* extensions**: Preserved in generated code comments

### Content Keywords (Draft 7+)
- ✅ **contentEncoding**: base64, base16, base32, quoted-printable
- ✅ **contentMediaType**: Media type annotations
- ✅ **Uint8List generation**: For binary content
- ✅ **Automatic encoding/decoding**: In fromJson/toJson

### Advanced Features
- ✅ **Multiple dialect support**: Draft 2019-09, 2020-12, OpenAPI 3.0/3.1
- ✅ **Circular reference detection**: Prevents infinite recursion
- ✅ **Cross-document references**: Loads external schemas
- ✅ **Network schema caching**: Optional caching for HTTP refs
- ✅ **Custom document loaders**: Extensible schema resolution

## Test Coverage

### Test Suites
- ✅ `test/additionalproperties_test.dart` - Additional properties handling
- ✅ `test/conditional_constraints_test.dart` - if/then/else schemas
- ✅ `test/const_test.dart` - Const value support
- ✅ `test/cross_document_test.dart` - Cross-document $ref resolution
- ✅ `test/default_value_test.dart` - Default value generation
- ✅ `test/deprecation_test.dart` - Deprecated field handling
- ✅ `test/dynamic_ref_test.dart` - $dynamicRef resolution
- ✅ `test/enum_test.dart` - Enum generation
- ✅ `test/format_test.dart` - Format annotations (date-time, email, etc.)
- ✅ `test/generator_test.dart` - Core generator functionality
- ✅ `test/helper_functions_test.dart` - Helper function generation
- ✅ `test/identifiers_test.dart` - $id and $anchor resolution
- ✅ `test/json_pointer_test.dart` - JSON Pointer parsing
- ✅ `test/nullable_keyword_test.dart` - OpenAPI nullable support
- ✅ `test/options_test.dart` - Configuration options
- ✅ `test/reserved_keywords_test.dart` - Reserved keyword handling
- ✅ `test/union_test.dart` - oneOf/anyOf sealed class generation
- ✅ `test/usage_docs_test.dart` - Usage documentation generation
- ✅ `test/validation_helpers_test.dart` - Validation helper generation

**Total**: 141 tests, all passing ✅

## In Progress / Planned 🚧

### Mixed-Type Enums
**Priority**: High  
**Proposal**: `openspec/changes/add-mixed-type-enum-support/`

Currently, enums with mixed types (e.g., `["red", 1, true]`) fall back to `dynamic`. Should generate sealed classes similar to oneOf unions.

```dart
// Target:
sealed class Color {}
class ColorString extends Color { final String value; }
class ColorInt extends Color { final int value; }
class ColorBool extends Color { final bool value; }
```

### Validation Constraints
**Priority**: Medium  
**Proposal**: `openspec/changes/support-validation-constraints.md`

Generate validation helpers for:
- String: minLength, maxLength, pattern
- Number: minimum, maximum, multipleOf
- Array: minItems, maxItems
- Object: minProperties, maxProperties

### Content Schema Validation
**Priority**: Low  
**Proposal**: `openspec/changes/support-content-keywords/`

Task 7: Implement `contentSchema` validation for encoded content.

### Special Characters in Properties
**Priority**: Low  
**Proposal**: `openspec/changes/support-special-characters-in-properties.md`

Better handling of special characters in property names (unicode, spaces, etc.).

## Known Limitations

### Not Supported (By Design)
- ❌ **Schema validation**: We generate code, not a validator
- ❌ **Custom formats**: No validation for format keywords (use validators instead)
- ❌ **$comment preservation**: Comments in schema are not included in output

### Quicktype Comparison

Our generator is **fundamentally more correct** than Quicktype for JSON Schema:

| Feature | Us | Quicktype | Winner |
|---------|-----|-----------|--------|
| Nested Objects | ✅ Correct | ❌ Treats schema as data | **Us** |
| allOf Merging | ✅ Merges properly | ❌ Keeps raw structure | **Us** |
| oneOf/anyOf | ✅ Sealed classes | ❌ Treats as schema metadata | **Us** |
| References | ✅ Resolves correctly | ❌ Keeps raw refs | **Us** |
| Required Fields | ✅ Uses `required` | ✅ Uses `required` | Tie |
| Helper Functions | ✅ Optional | ✅ Yes | Tie |
| Usage Docs | ✅ Optional | ✅ Yes | Tie |

**Quicktype's JSON Schema support is broken** - it generates code to represent the schema structure rather than data that conforms to the schema.

## Configuration Options

### build.yaml Example

```yaml
targets:
  $default:
    builders:
      schema2model:
        options:
          # Class naming
          root_class: "MyRootClass"
          prefer_camel_case: true
          
          # Output
          single_file_output: false
          emit_docs: true
          
          # Ergonomics
          generate_helpers: true      # Top-level fromJson/toJson functions
          emit_usage_docs: true       # Usage examples in header
          
          # Content encoding
          enable_content_keywords: true
          
          # Schema resolution
          allow_network_refs: false
          network_cache_path: ".schema_cache"
          
          # Dialects
          default_dialect: "https://json-schema.org/draft/2020-12/schema"
```

## Architecture

### Key Components

1. **SchemaGenerator** (`lib/src/generator/schema_generator.dart`)
   - Entry point for code generation
   - Builds intermediate representation (IR)

2. **SchemaWalker** (`lib/src/generator/schema_walker.dart`)
   - Traverses schema graph
   - Resolves references
   - Handles $id, $anchor, $ref, $dynamicRef

3. **IR Models** (`lib/src/ir/`)
   - IrClass, IrEnum, IrUnion, IrMixedEnum
   - Type-safe representation of schema semantics

4. **Emitter** (`lib/src/emitter/dart_emitter.dart`)
   - Generates Dart source code from IR
   - Handles imports, formatting, documentation

5. **Builder** (`lib/src/schema_to_dart_builder.dart`)
   - build_runner integration
   - File discovery and output management

## Next Steps

### Immediate (Ready to implement)
1. ✅ Fix cross-document reference test (Done - was field name issue)
2. 🚧 Implement mixed-type enum support (High priority)
3. 📝 Update README.md with new features
4. 📝 Update CHANGELOG.md

### Short Term
1. 🚧 Add validation constraint generation
2. 📝 Create comprehensive examples
3. 📝 Write migration guide
4. 🧪 Performance testing for large schemas

### Long Term
1. Consider validation runtime library
2. OpenAPI 3.1 full feature parity
3. GraphQL schema support?
4. IDE plugin for schema preview

## Contributing

### Running Tests

```bash
# All tests
dart test

# Specific test file
dart test test/union_test.dart

# With coverage
dart test --coverage=coverage
genhtml coverage/lcov.info -o coverage/html
```

### Code Generation

```bash
# Run code generation on examples
cd example
dart run build_runner build --delete-conflicting-outputs
```

### Comparison Testing

```bash
cd comparison_tests
bash run_comparison.sh
dart test_our_generator.dart
```

## Resources

- [JSON Schema Specification](https://json-schema.org/)
- [OpenAPI Specification](https://swagger.io/specification/)
- [Learn JSON Schema](https://learnjsonschema.com/)
- [Dart json_serializable](https://pub.dev/packages/json_serializable)

## Maintainers

See CONTRIBUTORS.md for the list of contributors.

---

**Status**: ✅ Production Ready  
**Version**: See pubspec.yaml  
**License**: See LICENSE
