import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/domain/repositories/journal_repository.dart';

class GetJournalEntries {
  final JournalRepository repository;

  GetJournalEntries(this.repository);

  Future<List<JournalEntry>> call() async {
    return await repository.getJournalEntries();
  }
  
  Future<JournalEntry?> getById(String id) async {
    return await repository.getJournalEntryById(id);
  }
  
  Future<List<JournalEntry>> getDeletedEntries() async {
    return await repository.getDeletedEntries();
  }
}
