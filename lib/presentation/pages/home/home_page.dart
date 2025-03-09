import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dear_diary/app/navigation.dart';
import 'package:dear_diary/presentation/bloc/journal/journal_bloc.dart';
import 'package:dear_diary/presentation/widgets/journal_entry_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dear Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => AppNavigation.navigateToCalendar(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => AppNavigation.navigateToSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => AppNavigation.navigateToTrash(context),
          ),
        ],
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state is JournalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JournalLoaded) {
            final entries = state.entries;
            if (entries.isEmpty) {
              return const Center(
                child: Text('No entries yet. Create your first journal entry!'),
              );
            }
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return JournalEntryCard(
                  entry: entry,
                  onTap: () => AppNavigation.navigateToEntryDetails(context, entry.id),
                  onEdit: () => AppNavigation.navigateToEditEntry(context, entry.id, entry),
                );
              },
            );
          } else if (state is JournalError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Failed to load entries'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigation.navigateToNewEntry(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
