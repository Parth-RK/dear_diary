// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daybook',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
        ),
      ),
      home: const DaybookHomePage(),
    );
  }
}

class DaybookHomePage extends StatefulWidget {
  const DaybookHomePage({super.key});

  @override
  _DaybookHomePageState createState() => _DaybookHomePageState();
}

class _DaybookHomePageState extends State<DaybookHomePage> {
  List<JournalEntry> entries = [
    JournalEntry(
      date: DateTime(2020, 3, 4),
      content: "I'm on the last day of my Japan trip, and that makes me rather sad. Although I still got a night,",
      image: 'assets/japan_trip.jpg',
    ),
    JournalEntry(
      date: DateTime(2020, 3, 3),
      content: "I recalled every experience, every encounter almost as if I was witnessing it again and yet I don't have the words to express my",
    ),
    JournalEntry(
      date: DateTime(2020, 3, 1),
      content: "Today, as i was clearing up all the junk from my cupboards I came across my prized collections from when i was a kid (probably",
    ),
    JournalEntry(
      date: DateTime(2020, 2, 29),
      content: "Amongst my treasures, I found a piece of paper, neatly folded - kind of odd considering my temperament back then. But see",
    ),
  ];

  void _addNewEntry(JournalEntry newEntry) {
    setState(() {
      entries.insert(0, newEntry);
    });
  }

  void _editEntry(int index, JournalEntry updatedEntry) {
    setState(() {
      entries[index] = updatedEntry;
    });
  }

  void _deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('daybook', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(entries[index].date.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _deleteEntry(index);
            },
            child: _buildJournalEntry(context, index, entries[index]),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
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

  Widget _buildJournalEntry(BuildContext context, int index, JournalEntry entry) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddOrEditNotePage(
              existingEntry: entry,
            ),
          ),
        );
        if (result != null) {
          _editEntry(index, result);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DateFormat('dd MMM').format(entry.date).toUpperCase()} ${entry.date.year}, ${DateFormat('EEEE').format(entry.date)}',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(entry.date),
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              entry.content,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (entry.image != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  entry.image!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            Divider(color: Colors.grey[800]),
          ],
        ),
      ),
    );
  }
}

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
                    date: _currentDate,
                    content: _contentController.text,
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

class JournalEntry {
  final DateTime date;
  final String content;
  final String? image;

  JournalEntry({required this.date, required this.content, this.image});
}
