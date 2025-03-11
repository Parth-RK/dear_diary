import 'package:flutter/foundation.dart';
import 'package:dear_diary/data/datasources/local/hive_journal_datasource.dart';
import 'package:dear_diary/data/models/journal_entry_model.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/domain/repositories/journal_repository.dart';
import 'package:dear_diary/utils/storage_utils.dart';

class JournalRepositoryImpl implements JournalRepository {
  final HiveJournalDataSource localDataSource;
  final StorageUtils storageUtils;

  JournalRepositoryImpl({required this.localDataSource, required this.storageUtils});

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
    
    try {
      // Also save as markdown file (handles web differently)
      await storageUtils.saveMarkdownFile(entry.title, entry.content);
    } catch (e) {
      // Handle or log error but don't prevent the main operation
      if (kDebugMode) {
        print('Error saving to markdown file: $e');
      }
    }
  }

  @override
  Future<void> updateJournalEntry(JournalEntry entry) async {
    await localDataSource.updateJournalEntry(JournalEntryModel.fromEntity(entry));
    
    try {
      // Update markdown file
      await storageUtils.saveMarkdownFile(entry.title, entry.content);
    } catch (e) {
      // Handle or log error but don't prevent the main operation
      if (kDebugMode) {
        print('Error updating markdown file: $e');
      }
    }
  }

  @override
  Future<void> deleteJournalEntry(String id) async {
    final entry = await localDataSource.getJournalEntryById(id);
    if (entry != null) {
      await localDataSource.deleteJournalEntry(id);
    }
  }

  @override
  Future<void> restoreJournalEntry(String id) async {
    await localDataSource.restoreJournalEntry(id);
  }

  @override
  Future<void> deleteJournalEntryPermanently(String id) async {
    final entry = await localDataSource.getJournalEntryById(id);
    if (entry != null) {
      try {
        // Delete markdown file (handles web differently)
        await storageUtils.deleteMarkdownFile(entry.title);
      } catch (e) {
        // Handle or log error but continue with deletion
        if (kDebugMode) {
          print('Error deleting markdown file: $e');
        }
      }
      
      await localDataSource.permanentlyDeleteJournalEntry(id);
    }
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
      try {
        // Delete markdown file (handles web differently)
        await storageUtils.deleteMarkdownFile(entry.title);
      } catch (e) {
        // Handle or log error but continue with deletion
        if (kDebugMode) {
          print('Error deleting markdown file during trash emptying: $e');
        }
      }
      
      await localDataSource.permanentlyDeleteJournalEntry(entry.id);
    }
  }

  // New method to sync Hive entries with markdown files
  Future<void> syncEntriesWithMarkdownFiles() async {
    // Import markdown files to Hive
    final markdownFiles = await storageUtils.getAllMarkdownFiles();
    for (final file in markdownFiles) {
      final fileName = file.path.split('/').last.replaceAll('.md', '');
      final content = await file.readAsString();
      
      // Check if entry with this title exists
      bool entryExists = false;
      final entries = await localDataSource.getJournalEntries();
      for (var entry in entries) {
        if (entry.title == fileName) {
          entryExists = true;
          break;
        }
      }
      
      if (!entryExists) {
        // Create new entry
        final newEntry = JournalEntryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          lastModifiedAt: DateTime.now(),
          title: fileName,
          content: content,
          isDeleted: false,
        );
        
        await localDataSource.addJournalEntry(newEntry);
      }
    }
    
    // Export Hive entries to markdown files
    final entries = await localDataSource.getJournalEntries();
    for (final entry in entries) {
      await storageUtils.saveMarkdownFile(entry.title, entry.content);
    }
  }
}
