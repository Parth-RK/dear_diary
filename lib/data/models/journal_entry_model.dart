import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';

part 'journal_entry_model.g.dart';

@HiveType(typeId: 0)
class JournalEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final DateTime lastModifiedAt;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String content;

  @HiveField(5)
  final List<String> images;

  @HiveField(6)
  final List<String> tags;

  @HiveField(7)
  final String mood;

  @HiveField(8)
  final bool isDeleted;

  @HiveField(9)
  final String location;

  JournalEntryModel({
    required this.id,
    required this.createdAt,
    required this.lastModifiedAt,
    required this.title,
    required this.content,
    this.images = const [],
    this.tags = const [],
    this.mood = '',
    this.isDeleted = false,
    this.location = '',
  });

  JournalEntry toEntity() {
    return JournalEntry(
      id: id,
      createdAt: createdAt,
      lastModifiedAt: lastModifiedAt,
      title: title,
      content: content,
      images: images,
      tags: tags,
      mood: mood,
      isDeleted: isDeleted,
      location: location,
    );
  }

  factory JournalEntryModel.fromEntity(JournalEntry entry) {
    return JournalEntryModel(
      id: entry.id,
      createdAt: entry.createdAt,
      lastModifiedAt: entry.lastModifiedAt,
      title: entry.title,
      content: entry.content,
      images: entry.images,
      tags: entry.tags,
      mood: entry.mood,
      isDeleted: entry.isDeleted,
      location: entry.location,
    );
  }

  JournalEntryModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
    String? title,
    String? content,
    List<String>? images,
    List<String>? tags,
    String? mood,
    bool? isDeleted,
    String? location,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      title: title ?? this.title,
      content: content ?? this.content,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      mood: mood ?? this.mood,
      isDeleted: isDeleted ?? this.isDeleted,
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JournalEntryModel &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.lastModifiedAt == lastModifiedAt &&
        other.title == title &&
        other.content == content &&
        other.mood == mood &&
        other.isDeleted == isDeleted &&
        other.location == location &&
        listEquals(other.images, images) &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      createdAt,
      lastModifiedAt,
      title,
      content,
      Object.hashAll(images),
      Object.hashAll(tags),
      mood,
      isDeleted,
      location,
    );
  }

  @override
  String toString() {
    return 'JournalEntryModel(id: $id, title: $title, createdAt: $createdAt)';
  }
}
