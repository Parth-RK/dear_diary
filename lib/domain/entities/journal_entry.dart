import 'package:equatable/equatable.dart';

class JournalEntry extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  final String title;
  final String content;
  final List<String> images;
  final List<String> tags;
  final String mood;
  final bool isDeleted;
  final String location;

  const JournalEntry({
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

  JournalEntry copyWith({
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
    return JournalEntry(
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
  List<Object?> get props => [
        id,
        createdAt,
        lastModifiedAt,
        title,
        content,
        images,
        tags,
        mood,
        isDeleted,
        location,
      ];
}
