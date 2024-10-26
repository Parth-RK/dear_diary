import 'package:flutter/material.dart';
import 'package:dear_diary/config/theme.dart';
import 'package:dear_diary/screens/home/daybook_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daybook',
      theme: AppTheme.darkTheme,
      home: const DaybookHomePage(),
    );
  }
}