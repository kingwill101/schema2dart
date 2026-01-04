import 'dart:convert';
import 'dart:io';
import 'package:schema2model/src/generator.dart';
import 'package:test/test.dart';

void main() {
  test('generate workflow files', () {
    final schemaFile = File('example/schemas/github_workflow/schema.json');
    final schema = jsonDecode(schemaFile.readAsStringSync()) as Map<String, dynamic>;
    
    final generator = SchemaGenerator(
      options: SchemaGeneratorOptions(
        sourcePath: schemaFile.path,
      ),
    );
    
    final ir = generator.buildIr(schema);
    final plan = generator.planMultiFile(ir, baseName: 'schema');
    
    final outDir = Directory('example/schemas/github_workflow/schema_generated');
    if (outDir.existsSync()) {
      outDir.deleteSync(recursive: true);
    }
    outDir.createSync(recursive: true);
    
    // Write barrel file
    final barrelFile = File('example/schemas/github_workflow/schema.dart');
    barrelFile.writeAsStringSync(plan.barrel);
    print('Generated: schema.dart (barrel)');
    
    // Write all generated files
    plan.files.forEach((filename, content) {
      final file = File('${outDir.path}/$filename');
      file.writeAsStringSync(content);
      print('Generated: $filename');
    });
    
    print('\nTotal files: ${plan.files.length}');
  });
}
