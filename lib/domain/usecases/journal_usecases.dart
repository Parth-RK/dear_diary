import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/domain/usecases/add_journal_entry.dart';
import 'package:dear_diary/domain/usecases/journal_entry_deletion.dart';
import 'package:dear_diary/domain/usecases/get_journal_entries.dart';
import 'package:dear_diary/domain/usecases/restore_journal_entry.dart';
import 'package:dear_diary/domain/usecases/update_journal_entry.dart';

class JournalUseCases {
  final AddJournalEntry _addJournalEntry;
  final JournalEntryDeletion _journalEntryDeletion;
  final GetJournalEntries _getJournalEntries;
  final RestoreJournalEntry _restoreJournalEntry;
  final UpdateJournalEntry _updateJournalEntry;

  JournalUseCases({
    required AddJournalEntry addJournalEntry,
    required JournalEntryDeletion journalEntryDeletion,
    required GetJournalEntries getJournalEntries,
    required RestoreJournalEntry restoreJournalEntry,
    required UpdateJournalEntry updateJournalEntry,
  })  : _addJournalEntry = addJournalEntry,
        _journalEntryDeletion = journalEntryDeletion,
        _getJournalEntries = getJournalEntries,
        _restoreJournalEntry = restoreJournalEntry,
        _updateJournalEntry = updateJournalEntry;

  Future<List<JournalEntry>> getJournalEntries() async {
    return await _getJournalEntries();
  }

  Future<JournalEntry?> getJournalEntryById(String id) async {
    return await _getJournalEntries.getById(id);
  }

  Future<void> addJournalEntry(JournalEntry entry) async {
    return await _addJournalEntry(entry);
  }

  Future<void> updateJournalEntry(JournalEntry entry) async {
    return await _updateJournalEntry(entry);
  }

  Future<void> moveEntryToTrash(String id) async {
    return await _journalEntryDeletion.moveToTrash(id);
  }

  Future<void> restoreEntry(String id) async {
    return await _restoreJournalEntry(id);
  }

  Future<void> deleteEntryPermanently(String id) async {
    return await _journalEntryDeletion.deletePermanently(id);
  }

  Future<List<JournalEntry>> getDeletedEntries() async {
    return await _getJournalEntries.getDeletedEntries();
  }

  Future<void> emptyTrash() async {
    return await _journalEntryDeletion.emptyTrash();
  }
}
