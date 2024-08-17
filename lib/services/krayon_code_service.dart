import 'google_sheets_service.dart';

class KrayonCodeService {
  static const ukrainianAlphabet = 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя';
  static late GoogleSheetsService _sheetsService;
  static const int minSearchLength = 4;  // Минимальная длина для поиска
  static const int searchDelay = 3;  // Задержка поиска в секундах

  static void setSheetService(GoogleSheetsService service) {
    _sheetsService = service;
  }

  static Map<String, dynamic> calculate(String input) {
    int total = 0;
    List<Map<String, dynamic>> details = [];

    for (var char in input.toLowerCase().split('')) {
      if (ukrainianAlphabet.contains(char)) {
        int value = ukrainianAlphabet.indexOf(char) + 1;
        total += value;
        details.add({'char': char, 'value': value});
      }
    }
    return {
      'total': total,
      'details': details,
    };
  }

  static Future<List<String>> findMatchingPhrases(int value) async {
    return await _sheetsService.findPhrasesByValue(value);
  }

  static Future<void> addNewPhrase(String phrase) async {
    int value = calculate(phrase)['total'];
    await _sheetsService.addPhrase(phrase, value);
  }
}
