// lib/repositories/journal_repository.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dear_diary/models/journal_entry.dart';
import 'package:dear_diary/services/database_service.dart';

class JournalRepository {
  static const String _boxName = 'journal_entries';
  late Box<JournalEntry> _box;

  Future<void> initialize() async {
    // Initialize the database service if not already initialized
    await DatabaseService.initialize();
    
    // Get the box through the database service
    _box = await DatabaseService.instance.getBox<JournalEntry>(_boxName);
  }

  Future<void> addEntry(JournalEntry entry) async {
    await _box.put(entry.id, entry);
  }

  Future<void> updateEntry(JournalEntry entry) async {
    if (entry.id != null) {
      await _box.put(entry.id, entry);
    }
  }

  Future<void> deleteEntry(String id) async {
    await _box.delete(id);
  }

  Future<void> closeBox() async {
    if (_box.isOpen) {
      await _box.compact(); // Optimize the box
      await _box.close();
    }
  }
  Future<List<JournalEntry>> getAllEntries({bool includeDeleted = false}) async {
    return _box.values
        .where((entry) => includeDeleted ? entry.isDeleted : !entry.isDeleted)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> softDeleteEntry(String id) async {
    final entry = _box.get(id);
    if (entry != null) {
      entry.isDeleted = true;
      await _box.put(id, entry);
    }
  }

  Future<void> restoreEntry(String id) async {
    final entry = _box.get(id);
    if (entry != null) {
      entry.isDeleted = false;
      await _box.put(id, entry);
    }
  }

  Future<void> permanentlyDeleteEntry(String id) async {
    await _box.delete(id);
  }
}