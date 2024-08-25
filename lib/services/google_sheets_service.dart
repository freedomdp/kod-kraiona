import 'package:gsheets/gsheets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:math' show min; 
import 'package:logging/logging.dart';

final _logger = Logger('GoogleSheetsService');

class GoogleSheetsService {
  static late GSheets _gsheets;
  static late Spreadsheet _spreadsheet;

  GoogleSheetsService._();

  // Инициализирует сервис Google Sheets
  static Future<GoogleSheetsService> getInstance() async {
    try {
      _logger.info('Loading credentials...');
      final String response =
          await rootBundle.loadString('assets/credentials/credentials.json');
      _logger.info(
          'Credentials loaded successfully. Raw content (first 100 chars): ${response.substring(0, min(100, response.length))}');

      _logger.info('Parsing JSON...');
      dynamic data;
      try {
        data = json.decode(response);
        _logger.info(
            'JSON parsed successfully. Keys: ${(data as Map<String, dynamic>).keys.join(", ")}');
      } catch (parseError) {
        _logger.severe('Error parsing JSON: $parseError');
        _logger.info('Full raw content: $response');
        rethrow;
      }

      _logger.info('Initializing GSheets...');
      _gsheets = GSheets(data);
      _logger.info('GSheets initialized successfully');

      _logger.info('Accessing spreadsheet...');
      _spreadsheet = await _gsheets
          .spreadsheet("1yvlp4qH8pJtFk5RecVJEJw0RiN8zmz7NdeqAt_cFaDc");
      _logger.info('Spreadsheet accessed successfully');

      return GoogleSheetsService._();
    } catch (e) {
      _logger.severe('Error in getInstance: $e');
      rethrow;
    }
  }

  // Получает все данные из листа 'ukr'
  Future<List<List<String>>> getAllData() async {
    try {
      _logger.info('Getting worksheet...');
      final sheet = _spreadsheet.worksheetByTitle('ukr');
      if (sheet == null) {
        _logger.warning('Worksheet "ukr" not found');
        return [];
      }
      _logger.info('Worksheet obtained successfully');

      _logger.info('Fetching all rows...');
      final rows = await sheet.values.allRows();
      _logger.info('Fetched ${rows.length} rows successfully');

      return rows;
    } catch (e) {
      _logger.severe('Error in getAllData: $e');
      rethrow;
    }
  }

  // Обновляет фразы в листе 'ukr'
  Future<void> updatePhrases(List<List<String>> updatedPhrases) async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    var sortedPhrases = _sortData(updatedPhrases);
    await sheet!.clear();
    await sheet.values.insertRows(1, sortedPhrases);
  }

  // Добавляет новую фразу в лист 'ukr'
  Future<void> addPhrase(String phrase, int value) async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    await sheet!.values.appendRow([phrase, value.toString()]);
    var allData = await getAllData();
    await updatePhrases(allData);
  }

  // Ищет фразы по заданному значению
  Future<List<String>> findPhrasesByValue(int value) async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    final allRows = await sheet!.values.allRows();
    return allRows
        .where((row) => row.length > 1 && int.tryParse(row[1]) == value)
        .map((row) => row[0])
        .toList();
  }

  // Очищает лист 'ukr'
  Future<void> clearSheet() async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    await sheet!.clear();
  }

  // Сортирует данные по второму столбцу (коду)
  List<List<String>> _sortData(List<List<String>> data) {
    return data
      ..sort((a, b) {
        if (a.length < 2 || b.length < 2) return 0;
        return int.parse(a[1]).compareTo(int.parse(b[1]));
      });
  }
}
