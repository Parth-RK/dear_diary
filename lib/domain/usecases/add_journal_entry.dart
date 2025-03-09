import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/domain/repositories/journal_repository.dart';

class AddJournalEntry {
  final JournalRepository repository;

  AddJournalEntry(this.repository);

  Future<void> call(JournalEntry entry) async {
    return await repository.addJournalEntry(entry);
  }
}
