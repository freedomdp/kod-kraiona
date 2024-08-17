import 'package:flutter/material.dart';

class KrayonCodeResult extends StatelessWidget {
  final Map<String, dynamic> result;

  const KrayonCodeResult({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Розрахований код: ${result['total']}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        // вывод кодов на каждый симовол
        //const SizedBox(height: 10),
        //...(result['details'] as List<Map<String, dynamic>>)
        //    .map((detail) => Text(
        //          '${detail['char'].toUpperCase()} - ${detail['value']}',
        //          style: theme.textTheme.bodyMedium,
        //        )),
      ],
    );
  }
}
