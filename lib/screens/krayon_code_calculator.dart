import 'package:flutter/material.dart';
import 'dart:async';
import '../services/krayon_code_service.dart';
import '../services/google_sheets_service.dart';
import 'phrases_screen.dart';
import '../widgets/krayon_code_input.dart';
import '../widgets/krayon_code_result.dart';
import '../widgets/matching_phrases.dart';
import '../theme/app_theme.dart';

class KrayonCodeCalculator extends StatefulWidget {
  const KrayonCodeCalculator({super.key});

  @override
  _KrayonCodeCalculatorState createState() => _KrayonCodeCalculatorState();
}

class _KrayonCodeCalculatorState extends State<KrayonCodeCalculator> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic> _result = {};
  List<String> _matchingPhrases = [];
  Timer? _debounce;
  bool _isInitialized = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    if (!_isInitialized) {
      try {
        final googleSheetsService = await GoogleSheetsService.getInstance();
        KrayonCodeService.setSheetService(googleSheetsService);
        setState(() {
          _isInitialized = true;
        });
      } catch (e) {
        print('Error initializing services: $e');
      }
    }
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: KrayonCodeService.searchDelay), () {
      final input = _controller.text;
      if (input.isEmpty) {
        setState(() {
          _result = {};
          _matchingPhrases = [];
          _isSearching = false;
        });
        return;
      }

      final result = KrayonCodeService.calculate(input);
      setState(() {
        _result = result;
      });

      if (input.length >= KrayonCodeService.minSearchLength) {
        _searchMatchingPhrases(result['total']);
      } else {
        setState(() {
          _matchingPhrases = [];
          _isSearching = false;
        });
      }
    });
  }

  void _searchMatchingPhrases(int code) async {
    setState(() {
      _isSearching = true;
    });

    if (!_isInitialized) {
      await _initializeServices();
    }
    try {
      final phrases = await KrayonCodeService.findMatchingPhrases(code);
      setState(() {
        _matchingPhrases = phrases;
        _isSearching = false;
      });
    } catch (e) {
      print('Error searching matching phrases: $e');
      setState(() {
        _matchingPhrases = [];
        _isSearching = false;
      });
    }
  }

  void _clearInput() {
    _controller.clear();
    setState(() {
      _result = {};
      _matchingPhrases = [];
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Код Крайона'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PhrasesScreen()),
            );
          },
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppTheme.maxWidth),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  child: Image.asset(
                    'assets/images/main_image.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: AppTheme.padding),
                Text(
                  'Калькулятор (українська версія)',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.padding),
                KrayonCodeInput(
                  controller: _controller,
                  onClear: _clearInput,
                ),
                const SizedBox(height: AppTheme.padding),
                if (_result.isNotEmpty) ...[
                  KrayonCodeResult(result: _result),
                  const SizedBox(height: AppTheme.padding),
                  if (_isSearching)
                    const Center(child: CircularProgressIndicator())
                  else
                    MatchingPhrases(phrases: _matchingPhrases),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
