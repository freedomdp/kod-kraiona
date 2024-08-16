import 'package:flutter/material.dart';
import '../services/google_sheets_service.dart';
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

  @override
  Widget build(BuildContext context) {
    print('Rendering data on screen: $_phrases');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Фрази та їх коди'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () {
              // Действие при нажатии на кнопку
              print('Calculator button pressed');
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
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Фраза')),
                                DataColumn(label: Text('Код')),
                              ],
                              rows: _phrases.map((phrase) {
                                return DataRow(cells: [
                                  DataCell(Text(phrase.isNotEmpty ? phrase[0] : '')),
                                  DataCell(Text(phrase.length > 1 ? phrase[1] : '')),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
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
