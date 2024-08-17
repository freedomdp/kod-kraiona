import 'package:kod_kraiona/services/google_sheets_service.dart';

class SearchService {
  final GoogleSheetsService _sheetsService;

  SearchService(this._sheetsService);

  Future<List<List<String>>> searchPhrases(String code) async {
    if (code.length < 2) return [];

    final allData = await _sheetsService.getAllData();
    return allData.where((row) => row.length > 1 && row[1] == code).toList();
  }
}
