import 'dart:io';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as universal_html;

class StorageUtils {
  Future<String> getNotesDirectory() async {
    if (kIsWeb) {
      // For web, we don't have a physical directory structure
      // Return a placeholder that won't be used for file operations
      return 'web_storage';
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final notesDir = Directory('${directory.path}/MyNotes');
      if (!await notesDir.exists()) {
        await notesDir.create(recursive: true);
      }
      return notesDir.path;
    }
  }

  Future<bool> requestStoragePermissions() async {
    if (kIsWeb) {
      // No need for explicit permissions on web
      return true;
    } else {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<void> saveMarkdownFile(String title, String content) async {
    if (kIsWeb) {
      // For web, store in localStorage
      universal_html.window.localStorage['journal_$title'] = content;
    } else {
      final notesDir = await getNotesDirectory();
      final file = File('$notesDir/$title.md');
      await file.writeAsString(content);
    }
  }

  Future<String?> readMarkdownFile(String title) async {
    if (kIsWeb) {
      // For web, read from localStorage
      return universal_html.window.localStorage['journal_$title'];
    } else {
      final notesDir = await getNotesDirectory();
      final file = File('$notesDir/$title.md');
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    }
  }

  Future<void> deleteMarkdownFile(String title) async {
    if (kIsWeb) {
      // For web, remove from localStorage
      universal_html.window.localStorage.remove('journal_$title');
    } else {
      final notesDir = await getNotesDirectory();
      final file = File('$notesDir/$title.md');
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<List<File>> getAllMarkdownFiles() async {
    if (kIsWeb) {
      // Web doesn't support File objects directly
      return [];
    } else {
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
  
  // Additional helper method to get all journal entries from localStorage on web
  Future<Map<String, String>> getAllWebEntries() async {
    if (!kIsWeb) return {};
    
    Map<String, String> entries = {};
    for (var i = 0; i < universal_html.window.localStorage.length; i++) {
      final key = universal_html.window.localStorage.keys.elementAt(i);
      if (key.startsWith('journal_')) {
        final title = key.substring(8); // Remove 'journal_' prefix
        final content = universal_html.window.localStorage[key] ?? '';
        entries[title] = content;
      }
    }
    return entries;
  }

  // Method to download a file on web
  void downloadFileOnWeb(String content, String fileName) {
    if (!kIsWeb) return;
    
    final blob = html.Blob([content], 'text/plain', 'native');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.Url.revokeObjectUrl(url);
  }
}
