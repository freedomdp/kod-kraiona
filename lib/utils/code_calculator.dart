import 'constants.dart';

class CodeCalculator {
  static int calculateCode(String input) {
    int total = 0;
    for (var char in input.toLowerCase().split('')) {
      if (AppConstants.ukrainianAlphabet.contains(char)) {
        total += AppConstants.ukrainianAlphabet.indexOf(char) + 1;
      }
    }
    return total;
  }
}
