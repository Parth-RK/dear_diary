import 'package:hive/hive.dart';
import 'package:dear_diary/data/models/journal_entry_model.dart';

class HiveJournalDataSource {
  static const String _boxName = 'journal_entries';

  static Future<HiveJournalDataSource> create() async {
    // Check if box exists and open it safely
    Box<JournalEntryModel> box;
    try {
      if (Hive.isBoxOpen(_boxName)) {
        box = Hive.box<JournalEntryModel>(_boxName);
      } else {
        box = await Hive.openBox<JournalEntryModel>(_boxName);
      }
    } catch (e) {
      // If there's an error with the box, clear it and create a new one
      await Hive.deleteBoxFromDisk(_boxName);
      box = await Hive.openBox<JournalEntryModel>(_boxName);
    }
    
    return HiveJournalDataSource._(box);
  }

  final Box<JournalEntryModel> box;

  HiveJournalDataSource._(this.box);

  Future<List<JournalEntryModel>> getJournalEntries() async {
    try {
      return box.values.where((entry) => !entry.isDeleted).toList();
    } catch (e) {
      return Future.error(e);
    }
  }
  
  Future<JournalEntryModel?> getJournalEntryById(String id) async {
    try {
      return box.get(id);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> addJournalEntry(JournalEntryModel entry) async {
    try {
      await box.put(entry.id, entry);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> updateJournalEntry(JournalEntryModel entry) async {
    try {
      await box.put(entry.id, entry);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> deleteJournalEntry(String id) async {
    try {
      final entry = box.get(id);
      if (entry != null) {
        await box.put(id, entry.copyWith(isDeleted: true));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> restoreJournalEntry(String id) async {
    try {
      final entry = box.get(id);
      if (entry != null) {
        await box.put(id, entry.copyWith(isDeleted: false));
      }
    } catch (e) {
      return Future.error(e);
    }
  }
  
  Future<void> permanentlyDeleteJournalEntry(String id) async {
    try {
      await box.delete(id);
    } catch (e) {
      return Future.error(e);
    }
  }
  
  Future<List<JournalEntryModel>> getDeletedEntries() async {
    try {
      return box.values.where((entry) => entry.isDeleted).toList();
    } catch (e) {
      return Future.error(e);
    }
  }
}
