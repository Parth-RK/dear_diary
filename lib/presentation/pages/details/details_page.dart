// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/presentation/bloc/journal/journal_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class DetailsPage extends StatefulWidget {
  final String id;

  const DetailsPage({super.key, required this.id});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<JournalBloc>().add(GetJournalEntryEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalBloc, JournalState>(
      builder: (context, state) {
        if (state is JournalLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is JournalEntryLoaded) {
          final entry = state.entry;
          return Scaffold(
            appBar: AppBar(
              title: Text(entry.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => context.go('/edit/${entry.id}', extra: entry),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _shareEntry(entry),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteConfirmation(entry);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and mood
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM d, yyyy').format(entry.createdAt),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (entry.mood.isNotEmpty)
                        _buildMoodChip(entry.mood),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Content
                  MarkdownBody(
                    data: entry.content,
                    selectable: true,
                  ),
                  
                  // Images
                  if (entry.images.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Photos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildImageGrid(entry.images),
                  ],
                  
                  // Tags
                  if (entry.tags.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 8,
                      children: entry.tags
                          .map((tag) => Chip(label: Text('#$tag')))
                          .toList(),
                    ),
                  ],
                  
                  // Location
                  if (entry.location.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Text(entry.location),
                      ],
                    ),
                  ],
                  
                  // Last edited
                  const SizedBox(height: 24),
                  Text(
                    'Last edited: ${DateFormat('MMM d, yyyy — h:mm a').format(entry.lastModifiedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Entry Details')),
            body: const Center(child: Text('Entry not found')),
          );
        }
      },
    );
  }

  Widget _buildMoodChip(String mood) {
    IconData moodIcon;
    Color moodColor;
    
    switch (mood.toLowerCase()) {
      case 'happy':
        moodIcon = Icons.sentiment_very_satisfied;
        moodColor = Colors.green;
        break;
      case 'sad':
        moodIcon = Icons.sentiment_dissatisfied;
        moodColor = Colors.blue;
        break;
      case 'angry':
        moodIcon = Icons.sentiment_very_dissatisfied;
        moodColor = Colors.red;
        break;
      default:
        moodIcon = Icons.sentiment_neutral;
        moodColor = Colors.grey;
    }
    
    return Chip(
      avatar: Icon(moodIcon, color: moodColor, size: 16),
      label: Text(mood),
      backgroundColor: moodColor.withOpacity(0.1),
    );
  }
  
  Widget _buildImageGrid(List<String> images) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            images[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
  
  void _shareEntry(JournalEntry entry) {
    final String content = '''
${entry.title}
${DateFormat('MMMM d, yyyy').format(entry.createdAt)}

${entry.content}
''';
    
    Share.share(content, subject: entry.title);
  }
  
  void _showDeleteConfirmation(JournalEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('This entry will be moved to trash. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<JournalBloc>().add(DeleteJournalEntryEvent(entry.id));
              context.go('/');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
