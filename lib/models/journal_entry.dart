import 'package:mongo_dart/mongo_dart.dart';

class JournalEntry {
  final ObjectId? id;
  final DateTime date;
  final String content;
  final String? image;

  JournalEntry({
    this.id,
    required this.date,
    required this.content,
    this.image,
  });

  // Convert to Map for MongoDB
  Map<String, dynamic> toMap() {
    return {
      if (id != null) '_id': id,
      'date': date.toIso8601String(),
      'content': content,
      if (image != null) 'image': image,
    };
  }

  // Create from MongoDB document
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['_id'] as ObjectId?,
      date: DateTime.parse(map['date'] as String),
      content: map['content'] as String,
      image: map['image'] as String?,
    );
  }
}
