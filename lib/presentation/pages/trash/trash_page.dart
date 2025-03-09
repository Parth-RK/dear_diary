import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/presentation/bloc/trash/trash_bloc.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  void initState() {
    super.initState();
    context.read<TrashBloc>().add(LoadTrashEntries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _showEmptyTrashDialog(context);
            },
            tooltip: 'Empty trash',
          ),
        ],
      ),
      body: BlocBuilder<TrashBloc, TrashState>(
        builder: (context, state) {
          if (state is TrashLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrashLoaded) {
            final trashedEntries = state.entries;
            
            if (trashedEntries.isEmpty) {
              return const Center(
                child: Text('Trash is empty'),
              );
            }
            
            return ListView.builder(
              itemCount: trashedEntries.length,
              itemBuilder: (context, index) {
                final entry = trashedEntries[index];
                return _buildTrashItem(context, entry);
              },
            );
          } else if (state is TrashError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Failed to load trashed entries'));
          }
        },
      ),
    );
  }

  Widget _buildTrashItem(BuildContext context, JournalEntry entry) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(entry.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  formattedDate,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              entry.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.restore),
                  label: const Text('Restore'),
                  onPressed: () {
                    context.read<TrashBloc>().add(RestoreTrashEntry(entry.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Entry restored'))
                    );
                  },
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, entry);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, JournalEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Permanently'),
        content: Text('Are you sure you want to permanently delete "${entry.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<TrashBloc>().add(DeleteTrashEntryPermanently(entry.id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Entry permanently deleted'))
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEmptyTrashDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Empty Trash'),
        content: const Text('Are you sure you want to permanently delete all items in the trash? This action cannot be undone.'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<TrashBloc>().add(EmptyTrashEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trash emptied'))
              );
            },
            child: const Text('Empty Trash'),
          ),
        ],
      ),
    );
  }
}
