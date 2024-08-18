import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/krayon_code_event.dart';
import '../states/krayon_code_state.dart';
import '../repositories/google_sheets_repository.dart';

class KrayonCodeBloc extends Bloc<KrayonCodeEvent, KrayonCodeState> {
  final GoogleSheetsRepository repository;

  KrayonCodeBloc(this.repository) : super(const KrayonCodeState()) {
    on<CalculateCode>(_onCalculateCode);
    on<ClearInput>(_onClearInput);
  }

  Future<void> _onCalculateCode(CalculateCode event, Emitter<KrayonCodeState> emit) async {
    final result = repository.calculateCode(event.input);
    emit(state.copyWith(result: result));

    if (event.input.length >= 4) { // Минимальная длина для поиска
      emit(state.copyWith(isSearching: true));
      final matchingPhrases = await repository.findPhrasesByValue(result['total']);
      emit(state.copyWith(isSearching: false, matchingPhrases: matchingPhrases));
    } else {
      emit(state.copyWith(matchingPhrases: []));
    }
  }

  void _onClearInput(ClearInput event, Emitter<KrayonCodeState> emit) {
    emit(const KrayonCodeState());
  }
}
