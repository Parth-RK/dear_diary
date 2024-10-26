import 'package:mongo_dart/mongo_dart.dart';
import 'package:dear_diary/models/journal_entry.dart';
import 'package:dear_diary/services/database_service.dart';

class JournalRepository {
  late DbCollection _collection;
  static const String collectionName = 'journal_entries';

  Future<void> initialize() async {
    final db = await DatabaseService.instance;
    _collection = db.getCollection(collectionName);
  }

  Future<List<JournalEntry>> getAllEntries() async {
    final documents = await _collection.find().toList();
    return documents.map((doc) => JournalEntry.fromMap(doc)).toList();
  }

  Future<void> addEntry(JournalEntry entry) async {
    await _collection.insert(entry.toMap());
  }

  Future<void> updateEntry(JournalEntry entry) async {
    if (entry.id == null) return;
    await _collection.update(
      where.id(entry.id!),
      entry.toMap(),
    );
  }

  Future<void> deleteEntry(ObjectId id) async {
    await _collection.remove(where.id(id));
  }
}
