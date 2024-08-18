import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'services/google_sheets_service.dart';
import 'services/cache_service.dart';  
import 'repositories/google_sheets_repository.dart';
import 'package:logging/logging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  final logger = Logger('MainApp');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.info('Initializing GoogleSheetsService...');
    final googleSheetsService = await GoogleSheetsService.getInstance();
    final cacheService = CacheService();  // Создаем экземпляр CacheService
    final googleSheetsRepository = GoogleSheetsRepository(googleSheetsService, cacheService);

    logger.info('Loading initial data...');
    await googleSheetsRepository.getAllData();
    logger.info('Initial data loaded');

    runApp(
      RepositoryProvider(
        create: (context) => googleSheetsRepository,
        child: MyApp(repository: googleSheetsRepository),
      ),
    );
  } catch (e) {
    logger.severe('Error initializing app', e);
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
