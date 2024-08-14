import 'package:flutter/material.dart';
import '../services/krayon_code_service.dart';
import '../utils/input_formatters.dart';

class KrayonCodeCalculator extends StatefulWidget {
  const KrayonCodeCalculator({Key? key}) : super(key: key);

  @override
  _KrayonCodeCalculatorState createState() => _KrayonCodeCalculatorState();
}

class _KrayonCodeCalculatorState extends State<KrayonCodeCalculator> {
  String _input = '';
  String _result = '';
  final TextEditingController _controller = TextEditingController();

  void _calculateKrayonCode(String input) {
    try {
      final result = KrayonCodeService.calculate(input);
      setState(() {
        _result = 'Числовий код Крайона: ${result.total}\n\nДеталі:\n${result.details}';
      });
    } catch (e) {
      setState(() {
        _result = 'Помилка: ${e.toString()}';
      });
    }
  }

  void _clearInput() {
    _controller.clear();
    setState(() {
      _input = '';
      _result = '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Код Крайона'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/main_image.jpg',
                    height: 200,
                    width: 200,
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
                    UkrainianTextFormatter(),
                    LowerCaseTextFormatter(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _input = value;
                    });
                    _calculateKrayonCode(value);
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: _result.startsWith('Числовий код Крайона:')
                              ? 'Числовий код Крайона: '
                              : '',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        TextSpan(
                          text: _result.startsWith('Числовий код Крайона:')
                              ? _result.substring('Числовий код Крайона: '.length)
                              : _result,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
