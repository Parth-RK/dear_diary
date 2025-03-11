import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/presentation/bloc/journal/journal_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditorPage extends StatefulWidget {
  final String? entryId;
  final JournalEntry? entry;

  const EditorPage({super.key, this.entryId, this.entry});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _contentFocusNode = FocusNode();
  final List<String> _images = [];
  final List<String> _tags = [];
  String _mood = '';
  bool _isEditing = false;
  late JournalEntry _currentEntry;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _isEditing = true;
      _currentEntry = widget.entry!;
      _titleController.text = _currentEntry.title;
      _contentController.text = _currentEntry.content;
      _images.addAll(_currentEntry.images);
      _tags.addAll(_currentEntry.tags);
      _mood = _currentEntry.mood;
    }
    
    // Delay focus to avoid the pointer binding issue
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Don't set automatic focus initially
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Close keyboard when tapping outside input fields
      onTap: () {
        _titleFocusNode.unfocus();
        _contentFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Entry' : 'New Entry'),
          actions: [
            IconButton(
              icon: const Icon(Icons.photo_camera),
              onPressed: _pickImage,
            ),
            IconButton(
              icon: const Icon(Icons.mood),
              onPressed: _showMoodPicker,
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveEntry,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date display
              Text(
                'Today, ${DateFormat('MMMM d, yyyy').format(DateTime.now())}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              
              // Title field
              TextField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
                // Avoid autofocus which can cause issues
                autofocus: false,
                onTap: () {
                  // Manual focus handling
                  if (!_titleFocusNode.hasFocus) {
                    FocusScope.of(context).requestFocus(_titleFocusNode);
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Content field
              TextField(
                controller: _contentController,
                focusNode: _contentFocusNode,
                decoration: const InputDecoration(
                  labelText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 15,
                textAlignVertical: TextAlignVertical.top,
                // Avoid autofocus which can cause issues
                autofocus: false,
                onTap: () {
                  // Manual focus handling
                  if (!_contentFocusNode.hasFocus) {
                    FocusScope.of(context).requestFocus(_contentFocusNode);
                  }
                },
              ),
              
              // Images section
              if (_images.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Photos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Stack(
                          children: [
                            Image.network(
                              _images[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _images.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              
              // Mood section
              if (_mood.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Mood: ',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(_mood),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _mood = '';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _images.add(image.path); // In a real app, you'd upload and get a URL
      });
    }
  }

  void _showMoodPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Happy'),
                leading: const Icon(Icons.sentiment_very_satisfied, color: Colors.green),
                onTap: () {
                  setState(() {
                    _mood = 'Happy';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sad'),
                leading: const Icon(Icons.sentiment_dissatisfied, color: Colors.blue),
                onTap: () {
                  setState(() {
                    _mood = 'Sad';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Angry'),
                leading: const Icon(Icons.sentiment_very_dissatisfied, color: Colors.red),
                onTap: () {
                  setState(() {
                    _mood = 'Angry';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Neutral'),
                leading: const Icon(Icons.sentiment_neutral, color: Colors.grey),
                onTap: () {
                  setState(() {
                    _mood = 'Neutral';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveEntry() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }
    
    final now = DateTime.now();
    
    if (_isEditing) {
      final updatedEntry = _currentEntry.copyWith(
        title: title,
        content: content,
        lastModifiedAt: now,
        images: _images,
        tags: _tags,
        mood: _mood,
      );
      
      context.read<JournalBloc>().add(UpdateJournalEntryEvent(updatedEntry));
    } else {
      final newEntry = JournalEntry(
        id: const Uuid().v4(),
        createdAt: now,
        lastModifiedAt: now,
        title: title,
        content: content,
        images: _images,
        tags: _tags,
        mood: _mood,
      );
      
      context.read<JournalBloc>().add(AddJournalEntryEvent(newEntry));
    }
    
    context.go('/');
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }
}
