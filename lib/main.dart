import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'services/google_sheets_service.dart';
import 'package:logging/logging.dart';

final _logger = Logger('MainApp');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _logger.info('Initializing GoogleSheetsService...');
    await GoogleSheetsService.getInstance();
    _logger.info('GoogleSheetsService initialized successfully');
    runApp(const MyApp());
  } catch (e) {
    _logger.severe('Error initializing app', e);
    runApp(ErrorApp(error: e.toString()));
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
