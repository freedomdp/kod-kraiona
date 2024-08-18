import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class KrayonCodeResult extends StatelessWidget {
  final Map<String, dynamic> result;
  final List<String> matchingPhrases;

  const KrayonCodeResult({
    super.key,
    required this.result,
    required this.matchingPhrases,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge,
            children: [
              const TextSpan(text: 'Розрахований код: '),
              TextSpan(
                text: '${result['total']}',
                style: const TextStyle(color: AppTheme.accentColor),
              ),
            ],
          ),
        ),
        if (matchingPhrases.isNotEmpty) ...[
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
                onPressed: () => _copyToClipboard(context),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.padding / 2),
          _buildPhrasesGrid(context),
        ],
      ],
    );
  }

  Widget _buildPhrasesGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: AppTheme.padding,
        mainAxisSpacing: AppTheme.padding / 2,
      ),
      itemCount: matchingPhrases.length,
      itemBuilder: (context, index) {
        return Text(
          matchingPhrases[index],
          style: AppTheme.smallBodyStyle,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  void _copyToClipboard(BuildContext context) {
    final String textToCopy = matchingPhrases.join(', ');
    Clipboard.setData(ClipboardData(text: textToCopy));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Скопійовано в буфер обміну')),
    );
  }
}
