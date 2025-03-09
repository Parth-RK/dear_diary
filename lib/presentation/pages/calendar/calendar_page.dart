import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/presentation/bloc/journal/journal_bloc.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<JournalEntry>> _eventsByDay = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEntries();
  }

  void _loadEntries() {
    final journalState = context.read<JournalBloc>().state;
    if (journalState is JournalLoaded) {
      _processEntries(journalState.entries);
    } else {
      context.read<JournalBloc>().add(LoadJournalEntries());
    }
  }

  void _processEntries(List<JournalEntry> entries) {
    // Group entries by date (ignoring time)
    final Map<DateTime, List<JournalEntry>> eventsByDay = {};
    
    for (final entry in entries) {
      final DateTime date = DateTime(
        entry.createdAt.year,
        entry.createdAt.month,
        entry.createdAt.day,
      );
      
      if (eventsByDay[date] != null) {
        eventsByDay[date]!.add(entry);
      } else {
        eventsByDay[date] = [entry];
      }
    }
    
    setState(() {
      _eventsByDay = eventsByDay;
    });
  }

  List<JournalEntry> _getEntriesForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _eventsByDay[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: BlocConsumer<JournalBloc, JournalState>(
        listener: (context, state) {
          if (state is JournalLoaded) {
            _processEntries(state.entries);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                eventLoader: _getEntriesForDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: const CalendarStyle(
                  markersMaxCount: 3,
                  markerDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildEntryList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEntryList() {
    if (_selectedDay == null) return const SizedBox.shrink();
    
    final entries = _getEntriesForDay(_selectedDay!);
    
    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No entries for ${DateFormat('MMM d, yyyy').format(_selectedDay!)}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              entry.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              DateFormat('h:mm a').format(entry.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/details/${entry.id}'),
          ),
        );
      },
    );
  }
}
