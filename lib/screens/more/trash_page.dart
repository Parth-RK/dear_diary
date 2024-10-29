
// lib/screens/more/trash_page.dart
import 'package:flutter/material.dart';
import 'package:dear_diary/models/journal_entry.dart';
import 'package:dear_diary/repositories/journal_repository.dart';
import 'package:intl/intl.dart';
import 'package:dear_diary/config/theme.dart';


class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  final JournalRepository _repository = JournalRepository();
  List<JournalEntry> _deletedEntries = [];

  @override
  void initState() {
    super.initState();
    _loadDeletedEntries();
  }

  Future<void> _loadDeletedEntries() async {
    await _repository.initialize();
    final entries = await _repository.getAllEntries(includeDeleted: true);
    setState(() {
      _deletedEntries = entries.where((entry) => entry.isDeleted).toList();
    });
  }

  Future<void> _restoreEntry(String id) async {
    await _repository.restoreEntry(id);
    _loadDeletedEntries();
  }

  Future<void> _permanentlyDeleteEntry(String id) async {
    await _repository.permanentlyDeleteEntry(id);
    _loadDeletedEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
      ),
      body: _deletedEntries.isEmpty
          ? const Center(
              child: Text('No deleted entries'),
            )
          : ListView.builder(
              itemCount: _deletedEntries.length,
              itemBuilder: (context, index) {
                final entry = _deletedEntries[index];
                return Dismissible(
                  key: Key(entry.id ?? ''),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.restore, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: AppColors.deleteColor,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete_forever, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      _restoreEntry(entry.id!);
                    } else {
                      _permanentlyDeleteEntry(entry.id!);
                    }
                  },
                  child: ListTile(
                    title: Text(
                      DateFormat('MMM dd, yyyy - hh:mm a').format(entry.date),
                    ),
                    subtitle: Text(
                      entry.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
