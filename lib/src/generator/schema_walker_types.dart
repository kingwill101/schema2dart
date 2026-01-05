part of 'package:schema2dart/src/generator.dart';

class _SchemaCacheKey {
  _SchemaCacheKey(Uri uri, this.pointer) : uriKey = _normalizeUri(uri);

  final String uriKey;
  final String pointer;

  @override
  int get hashCode => Object.hash(uriKey, pointer);

  @override
  bool operator ==(Object other) {
    return other is _SchemaCacheKey &&
        other.uriKey == uriKey &&
        other.pointer == pointer;
  }

  static String _normalizeUri(Uri uri) {
    final raw = uri.toString();
    final hashIndex = raw.indexOf('#');
    if (hashIndex == -1) {
      return raw;
    }
    return raw.substring(0, hashIndex);
  }
}

class _SchemaLocation {
  const _SchemaLocation({required this.uri, required this.pointer});

  final Uri uri;
  final String pointer;
}

class _ResolvedSchema {
  const _ResolvedSchema({required this.schema, required this.location});

  final Map<String, dynamic>? schema;
  final _SchemaLocation location;
}

class _DynamicScopeEntry {
  const _DynamicScopeEntry({required this.name, required this.location});

  final String name;
  final _SchemaLocation location;
}
