import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/krayon_code_input.dart';
import '../widgets/calculated_code_result.dart';
import '../widgets/first_level_result.dart';
import '../widgets/second_level_result.dart';
import '../theme/app_theme.dart';
import '../blocs/krayon_code_bloc.dart';
import '../events/krayon_code_event.dart';
import '../states/krayon_code_state.dart';
import 'phrases_screen.dart';
import 'package:flutter/services.dart';

class KrayonCodeCalculator extends StatelessWidget {
  const KrayonCodeCalculator({super.key});

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
      body: BlocBuilder<KrayonCodeBloc, KrayonCodeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppTheme.maxWidth),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/main_image.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: AppTheme.padding),
                      const Text(
                        'Калькулятор (українська версія)',
                        style: AppTheme.headerStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.padding),
                      KrayonCodeInput(
                        onTextChanged: (text) => context
                            .read<KrayonCodeBloc>()
                            .add(CalculateCode(text)),
                        onClear: () =>
                            context.read<KrayonCodeBloc>().add(ClearInput()),
                      ),
                      const SizedBox(height: AppTheme.padding),
                      if (state.result.isNotEmpty &&
                          state.result['total'] != null)
                        CalculatedCodeResult(
                          code: state.result['total'],
                          onCopy: () => _copyToClipboard(context, state),
                        ),
                      if (state.matchingPhrases.isNotEmpty)
                        FirstLevelResult(
                          code: state.result['total'],
                          phrases: state.matchingPhrases,
                        ),
                      if (state.secondLevelPhrase.isNotEmpty)
                        SecondLevelResult(
                          phrase: state.secondLevelPhrase,
                          code: state.secondLevelResult['total'],
                          phrases: state.secondLevelPhrases,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _copyToClipboard(BuildContext context, KrayonCodeState state) {
    final buffer = StringBuffer();
    buffer.writeln('Розрахований код: ${state.result['total']}');
    buffer.writeln('І рівень');
    buffer.writeln(state.matchingPhrases.join(', '));
    buffer.writeln('ІІ рівень');
    buffer.writeln('Фраза: ${state.secondLevelPhrase}');
    buffer.writeln('Код: ${state.secondLevelResult['total']}');
    buffer.writeln(state.secondLevelPhrases.join(', '));

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Фрази скопійовано до буферу обміну'),
        backgroundColor: AppTheme.primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
