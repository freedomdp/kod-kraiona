import 'package:kod_kraiona/services/google_sheets_service.dart';
import 'package:kod_kraiona/services/krayon_code_service.dart';

class PhrasesService {
  late GoogleSheetsService _googleSheetsService;

  Future<void> _initGoogleSheetsService() async {
    _googleSheetsService = await GoogleSheetsService.getInstance();
    KrayonCodeService.setSheetService(_googleSheetsService);
  }

  Future<List<List<String>>> loadPhrases() async {
    await _initGoogleSheetsService();
    return await _googleSheetsService.getAllData();
  }

  Future<List<List<String>>> recalculateCodesAndUpload(List<List<String>> phrases) async {
    await _initGoogleSheetsService();

    // Пересчет кодов для всех фраз
    Map<String, String> uniquePhrases = {};
    for (var phrase in phrases) {
      final newCode = KrayonCodeService.calculate(phrase[0])['total'].toString();
      uniquePhrases[phrase[0]] = newCode;
    }

    // Преобразование уникальных фраз обратно в список
    List<List<String>> updatedPhrases = uniquePhrases.entries.map((e) => [e.key, e.value]).toList();

    // Очистка таблицы
    await _googleSheetsService.clearSheet();

    // Обновление данных в Google Sheets
    await _googleSheetsService.updatePhrases(updatedPhrases);

    return updatedPhrases;
  }
}
