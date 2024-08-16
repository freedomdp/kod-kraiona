import 'package:flutter/material.dart';
import '../services/google_sheets_service.dart';
import '../services/krayon_code_service.dart';
import '../widgets/phrases_table.dart';
import '../config/app_version.dart';

class PhrasesScreen extends StatefulWidget {
  const PhrasesScreen({Key? key}) : super(key: key);

  @override
  _PhrasesScreenState createState() => _PhrasesScreenState();
}

class _PhrasesScreenState extends State<PhrasesScreen> {
  List<List<String>> _phrases = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadPhrases();
  }

  Future<void> _loadPhrases() async {
    try {
      final googleSheetsService = await GoogleSheetsService.getInstance();
      print('GoogleSheetsService instance obtained');

      KrayonCodeService.setSheetService(googleSheetsService);

      final phrases = await googleSheetsService.getAllData();
      print('Phrases before setting state: $phrases'); // Лог для проверки загруженных данных

      setState(() {
        _phrases = phrases;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading phrases: $e');
      setState(() {
        _isLoading = false;
        _error = 'Помилка завантаження даних: $e';
      });
    }
  }

  Future<void> _recalculateCodesAndUpload() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final googleSheetsService = await GoogleSheetsService.getInstance();
      KrayonCodeService.setSheetService(googleSheetsService);

      // Пересчет кодов для всех фраз
      List<List<String>> updatedPhrases = _phrases.map((phrase) {
        final newCode = KrayonCodeService.calculate(phrase[0])['total'].toString();
        return [phrase[0], newCode];
      }).toList();

      // Обновление данных в Google Sheets
      await googleSheetsService.updatePhrases(updatedPhrases);

      // Обновление данных на экране
      setState(() {
        _phrases = updatedPhrases;
        _isLoading = false;
      });

      print('Codes recalculated and updated successfully!');
    } catch (e) {
      print('Error recalculating and uploading codes: $e');
      setState(() {
        _isLoading = false;
        _error = 'Помилка оновлення даних: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фрази та їх коди'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () async {
              await _recalculateCodesAndUpload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
                  ? Center(
                      child: Text(_error, style: const TextStyle(color: Colors.red)))
                  : _phrases.isEmpty
                      ? const Center(
                          child: Text('Немає даних для відображення'))
                      : PhrasesTable(phrases: _phrases),
          Positioned(
            right: 10,
            bottom: 10,
            child: Text(
              AppVersion.getFullVersion(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
