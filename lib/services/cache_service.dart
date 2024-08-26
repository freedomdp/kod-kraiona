import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CacheService {
  static const String _cacheKey = 'phrases_cache';
  static const String _versionKey = 'app_version';
  final Logger _logger = Logger('CacheService');

  Future<void> cacheData(List<List<String>> data) async {
    try {
      final jsonData = json.encode(data);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonData);
      await _saveCurrentVersion();
      _logger.info('Data successfully cached');
    } catch (e) {
      _logger.severe('Error caching data: $e');
      await clearCache();
      rethrow;
    }
  }

  Future<List<List<String>>?> getCachedData() async {
    try {
      if (!await _isVersionValid()) {
        _logger.info('App version changed, clearing cache');
        await clearCache();
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_cacheKey);
      if (jsonData != null) {
        final List<dynamic> decodedData = json.decode(jsonData);
        final result =
            decodedData.map((item) => List<String>.from(item)).toList();
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
      await prefs.remove(_versionKey);
      _logger.info('Cache cleared successfully');
    } catch (e) {
      _logger.severe('Error clearing cache: $e');
    }
  }

  bool _isValidData(List<List<String>> data) {
    return data.isNotEmpty && data.every((list) => list.isNotEmpty);
  }

  Future<bool> isCacheValid() async {
    try {
      if (!await _isVersionValid()) {
        return false;
      }
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_cacheKey);
    } catch (e) {
      _logger.warning('Error checking cache validity: $e');
      return false;
    }
  }

  Future<void> _saveCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_versionKey, packageInfo.version);
  }

  Future<bool> _isVersionValid() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    final cachedVersion = prefs.getString(_versionKey);
    return cachedVersion == packageInfo.version;
  }

  Future<void> checkAndFixCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_cacheKey);
      if (jsonData != null) {
        try {
          json.decode(jsonData);
        } catch (e) {
          _logger.warning('Invalid JSON in cache, attempting to fix');
          final fixedJson = _fixInvalidJson(jsonData);
          if (fixedJson != null) {
            await prefs.setString(_cacheKey, fixedJson);
            _logger.info('Cache JSON fixed and saved');
          } else {
            await clearCache();
            _logger.info('Unable to fix cache, cleared instead');
          }
        }
      }
    } catch (e) {
      _logger.severe('Error checking and fixing cache: $e');
      await clearCache();
    }
  }

  String? _fixInvalidJson(String invalidJson) {
    try {
      final trimmed = invalidJson.trim();
      if (trimmed.endsWith(',]')) {
        return '${trimmed.substring(0, trimmed.length - 2)}]';
      } else if (trimmed.endsWith(',}')) {
        return '${trimmed.substring(0, trimmed.length - 2)}}';
      }
    } catch (e) {
      _logger.warning('Error while trying to fix JSON: $e');
    }
    return null;
  }
}
