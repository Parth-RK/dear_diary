import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageUtils {
  Future<String> getNotesDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final notesDir = Directory('${directory.path}/MyNotes');
    if (!await notesDir.exists()) {
      await notesDir.create(recursive: true);
    }
    return notesDir.path;
  }

  Future<bool> requestStoragePermissions() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> saveMarkdownFile(String title, String content) async {
    final notesDir = await getNotesDirectory();
    final file = File('$notesDir/$title.md');
    await file.writeAsString(content);
  }

  Future<String?> readMarkdownFile(String title) async {
    final notesDir = await getNotesDirectory();
    final file = File('$notesDir/$title.md');
    if (await file.exists()) {
      return await file.readAsString();
    }
    return null;
  }

  Future<void> deleteMarkdownFile(String title) async {
    final notesDir = await getNotesDirectory();
    final file = File('$notesDir/$title.md');
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<List<File>> getAllMarkdownFiles() async {
    final notesDir = await getNotesDirectory();
    final directory = Directory(notesDir);
    
    if (!await directory.exists()) {
      return [];
    }
    
    final files = directory.listSync();
    return files
        .whereType<File>()
        .where((file) => file.path.endsWith('.md'))
        .toList();
  }
}
