// lib/providers/entries_notifier.dart
import 'package:flutter/material.dart';
import 'package:dear_diary/models/journal_entry.dart';
import 'package:dear_diary/repositories/journal_repository.dart';

class EntriesNotifier extends ChangeNotifier {
  final JournalRepository _repository;
  List<JournalEntry> _entries = [];

  EntriesNotifier(this._repository) {
    _loadEntries();
  }

  List<JournalEntry> get entries => _entries.where((entry) => !entry.isDeleted).toList();

  Future<void> _loadEntries() async {
    _entries = await _repository.getAllEntries(includeDeleted: true);
    notifyListeners();
  }

  Future<void> addEntry(JournalEntry entry) async {
    await _repository.addEntry(entry);
    _entries.add(entry);
    notifyListeners();
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await _repository.updateEntry(entry);
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
      notifyListeners();
    }
  }

  Future<void> deleteEntry(String id) async {
    await _repository.softDeleteEntry(id);
    _loadEntries();
  }
}
