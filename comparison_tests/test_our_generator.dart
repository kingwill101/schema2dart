import 'dart:io';
import 'dart:convert';
import 'package:schema2model/schema2model.dart';

void main() async {
  print('=== Testing Our Generator ===\n');

  final tests = [
    'nested_objects',
    'array_of_objects',
    'union_types',
    'anyOf_objects',
    'allOf_composition',
    'additional_properties',
    'definitions_refs',
  ];

  for (final test in tests) {
    await generateForTest(test);
  }

  print('\n=== Generation Complete ===');
}

Future<void> generateForTest(String testName) async {
  print('Generating $testName...');

  try {
    final schemaFile = File('schemas/$testName.json');
    final schemaJson = jsonDecode(await schemaFile.readAsString());

    final options = SchemaGeneratorOptions(
      rootClassName: toPascalCase(testName),
      emitDocumentation: true,
      emitValidationHelpers: false,
    );

    final generator = SchemaGenerator(options: options);
    final code = generator.generate(schemaJson);

    final outputFile = File('our_output/$testName.dart');
    await outputFile.writeAsString(code);

    print('  ✓ Generated our_output/$testName.dart');
  } catch (e) {
    print('  ✗ Error: $e');
  }
}

String toPascalCase(String input) {
  return input
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join('');
}
