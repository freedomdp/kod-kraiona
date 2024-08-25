class NumberToWords {
  static const List<String> _units = [
    '',
    'один',
    'два',
    'три',
    'чотири',
    'пʼять',
    'шість',
    'сім',
    'вісім',
    'девʼять',
    'десять',
    'одинадцять',
    'дванадцять',
    'тринадцять',
    'чотирнадцять',
    'пʼятнадцять',
    'шістнадцять',
    'сімнадцять',
    'вісімнадцять',
    'девʼятнадцять'
  ];

  static const List<String> _tens = [
    '',
    '',
    'двадцять',
    'тридцять',
    'сорок',
    'пʼятдесят',
    'шістдесят',
    'сімдесят',
    'вісімдесят',
    'девʼяносто'
  ];

  static const List<String> _hundreds = [
    '',
    'сто',
    'двісті',
    'триста',
    'чотириста',
    'пʼятсот',
    'шістсот',
    'сімсот',
    'вісімсот',
    'девʼятсот'
  ];

  static String convert(int number) {
    if (number < 0 || number > 9999) {
      return 'Число поза діапазоном (0-9999)';
    }

    if (number == 0) {
      return 'нуль';
    }

    String result = '';

    // Обработка тысяч
    if (number >= 1000) {
      int thousands = number ~/ 1000;
      result += _convertLessThanThousand(thousands);
      result += ' ${_getThousandForm(thousands)}';
      number %= 1000;
      if (number > 0) {
        result += ' ';
      }
    }

    // Обработка сотен, десятков и единиц
    if (number > 0) {
      result += _convertLessThanThousand(number);
    }

    return result.trim();
  }

  static String _convertLessThanThousand(int number) {
    String result = '';

    // Сотни
    if (number >= 100) {
      result += '${_hundreds[number ~/ 100]} ';
      number %= 100;
    }

    // Десятки и единицы
    if (number >= 20) {
      result += '${_tens[number ~/ 10]} ';

      number %= 10;
    }

    if (number > 0) {
      result += _units[number] + ' ';
    }

    return result;
  }

  static String _getThousandForm(int number) {
    if (number == 1) {
      return 'тисяча';
    } else if (number >= 2 && number <= 4) {
      return 'тисячі';
    } else {
      return 'тисяч';
    }
  }
}
