import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dear_diary/app/app.dart';
import 'package:dear_diary/di/service_locator.dart';
import 'package:dear_diary/data/models/journal_entry_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(DateTimeAdapter());
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(JournalEntryModelAdapter());
  }
  
  try {
    await Hive.openBox<JournalEntryModel>('journal_entries');
  } catch (e) {
    await Hive.deleteBoxFromDisk('journal_entries');
    await Hive.openBox<JournalEntryModel>('journal_entries');
  }
  
  await initServiceLocator();
  runApp(const DearDiaryApp());
}

// Define a DateTimeAdapter for Hive to use
class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final int typeId = 1; // Use a unique typeId

  @override
  DateTime read(BinaryReader reader) {
    final micros = reader.readInt();
    return DateTime.fromMicrosecondsSinceEpoch(micros);
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeInt(obj.microsecondsSinceEpoch);
  }
}
