import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CalculatedCodeResult extends StatelessWidget {
  final int code;
  final VoidCallback onCopy;

  const CalculatedCodeResult({
    super.key,
    required this.code,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: AppTheme.padding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  const TextSpan(text: 'Розрахований код: '),
                  TextSpan(
                    text: '$code',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: AppTheme.accentColor),
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}
