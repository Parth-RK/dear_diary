import 'package:dear_diary/data/datasources/local/hive_journal_datasource.dart';
import 'package:dear_diary/data/models/journal_entry_model.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/domain/repositories/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  final HiveJournalDataSource localDataSource;

  JournalRepositoryImpl({required this.localDataSource});

  @override
  Future<List<JournalEntry>> getJournalEntries() async {
    final entries = await localDataSource.getJournalEntries();
    return entries.map((model) => model.toEntity()).toList();
  }

  @override
  Future<JournalEntry?> getJournalEntryById(String id) async {
    final entry = await localDataSource.getJournalEntryById(id);
    return entry?.toEntity();
  }

  @override
  Future<void> addJournalEntry(JournalEntry entry) async {
    await localDataSource.addJournalEntry(JournalEntryModel.fromEntity(entry));
  }

  @override
  Future<void> updateJournalEntry(JournalEntry entry) async {
    await localDataSource.updateJournalEntry(JournalEntryModel.fromEntity(entry));
  }

  @override
  Future<void> deleteJournalEntry(String id) async {
    await localDataSource.deleteJournalEntry(id);
  }

  @override
  Future<void> restoreJournalEntry(String id) async {
    await localDataSource.restoreJournalEntry(id);
  }

  @override
  Future<void> deleteJournalEntryPermanently(String id) async {
    await localDataSource.permanentlyDeleteJournalEntry(id);
  }

  @override
  Future<List<JournalEntry>> getDeletedEntries() async {
    final entries = await localDataSource.getDeletedEntries();
    return entries.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> emptyTrash() async {
    final deletedEntries = await localDataSource.getDeletedEntries();
    for (final entry in deletedEntries) {
      await localDataSource.permanentlyDeleteJournalEntry(entry.id);
    }
  }
}
