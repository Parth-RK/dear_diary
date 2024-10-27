import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dear_diary/models/journal_entry.dart';

class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onTap;

  const JournalEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
