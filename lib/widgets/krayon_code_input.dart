import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KrayonCodeInput extends StatefulWidget {
  final Function(String) onTextChanged;
  final VoidCallback onClear;

  const KrayonCodeInput({
    super.key,
    required this.onTextChanged,
    required this.onClear,
  });

  @override
  KrayonCodeInputState createState() => KrayonCodeInputState();
}

class KrayonCodeInputState extends State<KrayonCodeInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.onTextChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Введіть фразу',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.delete, color: theme.hintColor),
          onPressed: () {
            _controller.clear();
            widget.onClear();
          },
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[а-щьюяґєіїА-ЩЬЮЯҐЄІЇ\s' ']')),
      ],
    );
  }
}
