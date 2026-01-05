# Build Runner Example

This example demonstrates how to use **schema2dart** with `build_runner` to automatically generate Dart code from JSON schemas during your build process.

## 🎯 What This Shows

- Setting up `build_runner` integration
- Enabling validation helper generation
- Using generated models in your application
- Runtime validation with error reporting

## 📁 Project Structure

```
build_runner_example/
├── pubspec.yaml              # Dependencies including schema2dart
├── build.yaml                # Generator configuration
├── lib/
│   └── schemas/
│       ├── todo_list.json    # Input JSON schema
│       ├── todo_list.dart    # Generated barrel file (auto)
│       └── todo_list_generated/
│           └── *.dart        # Generated classes (auto)
└── bin/
    └── main.dart             # Usage example
```

## 🚀 Quick Start

### 1. Install Dependencies

```bash
cd example/build_runner_example
dart pub get
```

### 2. Generate Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

This will:
- Find all `*.json` files under `lib/schemas/`
- Generate Dart classes with validation helpers
- Create a barrel file for easy imports

### 3. Run the Example

```bash
dart run bin/main.dart
```

You'll see:
- A valid TodoList being created and serialized
- Validation passing for valid data
- Validation catching errors in invalid data

## 📝 Key Files

### `pubspec.yaml`

```yaml
dependencies:
  schema2dart:
    path: ../../

dev_dependencies:
  build_runner: ^2.4.0
```

Uses a path dependency to the root package.

### `build.yaml`

```yaml
targets:
  $default:
    builders:
      schema2dart|schema_builder:
        options:
          emit_validation_helpers: true
          include_globs:
            - lib/schemas/**/*.json
        generate_for:
          - lib/schemas/**/*.json
```

**Key options:**
- `emit_validation_helpers: true` - Generate runtime validation
- `generate_for` - Only process schemas in `lib/schemas/`
- `include_globs` - Optional filter applied inside the builder

### `lib/schemas/todo_list.json`

A schema showcasing:
- `contains` with `minContains`/`maxContains`
- Required properties
- Type validation
- Array validation

### `bin/main.dart`

Shows how to:
- Import generated classes
- Create instances
- Serialize to JSON
- Run validation
- Handle validation errors

## 🔧 Configuration Options

You can customize generation in `build.yaml`:

```yaml
options:
  emit_validation_helpers: true    # Generate validate() methods
  single_file_output: false         # Split into multiple files
  emit_docs: true                   # Include doc comments
  include_globs:                    # Override input globs
    - lib/schemas/**/*.json
```

See [main README](../../README.md) for all options.

## 💡 Adding More Schemas

Just drop new `*.json` files into `lib/schemas/`:

```bash
# Add a new schema
echo '{"type": "object", ...}' > lib/schemas/user.json

# Regenerate
dart run build_runner build --delete-conflicting-outputs

# Import and use
import 'package:build_runner_example/schemas/user.dart';
```

## 🎓 What You'll Learn

1. **Build Integration**: Automatic code generation during development
2. **Validation**: Runtime validation with detailed error messages  
3. **Type Safety**: Strongly-typed Dart classes from schemas
4. **Serialization**: JSON encoding/decoding built-in
5. **Configuration**: Customizing generator behavior

## 📚 Next Steps

- Check out [../schema2dart_example.dart](../schema2dart_example.dart) for API usage
- See [../schemas/](../schemas/) for more schema examples
- Read [../../REFERENCE_GOVERNANCE.md](../../REFERENCE_GOVERNANCE.md) for security features

## 🐛 Troubleshooting

### Generator not finding schemas?

Check `generate_for` pattern in `build.yaml`.

### Build failing?

```bash
# Clean and rebuild
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Generated code has errors?

The schema might have issues. Validate it first:
```bash
# Use a JSON Schema validator
npm install -g ajv-cli
ajv validate -s lib/schemas/todo_list.json -d data.json
```
