import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/krayon_code_bloc.dart';
import '../events/krayon_code_event.dart';
import '../states/krayon_code_state.dart';
import '../widgets/krayon_code_input.dart';
import '../widgets/krayon_code_result.dart';
import '../theme/app_theme.dart';
import 'phrases_screen.dart';

class KrayonCodeCalculator extends StatelessWidget {
  const KrayonCodeCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KrayonCodeBloc(context.read()),
      child: const KrayonCodeCalculatorView(),
    );
  }
}

class KrayonCodeCalculatorView extends StatefulWidget {
  const KrayonCodeCalculatorView({super.key});

  @override
  KrayonCodeCalculatorViewState createState() => KrayonCodeCalculatorViewState();
}

class KrayonCodeCalculatorViewState extends State<KrayonCodeCalculatorView> {
  void _onTextChanged(String text) {
    context.read<KrayonCodeBloc>().add(CalculateCode(text));
  }

  void _clearInput() {
    context.read<KrayonCodeBloc>().add(ClearInput());
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
      body: BlocBuilder<KrayonCodeBloc, KrayonCodeState>(
        builder: (context, state) {
          return Center(
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
                      onTextChanged: _onTextChanged,
                      onClear: _clearInput,
                    ),
                    const SizedBox(height: AppTheme.padding),
                    if (state.result != null && state.result['total'] != null)
                      KrayonCodeResult(
                        result: state.result,
                        matchingPhrases: state.matchingPhrases,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
