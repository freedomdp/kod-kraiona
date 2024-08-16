import 'package:gsheets/gsheets.dart';
import 'package:flutter/services.dart' show rootBundle;


class GoogleSheetsService {
  static late GSheets _gsheets;
  static late Spreadsheet _spreadsheet;

  GoogleSheetsService._();

  static Future<GoogleSheetsService> getInstance() async {
    final credentialsString = await rootBundle.loadString('assets/credentials/credentials.json');
    _gsheets = GSheets(credentialsString);
    _spreadsheet = await _gsheets
        .spreadsheet("1yvlp4qH8pJtFk5RecVJEJw0RiN8zmz7NdeqAt_cFaDc");
    return GoogleSheetsService._();
  }

  Future<List<List<String>>> getAllData() async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    return await sheet!.values.allRows();
  }

  Future<void> updatePhrases(List<List<String>> updatedPhrases) async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    await sheet!.values.insertRows(1, updatedPhrases);
  }

  Future<void> addPhrase(String phrase, int value) async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    await sheet!.values.appendRow([phrase, value.toString()]);
  }

  Future<List<String>> findPhrasesByValue(int value) async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    final allRows = await sheet!.values.allRows();
    return allRows
        .where((row) => int.tryParse(row[1] ?? '0') == value)
        .map((row) => row[0])
        .toList();
  }
}
