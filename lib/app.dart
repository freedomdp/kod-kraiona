import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/krayon_code_calculator.dart';
import 'theme/app_theme.dart';
import 'repositories/google_sheets_repository.dart';

class MyApp extends StatelessWidget {
  final GoogleSheetsRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: MaterialApp(
        title: 'Код Крайона (українська версія)',
        theme: AppTheme.theme,
        home: const KrayonCodeCalculator(),
      ),
    );
  }
}
