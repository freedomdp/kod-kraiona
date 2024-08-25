import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MatchingPhrasesResult extends StatelessWidget {
  final List<String> phrases;

  const MatchingPhrasesResult({Key? key, required this.phrases}) : super(key: key);

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
    );
  }
}
