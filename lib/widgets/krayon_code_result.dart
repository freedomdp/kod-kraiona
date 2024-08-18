import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KrayonCodeResult extends StatelessWidget {
  final Map<String, dynamic> result;

  const KrayonCodeResult({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleLarge,
        children: [
          const TextSpan(
              text: 'Розрахований код: ',
              style: TextStyle(color: AppTheme.accentColor)),
          TextSpan(
            text: '${result['total']}',
            style: const TextStyle(color: AppTheme.accentColor),
          ),
        ],
      ),
    );
  }
}
