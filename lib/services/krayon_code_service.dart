//логика расчета кода Крайона

class KrayonCodeResult {
  final int total;
  final String details;

  KrayonCodeResult(this.total, this.details);
}

class KrayonCodeService {
  static const ukrainianAlphabet = 'абвгґдеєжзиіїйклмнопрстуфхцчшщьюя';

  static KrayonCodeResult calculate(String input) {
    int total = 0;
    String details = '';

    try {
      for (var char in input.toLowerCase().split('')) {
        if (ukrainianAlphabet.contains(char)) {
          int number = ukrainianAlphabet.indexOf(char) + 1;
          total += number;
          details += '$char: $number\n';
        }
      }
      return KrayonCodeResult(total, details);
    } catch (e) {
      throw Exception('Помилка при розрахунку коду: ${e.toString()}');
    }
  }
}
