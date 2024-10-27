import 'package:flutter/material.dart';
import 'package:dear_diary/config/theme.dart';
import 'package:dear_diary/models/journal_entry.dart';
import 'package:dear_diary/repositories/journal_repository.dart';
import 'package:dear_diary/screens/editor/add_edit_note_page.dart';
import 'package:dear_diary/screens/home/widgets/journal_entry_card.dart';

import 'package:mongo_dart/mongo_dart.dart' as mongo;

class DaybookHomePage extends StatefulWidget {
  const DaybookHomePage({super.key});

  @override
  _DaybookHomePageState createState() => _DaybookHomePageState();
}

class _DaybookHomePageState extends State<DaybookHomePage> {
  final JournalRepository _repository = JournalRepository();
  List<JournalEntry> entries = [];

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    await _repository.initialize();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final loadedEntries = await _repository.getAllEntries();
    setState(() {
      entries = loadedEntries;
    });
  }

  Future<void> _addNewEntry(JournalEntry newEntry) async {
    await _repository.addEntry(newEntry);
    _loadEntries();
  }

  Future<void> _editEntry(JournalEntry updatedEntry) async {
    await _repository.updateEntry(updatedEntry);
    _loadEntries();
  }

  Future<void> _deleteEntry(mongo.ObjectId id) async {
    await _repository.deleteEntry(id);
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('daybook'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(entries[index].id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: AppColors.deleteColor,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
            ),
            onDismissed: (direction) {
              if (entries[index].id != null) {
                _deleteEntry(entries[index].id!);
              }
            },
            child: JournalEntryCard(
              entry: entries[index],
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOrEditNotePage(
                      existingEntry: entries[index],
                    ),
                  ),
                );
                if (result != null) {
                  _editEntry(result);
                }
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Theme(
      data: Theme.of(context).copyWith(
        bottomNavigationBarTheme: Theme.of(context).bottomNavigationBarTheme,
      ),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Daybook',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddOrEditNotePage()),
          );
          if (result != null) {
            _addNewEntry(result);
          }
        },
      ),
    );
  }
}
