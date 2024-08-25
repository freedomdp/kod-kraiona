import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/krayon_code_event.dart';
import '../states/krayon_code_state.dart';
import '../repositories/google_sheets_repository.dart';
import '../utils/constants.dart';
import '../utils/number_to_words.dart';

class KrayonCodeBloc extends Bloc<KrayonCodeEvent, KrayonCodeState> {
  final GoogleSheetsRepository repository;

  KrayonCodeBloc(this.repository) : super(const KrayonCodeState()) {
    on<CalculateCode>(_onCalculateCode);
    on<ClearInput>(_onClearInput);
  }

  Future<void> _onCalculateCode(CalculateCode event, Emitter<KrayonCodeState> emit) async {
    if (event.input.length >= AppConstants.minSearchLength) {
      emit(state.copyWith(isLoading: true));

      // Расчет для I уровня
      final result = repository.calculateCode(event.input);
      final matchingPhrases = await repository.findPhrasesByValue(result['total']);

      // Расчет для II уровня
      final secondLevelPhrase = NumberToWords.convert(result['total']);
      final secondLevelResult = repository.calculateCode(secondLevelPhrase);
      final secondLevelPhrases = await repository.findPhrasesByValue(secondLevelResult['total']);

      emit(state.copyWith(
        isLoading: false,
        result: result,
        matchingPhrases: matchingPhrases,
        secondLevelPhrase: secondLevelPhrase,
        secondLevelResult: secondLevelResult,
        secondLevelPhrases: secondLevelPhrases,
      ));
    } else {
      emit(const KrayonCodeState());
    }
  }

  void _onClearInput(ClearInput event, Emitter<KrayonCodeState> emit) {
    emit(const KrayonCodeState());
  }
}
