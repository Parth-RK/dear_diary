import 'package:flutter/material.dart';
import 'package:dear_diary/config/theme.dart';
import 'package:dear_diary/screens/home/daybook_home_page.dart';
import 'package:dear_diary/services/database_service.dart';
import 'package:dear_diary/screens/calendar/calendar_page.dart';
import 'package:dear_diary/models/journal_entry.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daybook',
      theme: AppTheme.darkTheme,
      home: const DaybookHomeScreen(),
    );
  }
}

class DaybookHomeScreen extends StatefulWidget {
  const DaybookHomeScreen({super.key});

  @override
  State<DaybookHomeScreen> createState() => _DaybookHomeScreenState();
}

class _DaybookHomeScreenState extends State<DaybookHomeScreen> {
  int _currentIndex = 0;
  late Box<JournalEntry> _entriesBox;
  List<JournalEntry> _entries = [];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _initializeBox();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initializeBox() async {
    _entriesBox = await DatabaseService.instance.getBox<JournalEntry>('journal_entries');
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _entries = _entriesBox.values.toList();
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: [
          const DaybookHomePage(),
          CalendarPage(entries: _entries),
          const Center(child: Text('More')), // Placeholder for More page
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme: Theme.of(context).bottomNavigationBarTheme,
        ),
        child: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.book),
            label: 'Daybook',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    )
  );
  }
}