import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CacheService {
  static const String _cacheKey = 'phrases_cache';

  Future<void> cacheData(List<List<String>> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(data);
    await prefs.setString(_cacheKey, jsonData);
  }

  Future<List<List<String>>?> getCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_cacheKey);
    if (jsonData != null) {
      final List<dynamic> decodedData = json.decode(jsonData);
      return decodedData.map((item) => List<String>.from(item)).toList();
    }
    return null;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
