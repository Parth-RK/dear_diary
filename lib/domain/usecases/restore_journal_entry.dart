import 'package:dear_diary/domain/repositories/journal_repository.dart';

class RestoreJournalEntry {
  final JournalRepository repository;

  RestoreJournalEntry(this.repository);

  Future<void> call(String id) async {
    return await repository.restoreJournalEntry(id);
  }
}
