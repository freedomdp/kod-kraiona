import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:logging/logging.dart';

class CacheService {
  static const String _cacheKey = 'phrases_cache';
  final Logger _logger = Logger('CacheService');

  Future<void> cacheData(List<List<String>> data) async {
    try {
      final jsonData = json.encode(data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonData);
      _logger.info('Data successfully cached');
    } catch (e) {
      _logger.severe('Error caching data: $e');
      await clearCache(); // Очищаем кэш при ошибке сохранения
      rethrow; // Перебрасываем исключение для обработки на уровне выше
    }
  }

  Future<List<List<String>>?> getCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_cacheKey);
      if (jsonData != null) {
        final List<dynamic> decodedData = json.decode(jsonData);
        final result = decodedData.map((item) => List<String>.from(item)).toList();
        if (_isValidData(result)) {
          _logger.info('Cache data retrieved successfully');
          return result;
        } else {
          _logger.warning('Retrieved cache data is invalid');
          await clearCache();
        }
      }
    } catch (e) {
      _logger.severe('Error reading cache: $e');
      await clearCache();
    }
    return null;
  }

  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      _logger.info('Cache cleared successfully');
    } catch (e) {
      _logger.severe('Error clearing cache: $e');
    }
  }

  bool _isValidData(List<List<String>> data) {
    // Проверка структуры и содержимого данных
    return data.isNotEmpty && data.every((list) => list.isNotEmpty && list.every((item) => item is String));
  }

  Future<bool> isCacheValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_cacheKey);
    } catch (e) {
      _logger.warning('Error checking cache validity: $e');
      return false;
    }
  }
}
