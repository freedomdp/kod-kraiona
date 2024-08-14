import 'package:flutter/services.dart';

class UkrainianTextFormatter extends TextInputFormatter {
  static const ukrainianLetters = 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя';
  static final RegExp _ukrainianRegex = RegExp(r'[а-щьюяґєіїА-ЩЬЮЯҐЄІЇ\s'']');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.toLowerCase();
    final buffer = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      final char = newText[i];
      if (_ukrainianRegex.hasMatch(char)) {
        buffer.write(char);
      }
    }

    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
