import 'package:flutter/material.dart';
import '../services/phrases_service.dart';
import '../services/search_service.dart';
import '../widgets/phrases_table_widget.dart';
import '../widgets/search_field.dart';
import '../services/google_sheets_service.dart';

class PhrasesScreen extends StatefulWidget {
  const PhrasesScreen({super.key});

  @override
  _PhrasesScreenState createState() => _PhrasesScreenState();
}

class _PhrasesScreenState extends State<PhrasesScreen> {
  final PhrasesService _phrasesService = PhrasesService();
  late SearchService _searchService;
  List<List<String>> _phrases = [];
  bool _isLoading = true;
  String _error = '';
  bool _isSearching = false;
  static const double maxWidth = 400.0;

  @override
  void initState() {
    super.initState();
    _loadPhrases();
  }

  Future<void> _loadPhrases() async {
    try {
      final googleSheetsService = await GoogleSheetsService.getInstance();
      _searchService = SearchService(googleSheetsService);
      final phrases = await _phrasesService.loadPhrases();
      setState(() {
        _phrases = phrases;
        _isLoading = false;
      });
    } catch (e) {
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
      final updatedPhrases =
          await _phrasesService.recalculateCodesAndUpload(_phrases);
      setState(() {
        _phrases = updatedPhrases;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Помилка оновлення даних: $e';
      });
    }
  }

  Future<void> _onSearch(String code) async {
    setState(() {
      _isLoading = true;
      _isSearching = true;
    });

    try {
      final searchResults = await _searchService.searchPhrases(code);
      setState(() {
        _phrases = searchResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Помилка пошуку: $e';
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
    });
    _loadPhrases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Фрази та їх коди'),
            Text(
              'база з ${_phrases.length} фраз',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: _recalculateCodesAndUpload,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SearchField(onSearch: _onSearch, onClear: _clearSearch),
                const SizedBox(height: 16),
                Expanded(
                  child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error.isNotEmpty
                      ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
                      : _phrases.isEmpty && _isSearching
                        ? const Center(child: Text('За вашим кодом відповідних фраз не знайдено!'))
                        : PhrasesTableWidget(phrases: _phrases),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
