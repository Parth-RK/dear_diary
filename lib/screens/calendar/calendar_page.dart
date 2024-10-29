import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dear_diary/models/journal_entry.dart';
import 'package:dear_diary/config/theme.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  final List<JournalEntry> entries;

  const CalendarPage({super.key, required this.entries});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<JournalEntry>> _eventsByDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _eventsByDay = _groupEntriesByDay();
  }

  Map<DateTime, List<JournalEntry>> _groupEntriesByDay() {
    final groupedEntries = <DateTime, List<JournalEntry>>{};
    for (var entry in widget.entries) {
      final date = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );
      if (groupedEntries[date] == null) {
        groupedEntries[date] = [];
      }
      groupedEntries[date]!.add(entry);
    }
    return groupedEntries;
  }

  List<JournalEntry> _getEntriesForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _eventsByDay[date] ?? [];
  }

  Widget _buildEventsMarker(List<JournalEntry> events) {
    return Positioned(
      bottom: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          events.length > 3 ? 3 : events.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(2), // Squircle shape
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<JournalEntry>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getEntriesForDay,
          calendarStyle: CalendarStyle(
            markersMaxCount: 3,
            canMarkersOverflow: false,
            markerSize: 6,
            selectedDecoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return _buildEventsMarker(events as List<JournalEntry>);
              }
              return null;
            },
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: _getEntriesForDay(_selectedDay).length,
            itemBuilder: (context, index) {
              final entry = _getEntriesForDay(_selectedDay)[index];
              return ListTile(
                title: Text(
                  DateFormat('hh:mm a').format(entry.date),
                  style: TextStyle(color: AppColors.primaryColor),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    entry.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}