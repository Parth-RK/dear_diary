// lib/screens/more/more_options_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dear_diary/config/theme_provider.dart';
import 'package:dear_diary/screens/more/trash_page.dart';
import 'package:dear_diary/config/theme.dart';

class MoreOptionsPage extends StatelessWidget {
  const MoreOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Options'),
      ),
      body: ListView(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) => SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Trash'),
            subtitle: const Text('View and restore deleted entries'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrashPage()),
            ),
          ),
        ],
      ),
    );
  }
}
