import 'dart:convert';

import 'package:schema2dart_sample/schemas/todo_list.dart';

void main() {
  final sample = TodoList(
    name: 'Weekend tasks',
    tags: const ['urgent: errands', 'urgent: groceries', 'urgent: repairs'],
    items: [
      Item(title: 'Water plants'),
      Item(title: 'Restock pantry'),
      Item(title: 'Read a book', done: true),
    ],
    metadata: const Metadata(
      owner: 'Morgan',
      color: '#3366FF',
      reminder: MetadataReminder(
        time: '2024-05-01T09:00:00Z',
        channel: 'email',
        timezone: 'America/New_York',
      ),
    ),
  );

  sample.validate();
  final jsonString = const JsonEncoder.withIndent(
    '  ',
  ).convert(sample.toJson());
  print(jsonString);
}
