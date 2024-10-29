// lib/models/journal_entry.dart
import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String content;

  @HiveField(3)
  String? image;

  JournalEntry({
    this.id,
    required this.date,
    required this.content,
    this.image,
  }) {
    id ??= DateTime.now().microsecondsSinceEpoch.toString();
  }

  // Helper method to convert to Map (if needed for other parts of the app)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'content': content,
      if (image != null) 'image': image,
    };
  }

  // Helper method to create from Map (if needed for other parts of the app)
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String?,
      date: DateTime.parse(map['date'] as String),
      content: map['content'] as String,
      image: map['image'] as String?,
    );
  }
}