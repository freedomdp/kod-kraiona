import 'package:flutter/material.dart';
import 'dart:async';
import '../services/krayon_code_service.dart';
import 'phrases_screen.dart';
import '../widgets/krayon_code_input.dart';
import '../widgets/krayon_code_result.dart';
import '../widgets/matching_phrases.dart';

class KrayonCodeCalculator extends StatefulWidget {
  const KrayonCodeCalculator({Key? key}) : super(key: key);

  @override
  _KrayonCodeCalculatorState createState() => _KrayonCodeCalculatorState();
}

class _KrayonCodeCalculatorState extends State<KrayonCodeCalculator> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic> _result = {};
  List<String> _matchingPhrases = [];
  Timer? _debounce;

  static const double maxWidth = 400.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(seconds: KrayonCodeService.searchDelay), () {
      final input = _controller.text;
      if (input.isEmpty) {
        setState(() {
          _result = {};
          _matchingPhrases = [];
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
        });
      }
    });
  }

  void _searchMatchingPhrases(int code) async {
    try {
      final phrases = await KrayonCodeService.findMatchingPhrases(code);
      setState(() {
        _matchingPhrases = phrases;
      });
    } catch (e) {
      print('Error searching matching phrases: $e');
      setState(() {
        _matchingPhrases = [];
      });
    }
  }

  void _clearInput() {
    _controller.clear();
    setState(() {
      _result = {};
      _matchingPhrases = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/main_image.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Калькулятор (українська версія)',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    KrayonCodeInput(
                      controller: _controller,
                      onClear: _clearInput,
                    ),
                    const SizedBox(height: 20),
                    if (_result.isNotEmpty) ...[
                      KrayonCodeResult(result: _result),
                      const SizedBox(height: 20),
                      MatchingPhrases(phrases: _matchingPhrases),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
