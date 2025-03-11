import 'package:hive/hive.dart';
import 'package:dear_diary/data/models/journal_entry_model.dart';

class HiveJournalDataSource {
  final String _boxName = 'journal_entries';
  late Box<JournalEntryModel> _journalBox;
  
  static Future<HiveJournalDataSource> create() async {
    final dataSource = HiveJournalDataSource._();
    await dataSource._init();
    return dataSource;
  }

  HiveJournalDataSource._();

  Future<void> _init() async {
    _journalBox = await Hive.openBox<JournalEntryModel>(_boxName);
  }

  Future<Box<JournalEntryModel>> get _box async =>
      _journalBox;

  // Create methods
  Future<void> createEntry(JournalEntryModel entry) async {
    final box = await _box;
    await box.put(entry.id, entry);
  }

  Future<void> addJournalEntry(JournalEntryModel entry) async {
    await createEntry(entry);
  }

  // Read methods
  Future<JournalEntryModel?> getEntryById(String id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<JournalEntryModel?> getJournalEntryById(String id) async {
    return getEntryById(id);
  }

  Future<List<JournalEntryModel>> getAllEntries() async {
    final box = await _box;
    return box.values.where((entry) => !entry.isDeleted).toList();
  }

  Future<List<JournalEntryModel>> getJournalEntries() async {
    return getAllEntries();
  }

  Future<List<JournalEntryModel>> getEntriesByDate(DateTime date) async {
    final box = await _box;
    return box.values
        .where((entry) =>
            !entry.isDeleted &&
            entry.createdAt.year == date.year &&
            entry.createdAt.month == date.month &&
            entry.createdAt.day == date.day)
        .toList();
  }

  Future<List<JournalEntryModel>> getDeletedEntries() async {
    final box = await _box;
    return box.values.where((entry) => entry.isDeleted).toList();
  }

  // Update methods
  Future<void> updateEntry(JournalEntryModel entry) async {
    final box = await _box;
    await box.put(entry.id, entry);
  }

  Future<void> updateJournalEntry(JournalEntryModel entry) async {
    await updateEntry(entry);
  }

  // Delete methods
  Future<void> deleteEntry(String id) async {
    final box = await _box;
    final entry = box.get(id);
    if (entry != null) {
      final updatedEntry = JournalEntryModel(
        id: entry.id,
        createdAt: entry.createdAt,
        lastModifiedAt: DateTime.now(),
        title: entry.title,
        content: entry.content,
        images: entry.images,
        tags: entry.tags,
        mood: entry.mood,
        isDeleted: true,
        location: entry.location,
      );
      await box.put(id, updatedEntry);
    }
  }

  Future<void> deleteJournalEntry(String id) async {
    await deleteEntry(id);
  }

  Future<void> markEntryAsDeleted(String id) async {
    await deleteEntry(id);
  }

  Future<void> permanentlyDeleteJournalEntry(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  Future<void> restoreJournalEntry(String id) async {
    final box = await _box;
    final entry = box.get(id);
    if (entry != null) {
      final updatedEntry = JournalEntryModel(
        id: entry.id,
        createdAt: entry.createdAt,
        lastModifiedAt: DateTime.now(),
        title: entry.title,
        content: entry.content,
        images: entry.images,
        tags: entry.tags,
        mood: entry.mood,
        isDeleted: false,
        location: entry.location,
      );
      await box.put(id, updatedEntry);
    }
  }

  // Utility methods
  Future<void> clearAllEntries() async {
    final box = await _box;
    await box.clear();
  }

  Future<int> getEntriesCount() async {
    final box = await _box;
    return box.length;
  }
}
