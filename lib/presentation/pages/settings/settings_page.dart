import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dear_diary/app/theme/theme_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = '';
  bool _isLoadingVersion = true;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
        _isLoadingVersion = false;
      });
    } catch (e) {
      setState(() {
        _appVersion = 'Unknown';
        _isLoadingVersion = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Appearance'),
          _buildThemeToggle(),
          
          _buildSectionHeader(context, 'Data Management'),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup Journal'),
            subtitle: const Text('Create a backup of all journal entries'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup feature coming soon'))
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Journal'),
            subtitle: const Text('Restore from a previous backup'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restore feature coming soon'))
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export as PDF'),
            subtitle: const Text('Export your entries as PDF documents'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon'))
              );
            },
          ),
          
          _buildSectionHeader(context, 'Notifications'),
          SwitchListTile(
            title: const Text('Daily Reminder'),
            subtitle: const Text('Get a reminder to write in your journal'),
            value: false, // Get from preferences
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reminders coming soon'))
              );
            },
            secondary: const Icon(Icons.notifications),
          ),
          
          _buildSectionHeader(context, 'Security'),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('Biometric Lock'),
            subtitle: const Text('Secure your journal with fingerprint or face recognition'),
            trailing: Switch(
              value: false, // Get from preferences
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Biometric lock coming soon'))
                );
              },
            ),
          ),
          
          _buildSectionHeader(context, 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: _isLoadingVersion 
                ? const Text('Loading...')
                : Text(_appVersion),
          ),
          
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              child: const Text('Reset All Settings'),
              onPressed: () {
                _showResetConfirmationDialog(context);
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildThemeToggle() {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Dark Mode'),
          trailing: Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'Are you sure you want to reset all settings to their default values? '
          'This will not affect your journal entries.'
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<ThemeCubit>().setTheme(ThemeMode.system);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All settings have been reset'))
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
