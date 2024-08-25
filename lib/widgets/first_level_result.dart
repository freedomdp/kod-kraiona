import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FirstLevelResult extends StatelessWidget {
  final int code;
  final List<String> phrases;

  const FirstLevelResult({
    super.key,
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
          'І рівень',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.padding / 2),
        if (phrases.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: AppTheme.padding,
              mainAxisSpacing: AppTheme.padding / 2,
            ),
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              return Text(
                phrases[index],
                style: AppTheme.smallBodyStyle,
                softWrap: true,
                overflow: TextOverflow.visible,
              );
            },
          ),
        ],
      ],
    );
  }
}
