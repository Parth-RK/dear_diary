// lib/services/database_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dear_diary/models/journal_entry.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static bool _initialized = false;
  
  // Private constructor
  DatabaseService._();
  
  // Singleton instance
  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  // Initialize Hive
  static Future<void> initialize() async {
    if (_initialized) return;
    
    await Hive.initFlutter();
    
    // Register all adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(JournalEntryAdapter());
    }
    
    // Add any other initialization logic here
    
    _initialized = true;
  }

  // Get a box by name
  Future<Box<T>> getBox<T>(String boxName) async {
    if (!_initialized) {
      throw StateError('DatabaseService must be initialized before getting boxes');
    }
    
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    
    return Hive.box<T>(boxName);
  }

  // Close all boxes
  Future<void> closeBoxes() async {
    await Hive.close();
  }

  // Clear all data (useful for logout or reset scenarios)
  Future<void> clearAllData() async {
    await Hive.deleteFromDisk();
    _initialized = false;
  }
}