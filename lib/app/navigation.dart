import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';

class AppNavigation {
  // Navigate to home page
  static void navigateToHome(BuildContext context) {
    context.goNamed('home');
  }

  // Navigate to new entry page
  static void navigateToNewEntry(BuildContext context) {
    context.goNamed('new');
  }

  // Navigate to edit entry page
  static void navigateToEditEntry(BuildContext context, String id, JournalEntry entry) {
    context.goNamed('edit', pathParameters: {'id': id}, extra: entry);
  }

  // Navigate to entry details page
  static void navigateToEntryDetails(BuildContext context, String id) {
    context.goNamed('details', pathParameters: {'id': id});
  }

  // Navigate to calendar page
  static void navigateToCalendar(BuildContext context) {
    context.goNamed('calendar');
  }

  // Navigate to settings page
  static void navigateToSettings(BuildContext context) {
    context.goNamed('settings');
  }

  // Navigate to trash page
  static void navigateToTrash(BuildContext context) {
    context.goNamed('trash');
  }
}
