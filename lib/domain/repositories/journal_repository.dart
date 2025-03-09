import 'package:dear_diary/domain/entities/journal_entry.dart';

abstract class JournalRepository {
  Future<List<JournalEntry>> getJournalEntries();
  
  Future<JournalEntry?> getJournalEntryById(String id);
  
  Future<void> addJournalEntry(JournalEntry entry);
  
  Future<void> updateJournalEntry(JournalEntry entry);
  
  Future<void> deleteJournalEntry(String id);
  
  Future<void> restoreJournalEntry(String id);
  
  Future<void> deleteJournalEntryPermanently(String id);
  
  Future<List<JournalEntry>> getDeletedEntries();
  
  Future<void> emptyTrash();
}
