import 'package:go_router/go_router.dart';
import 'package:dear_diary/domain/entities/journal_entry.dart';
import 'package:dear_diary/presentation/pages/home/home_page.dart';
import 'package:dear_diary/presentation/pages/editor/editor_page.dart';
import 'package:dear_diary/presentation/pages/details/details_page.dart';
import 'package:dear_diary/presentation/pages/settings/settings_page.dart';
import 'package:dear_diary/presentation/pages/calendar/calendar_page.dart';
import 'package:dear_diary/presentation/pages/trash/trash_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'new',
          name: 'new',
          builder: (context, state) => const EditorPage(),
        ),
        GoRoute(
          path: 'edit/:id',
          name: 'edit',
          builder: (context, state) {
            final String id = state.pathParameters['id']!;
            final JournalEntry? entry = state.extra as JournalEntry?;
            return EditorPage(entryId: id, entry: entry);
          },
        ),
        GoRoute(
          path: 'details/:id',
          name: 'details',
          builder: (context, state) {
            final String id = state.pathParameters['id']!;
            return DetailsPage(id: id);
          },
        ),
        GoRoute(
          path: 'calendar',
          name: 'calendar',
          builder: (context, state) => const CalendarPage(),
        ),
        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: 'trash',
          name: 'trash',
          builder: (context, state) => const TrashPage(),
        ),
      ],
    ),
  ],
  initialLocation: '/',
);
