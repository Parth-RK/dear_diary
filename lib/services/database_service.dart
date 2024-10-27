import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  static DatabaseService? _instance;
  late Db _db;

  DatabaseService._();

  static Future<DatabaseService> get instance async {
    _instance ??= DatabaseService._();
    await _instance!._init();
    return _instance!;
  }

  Future<void> _init() async {
    _db = await Db.create('mongodb://your_connection_string');
    await _db.open();
  }

  DbCollection getCollection(String name) {
    return _db.collection(name);
  }

  Future<void> close() async {
    await _db.close();
  }
}
