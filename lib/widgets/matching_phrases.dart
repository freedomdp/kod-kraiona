import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MatchingPhrases extends StatelessWidget {
  final List<String> phrases;

  const MatchingPhrases({super.key, required this.phrases});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Відповідні словосполучення:', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                // TODO: Implement copy functionality
              },
            ),
          ],
        ),
        const SizedBox(height: AppTheme.padding / 2),
        Wrap(
          spacing: AppTheme.padding,
          runSpacing: AppTheme.padding / 2,
          children: phrases.map((phrase) => SizedBox(
            width: (MediaQuery.of(context).size.width - 3 * AppTheme.padding) / 2,
            child: Text(phrase, style: AppTheme.smallBodyStyle),
          )).toList(),
        ),
      ],
    );
  }
}
