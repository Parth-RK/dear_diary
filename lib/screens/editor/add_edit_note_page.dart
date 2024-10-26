import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dear_diary/models/journal_entry.dart';

class AddOrEditNotePage extends StatefulWidget {
  final JournalEntry? existingEntry;

  const AddOrEditNotePage({super.key, this.existingEntry});

  @override
  _AddOrEditNotePageState createState() => _AddOrEditNotePageState();
}

class _AddOrEditNotePageState extends State<AddOrEditNotePage> {
  final _contentController = TextEditingController();
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    if (widget.existingEntry != null) {
      _currentDate = widget.existingEntry!.date;
      _contentController.text = widget.existingEntry!.content;
    } else {
      _currentDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingEntry == null ? 'Add New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_contentController.text.isNotEmpty) {
                Navigator.pop(
                  context,
                  JournalEntry(
                    id: widget.existingEntry?.id,
                    date: _currentDate,
                    content: _contentController.text,
                    image: widget.existingEntry?.image,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DateFormat('dd MMM yyyy').format(_currentDate)}, ${DateFormat('EEEE').format(_currentDate)}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(_currentDate),
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Write your note here...',
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
