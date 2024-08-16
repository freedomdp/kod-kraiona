import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/krayon_code_service.dart';
import '../config/app_version.dart';
import 'phrases_screen.dart';

class KrayonCodeCalculator extends StatefulWidget {
  const KrayonCodeCalculator({Key? key}) : super(key: key);

  @override
  _KrayonCodeCalculatorState createState() => _KrayonCodeCalculatorState();
}

class _KrayonCodeCalculatorState extends State<KrayonCodeCalculator> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic> _result = {};

  // Максимальна ширина додатка
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
    super.dispose();
  }

  void _onTextChanged() {
    final input = _controller.text;
    if (input.isEmpty) {
      setState(() {
        _result = {};
      });
      return;
    }

    final result = KrayonCodeService.calculate(input);
    setState(() {
      _result = result;
    });
  }

  void _clearInput() {
    _controller.clear();
    setState(() {
      _result = {};
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
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Введіть фразу',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.delete, color: theme.hintColor),
                      onPressed: _clearInput,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[а-щьюяґєіїА-ЩЬЮЯҐЄІЇ\s' ']')),
                  ],
                ),
                const SizedBox(height: 20),
                if (_result.isNotEmpty) ...[
                  Text(
                    'Розрахований код: ${_result['total']}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...(_result['details'] as List<Map<String, dynamic>>)
                      .map((detail) => Text(
                            '${detail['char'].toUpperCase()} - ${detail['value']}',
                            style: theme.textTheme.bodyMedium,
                          )),
                ],
              ],
            ),
          ),
        ),
      ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Text(
              AppVersion.getFullVersion(),
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
