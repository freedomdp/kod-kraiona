import 'package:flutter/services.dart' show rootBundle;
import 'package:gsheets/gsheets.dart';

class GoogleSheetsService {
  static const _spreadsheetId = '1yvlp4qH8pJtFk5RecVJEJw0RiN8zmz7NdeqAt_cFaDc';
  static const String _credentialsPath = 'assets/credentials/kod-kraiona-432514-73ca8a27f88f.json';

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
      final credentialsJson = await rootBundle.loadString(_credentialsPath);
      _gsheets = GSheets(credentialsJson);
      _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _worksheet = _spreadsheet!.worksheetByTitle('Sheet1'); // Змініть на назву вашого листа
    } catch (e) {
      print('Error initializing Google Sheets: $e');
      rethrow;
    }
  }

  Future<List<List<String>>> getAllData() async {
    if (_worksheet == null) await _init();
    return await _worksheet!.values.allRows();
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
