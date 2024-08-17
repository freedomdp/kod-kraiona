import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KrayonCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const KrayonCodeInput({
    super.key,
    required this.controller,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Введіть фразу',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.delete, color: theme.hintColor),
          onPressed: onClear,
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[а-щьюяґєіїА-ЩЬЮЯҐЄІЇ\s' ']')),
      ],
    );
  }
}
