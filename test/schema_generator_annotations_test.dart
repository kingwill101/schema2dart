import 'package:schemamodeschema/src/generator.dart';
import 'package:test/test.dart';

void main() {
  group('unevaluatedProperties', () {
    test('collects typed map when schema provided', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'known': {'type': 'string'},
        },
        'unevaluatedProperties': {'type': 'integer'},
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final ir = generator.buildIr(schema);
      final root = ir.rootClass;

      final field = root.unevaluatedPropertiesField;
      expect(field, isNotNull);
      expect(field!.valueType, isA<PrimitiveTypeRef>());
      expect(
        field.valueType.dartType(),
        equals(const PrimitiveTypeRef('int').dartType()),
      );

      final generated = generator.generate(schema);
      expect(
        generated,
        contains('final Map<String, int>? ${field.fieldName};'),
      );
      expect(generated, contains('Map<String, int>? ${field.fieldName}Value;'));
    });

    test('sets disallow flag when keyword is false', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'known': {'type': 'string'},
        },
        'unevaluatedProperties': false,
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final ir = generator.buildIr(schema);
      final root = ir.rootClass;

      expect(root.unevaluatedPropertiesField, isNull);
      expect(root.disallowUnevaluatedProperties, isTrue);

      final generated = generator.generate(schema);
      expect(generated, contains('Unexpected unevaluated properties'));
    });
  });

  group('unevaluatedItems', () {
    test('captures array metadata for downstream validation', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'values': {
            'type': 'array',
            'prefixItems': [
              {'type': 'string'},
            ],
            'unevaluatedItems': {'type': 'integer'},
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(),
      );
      final ir = generator.buildIr(schema);
      final root = ir.rootClass;
      final values = root.properties.singleWhere(
        (prop) => prop.jsonName == 'values',
      );

      final typeRef = values.typeRef;
      expect(typeRef, isA<ListTypeRef>());
      final list = typeRef as ListTypeRef;
      expect(list.prefixItemTypes, hasLength(1));
      expect(list.prefixItemTypes.first, isA<PrimitiveTypeRef>());
      expect(list.allowAdditionalItems, isTrue);
      expect(list.itemsEvaluatesAdditionalItems, isFalse);
      expect(list.unevaluatedItemsType, isA<PrimitiveTypeRef>());
      expect(list.disallowUnevaluatedItems, isFalse);

      generator.generate(schema);
    });
  });

  group('contains', () {
    test('enforces min and max matches', () {
      const schema = <String, dynamic>{
        'type': 'object',
        'properties': {
          'values': {
            'type': 'array',
            'contains': {'type': 'string'},
            'minContains': 2,
            'maxContains': 3,
          },
        },
      };

      final generator = SchemaGenerator(
        options: const SchemaGeneratorOptions(emitValidationHelpers: true),
      );
      final generated = generator.generate(schema);

      expect(
        generated,
        contains('Expected at least 2 item(s) matching \\"contains\\"'),
      );
      expect(
        generated,
        contains('Expected at most 3 item(s) matching \\"contains\\"'),
      );
    });
  });
}
