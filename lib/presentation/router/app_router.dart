import 'package:go_router/go_router.dart';
import 'package:dear_diary/presentation/pages/home/home_page.dart';
import 'package:dear_diary/presentation/pages/editor/editor_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/editor',
        builder: (context, state) => const EditorPage(),
      ),
      GoRoute(
        path: '/editor/:entryId',
        builder: (context, state) {
          final entryId = state.pathParameters['entryId'];
          return EditorPage(entryId: entryId);
        },
      ),
    ],
  );
}
