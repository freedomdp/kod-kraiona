import 'package:gsheets/gsheets.dart';
import 'package:flutter/services.dart' show rootBundle;

class GoogleSheetsService {
  static const _spreadsheetId = '1yvlp4qH8pJtFk5RecVJEJw0RiN8zmz7NdeqAt_cFaDc';
  static const String _credentialsPath = 'assets/credentials/credentials.json';

  static GoogleSheetsService? _instance;
  late final GSheets _gsheets;
  Spreadsheet? _spreadsheet;
  Worksheet? _worksheet;

  GoogleSheetsService._();

  static Future<GoogleSheetsService> getInstance() async {
    if (_instance == null) {
      _instance = GoogleSheetsService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    try {
      print('Loading credentials...');
      final credentialsJson = await rootBundle.loadString(_credentialsPath);
      print('Credentials loaded successfully');

      print('Initializing GSheets...');
      _gsheets = GSheets(credentialsJson);
      print('GSheets initialized successfully');

      print('Accessing spreadsheet...');
      _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      print('Spreadsheet accessed successfully');

      print('Accessing worksheet...');
      _worksheet = _spreadsheet!.worksheetByTitle('ukr');
      if (_worksheet == null) {
        throw Exception('Worksheet "ukr" not found');
      }
      print('Worksheet accessed successfully');
    } catch (e) {
      print('Error initializing Google Sheets: $e');
      rethrow;
    }
  }

  Future<List<List<String>>> getAllData() async {
    if (_worksheet == null) throw Exception('Worksheet not initialized');

    // Получение всех строк из Google Sheets
    final data = await _worksheet!.values.allRows();
    print(
        'Raw data from worksheet: $data'); // Логируем все необработанные данные

    return data; // Временно возвращаем все данные без фильтрации
  }

  Future<void> addPhrase(String phrase, int value) async {
    if (_worksheet == null) await _init();
    await _worksheet!.values.appendRow([phrase, value.toString()]);
  }

  Future<List<String>> findPhrasesByValue(int value) async {
    if (_worksheet == null) await _init();
    final allData = await getAllData();
    return allData
        .where((row) => row.length > 1 && row[1] == value.toString())
        .map((row) => row[0])
        .toList();
  }
}
