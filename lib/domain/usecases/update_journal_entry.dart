import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/domain/repositories/journal_repository.dart';

class UpdateJournalEntry {
  final JournalRepository repository;

  UpdateJournalEntry(this.repository);

  Future<void> call(JournalEntry entry) async {
    return await repository.updateJournalEntry(entry);
  }
}
