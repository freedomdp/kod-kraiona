import 'package:gsheets/gsheets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class GoogleSheetsService {
  static late GSheets _gsheets;
  static late Spreadsheet _spreadsheet;

  GoogleSheetsService._();

  static Future<GoogleSheetsService> getInstance() async {
    // Загружаем содержимое файла как строку
    final String response = await rootBundle.loadString('assets/credentials/credentials.json');
    // Парсим JSON
    final data = await json.decode(response);
    // Создаем экземпляр GSheets, используя распарсенные данные
    _gsheets = GSheets(data);
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

    // Сортировка фраз по коду (второй столбец) от меньшего к большему
    var sortedPhrases = _sortData(updatedPhrases);

    // Очистка листа перед вставкой отсортированных данных
    await sheet!.clear();

    // Вставка отсортированных данных
    await sheet.values.insertRows(1, sortedPhrases);
  }

  Future<void> addPhrase(String phrase, int value) async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    await sheet!.values.appendRow([phrase, value.toString()]);

    // После добавления новой фразы, пересортируем и обновим весь лист
    var allData = await getAllData();
    await updatePhrases(allData);
  }

  Future<List<String>> findPhrasesByValue(int value) async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    final allRows = await sheet!.values.allRows();
    return allRows
        .where((row) => row.length > 1 && int.tryParse(row[1]) == value)
        .map((row) => row[0])
        .toList();
  }

  // Добавляем новый метод clearSheet
  Future<void> clearSheet() async {
    final sheet = _spreadsheet.worksheetByTitle('ukr');
    await sheet!.clear();
  }

    List<List<String>> _sortData(List<List<String>> data) {
    return data..sort((a, b) {
      if (a.length < 2 || b.length < 2) return 0;
      return int.parse(a[1]).compareTo(int.parse(b[1]));
    });
  }
}
