import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'services/google_sheets_service.dart';
import 'services/cache_service.dart';
import 'repositories/google_sheets_repository.dart';
import 'blocs/phrases_bloc.dart';
import 'blocs/krayon_code_bloc.dart';
import 'events/phrases_event.dart';
import 'package:logging/logging.dart';
import 'utils/network_utils.dart';

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

    final cacheService = CacheService();
    GoogleSheetsRepository? googleSheetsRepository;

    if (await NetworkUtils.checkInternetConnection()) {
      logger.info('Initializing GoogleSheetsService...');
      final googleSheetsService = await GoogleSheetsService.getInstance();
      googleSheetsRepository = GoogleSheetsRepository(googleSheetsService, cacheService);

      logger.info('Loading initial data...');
      await googleSheetsRepository.getAllData(forceRefresh: true);
      logger.info('Initial data loaded');
    } else {
      logger.info('No internet connection. Using cached data...');
      googleSheetsRepository = GoogleSheetsRepository(null, cacheService);
    }

    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<GoogleSheetsRepository>(
            create: (context) => googleSheetsRepository!,
          ),
          RepositoryProvider<CacheService>(
            create: (context) => cacheService,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PhrasesBloc>(
              create: (context) => PhrasesBloc(
                context.read<GoogleSheetsRepository>(),
                context.read<CacheService>(),
              )..add(LoadPhrases()),
            ),
            BlocProvider<KrayonCodeBloc>(
              create: (context) => KrayonCodeBloc(
                context.read<GoogleSheetsRepository>(),
              ),
            ),
          ],
          child: const MyApp(),
        ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: () {
                  // Перезапуск приложения
                  main();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
