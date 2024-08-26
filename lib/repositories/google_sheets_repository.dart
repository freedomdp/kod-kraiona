import 'package:kod_kraiona/services/google_sheets_service.dart';
import 'package:kod_kraiona/services/cache_service.dart';
import 'package:kod_kraiona/utils/constants.dart';
import 'package:logging/logging.dart';

final _logger = Logger('GoogleSheetsRepository');

class GoogleSheetsRepository {
  final GoogleSheetsService? _service;
  final CacheService _cacheService;

  GoogleSheetsRepository(this._service, this._cacheService);

  Future<List<List<String>>> getAllData({bool forceRefresh = false}) async {
    if (_service == null || !forceRefresh) {
      final cachedData = await _cacheService.getCachedData();
      if (cachedData != null) {
        return cachedData;
      }
    }

    if (_service == null) {
      throw Exception('No internet connection and no cached data available');
    }

    final data = await _service.getAllData();
    await _cacheService.cacheData(data);
    return data;
  }

  Future<void> recalculateAndUpload() async {
    try {
      List<List<String>> allData = await getAllData(forceRefresh: true);

      Map<String, String> uniquePhrases = {};
      for (var row in allData) {
        if (row.isNotEmpty) {
          String phrase = row[0];
          uniquePhrases[phrase] = calculateCode(phrase)['total'].toString();
        }
      }

      List<List<String>> updatedData = uniquePhrases.entries
          .map((e) => [e.key, e.value])
          .toList()
        ..sort((a, b) => int.parse(a[1]).compareTo(int.parse(b[1])));

      if (_service != null) {
        await _service.clearSheet();
        await _service.updatePhrases(updatedData);
      }
      await _cacheService.cacheData(updatedData);
    } catch (e, stackTrace) {
      _logger.severe('Error in recalculateAndUpload: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<List<String>> findPhrasesByValue(int value) async {
    try {
      final allData = await getAllData();
      return allData
          .where((row) => row.length > 1 && int.tryParse(row[1]) == value)
          .map((row) => row[0])
          .toList();
    } catch (e, stackTrace) {
      _logger.severe('Error in findPhrasesByValue: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> calculateCode(String input) {
    try {
      int total = 0;
      List<Map<String, dynamic>> details = [];

      for (var char in input.toLowerCase().split('')) {
        if (AppConstants.ukrainianAlphabet.contains(char)) {
          int value = AppConstants.ukrainianAlphabet.indexOf(char) + 1;
          total += value;
          details.add({'char': char, 'value': value});
        }
      }
      return {
        'total': total,
        'details': details,
      };
    } catch (e, stackTrace) {
      _logger.severe('Error in calculateCode: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }
}
