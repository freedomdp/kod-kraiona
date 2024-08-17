import 'package:flutter/material.dart';

class MatchingPhrases extends StatelessWidget {
  final List<String> phrases;

  const MatchingPhrases({super.key, required this.phrases});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (phrases.isEmpty) {
      return Text(
        'Відповідних словосполучень не знайдено',
        style: theme.textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Відповідні словосполучення:',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        ...phrases.map((phrase) => Text(
          phrase,
          style: theme.textTheme.bodyMedium,
        )),
      ],
    );
  }
}
