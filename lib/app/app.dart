import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dear_diary/app/routes.dart';
import 'package:dear_diary/app/theme/app_theme.dart';
import 'package:dear_diary/app/theme/theme_cubit.dart';
import 'package:dear_diary/di/service_locator.dart';
import 'package:dear_diary/presentation/bloc/journal/journal_bloc.dart';
import 'package:dear_diary/presentation/bloc/trash/trash_bloc.dart';

class DearDiaryApp extends StatelessWidget {
  const DearDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ThemeCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<JournalBloc>()..add(LoadJournalEntries()),
        ),
        BlocProvider(
          create: (context) => sl<TrashBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Dear Diary',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
