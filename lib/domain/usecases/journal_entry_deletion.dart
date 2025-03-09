import 'package:dear_diary/domain/repositories/journal_repository.dart';

class JournalEntryDeletion {
  final JournalRepository repository;

  JournalEntryDeletion(this.repository);

  /// Moves an entry to trash (soft delete)
  Future<void> moveToTrash(String id) async {
    return await repository.deleteJournalEntry(id);
  }

  /// Permanently deletes an entry
  Future<void> deletePermanently(String id) async {
    return await repository.deleteJournalEntryPermanently(id);
  }

  /// Empties the trash by permanently deleting all entries marked as deleted
  Future<void> emptyTrash() async {
    return await repository.emptyTrash();
  }
}
