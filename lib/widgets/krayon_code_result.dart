import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../utils/number_to_words.dart';

class KrayonCodeResult extends StatelessWidget {
  final Map<String, dynamic> result;
  final List<String> matchingPhrases;
  final Function(String) calculateCode;
  final Function(int) findMatchingPhrases;

  const KrayonCodeResult({
    super.key,
    required this.result,
    required this.matchingPhrases,
    required this.calculateCode,
    required this.findMatchingPhrases,
  });

  @override
  Widget build(BuildContext context) {
    final int firstLevelCode = result['total'] as int;
    final String secondLevelPhrase = NumberToWords.convert(firstLevelCode);
    final int secondLevelCode = calculateCode(secondLevelPhrase);
    final List<String> secondLevelPhrases = findMatchingPhrases(secondLevelCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('І рівень', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppTheme.padding / 2),
        _buildLevelResult(context, firstLevelCode, matchingPhrases),
        const SizedBox(height: AppTheme.padding * 2),
        Text('ІІ рівень', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppTheme.padding / 2),
        Text('Фраза: $secondLevelPhrase', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppTheme.padding / 2),
        _buildLevelResult(context, secondLevelCode, secondLevelPhrases),
      ],
    );
  }

  Widget _buildLevelResult(BuildContext context, int code, List<String> phrases) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge,
            children: [
              const TextSpan(
                text: 'Розрахований код: ',
                style: TextStyle(color: AppTheme.accentColor),
              ),
              TextSpan(
                text: '$code',
                style: const TextStyle(color: AppTheme.accentColor),
              ),
            ],
          ),
        ),
        if (phrases.isNotEmpty) ...[
          const SizedBox(height: AppTheme.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Відповідні словосполучення:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => _copyToClipboard(context, phrases),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.padding / 2),
          _buildPhrasesGrid(context, phrases),
        ],
      ],
    );
  }

  Widget _buildPhrasesGrid(BuildContext context, List<String> phrases) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3, // Уменьшено для обеспечения переноса текста
        crossAxisSpacing: AppTheme.padding,
        mainAxisSpacing: AppTheme.padding / 8,
      ),
      itemCount: phrases.length,
      itemBuilder: (context, index) {
        return Text(
          phrases[index],
          style: AppTheme.smallBodyStyle,
          overflow: TextOverflow.visible, // Изменено для переноса текста
          softWrap: true, // Добавлено для переноса текста
        );
      },
    );
  }

  void _copyToClipboard(BuildContext context, List<String> phrases) {
    final String textToCopy = phrases.join(', ');
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Скопійовано в буфер обміну'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
