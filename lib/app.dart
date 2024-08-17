import 'package:flutter/material.dart';
import 'screens/krayon_code_calculator.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Код Крайона (українська версія)',
      theme: AppTheme.theme,
      home: const KrayonCodeCalculator(),
    );
  }
}
