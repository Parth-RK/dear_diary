import 'package:flutter/material.dart';
import 'package:dear_diary/models/journal_entry.dart';
import 'package:dear_diary/repositories/journal_repository.dart';

class JournalProvider with ChangeNotifier {
  final JournalRepository _repository = JournalRepository();
  List<JournalEntry> _entries = [];

  List<JournalEntry> get entries => _entries;

  JournalProvider() {
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    await _repository.initialize();
    _entries = await _repository.getAllEntries(includeDeleted: false);
    notifyListeners();
  }

  Future<void> addEntry(JournalEntry entry) async {
    await _repository.addEntry(entry);
    _loadEntries();
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await _repository.updateEntry(entry);
    _loadEntries();
  }

  Future<void> deleteEntry(String id) async {
    await _repository.deleteEntry(id);
    _loadEntries();
  }

  Future<void> restoreEntry(String id) async {
    await _repository.restoreEntry(id);
    _loadEntries();
  }
}