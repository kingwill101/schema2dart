import 'package:schema2dart/src/generator.dart';
import 'package:test/test.dart';

void main() {
  test('default values for primitives appear in constructors', () {
    const schema = {
      'type': 'object',
      'properties': {
        'flag': {'type': 'boolean', 'default': true},
        'items': {
          'type': 'array',
          'items': {
            'type': 'object',
            'properties': {
              'name': {'type': 'string'},
              'done': {'type': 'boolean', 'default': false},
            },
            'required': ['name'],
          },
        },
      },
    };

    final generator = SchemaGenerator(options: const SchemaGeneratorOptions());
    final output = generator.generate(schema);

    expect(
      output,
      contains(
        'const RootSchema({\n    this.flag = true,\n    this.items,\n  });',
      ),
    );
    expect(output, contains("final flag = (json['flag'] as bool?) ?? true;"));
    expect(
      output,
      contains(
        'const Item({\n    this.done = false,\n    required this.name,\n  });',
      ),
    );
    expect(output, contains("final done = (json['done'] as bool?) ?? false;"));
  });

  test('default values for arrays and objects', () {
    const schema = {
      'type': 'object',
      'properties': {
        'tags': {
          'type': 'array',
          'items': {'type': 'string'},
          'default': ['a', 'b', 'c'],
        },
        'config': {
          'type': 'object',
          'default': {'key': 'value', 'count': 42},
        },
        'name': {'type': 'string', 'default': 'default-name'},
      },
    };

    final generator = SchemaGenerator(options: const SchemaGeneratorOptions());
    final output = generator.generate(schema);

    // Check array default in constructor
    expect(output, contains("this.tags = const ['a', 'b', 'c']"));

    // Check object default in constructor
    expect(
      output,
      contains("this.config = const {'key': 'value', 'count': 42}"),
    );

    // Check string default in constructor
    expect(output, contains("this.name = 'default-name'"));
  });
}
