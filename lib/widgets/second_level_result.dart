import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SecondLevelResult extends StatelessWidget {
  final String phrase;
  final int code;
  final List<String> phrases;

  const SecondLevelResult({
    super.key,
    required this.phrase,
    required this.code,
    required this.phrases,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppTheme.padding),
        Text(
          'ІІ рівень',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppTheme.padding / 2),
        //Text('Фраза: $phrase', style: Theme.of(context).textTheme.bodyLarge),
        //Text('Код: $code', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppTheme.padding / 2),
        if (phrases.isNotEmpty) ...[
          const SizedBox(height: AppTheme.padding / 2),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
              crossAxisSpacing: AppTheme.padding,
              mainAxisSpacing: AppTheme.padding / 2,
            ),
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              return Text(
                phrases[index],
                style: AppTheme.smallBodyStyle,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ],
      ],
    );
  }
}
