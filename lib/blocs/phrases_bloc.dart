import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/phrases_event.dart';
import '../states/phrases_state.dart';
import '../repositories/google_sheets_repository.dart';

class PhrasesBloc extends Bloc<PhrasesEvent, PhrasesState> {
  final GoogleSheetsRepository repository;

  PhrasesBloc(this.repository) : super(PhrasesState()) {
    on<LoadPhrases>(_onLoadPhrases);
    on<SearchPhrases>(_onSearchPhrases);
    on<RecalculateAndUpload>(_onRecalculateAndUpload);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadPhrases(LoadPhrases event, Emitter<PhrasesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final phrases = await repository.getAllData();
      emit(state.copyWith(phrases: phrases, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onSearchPhrases(SearchPhrases event, Emitter<PhrasesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final searchResults = await repository.findPhrasesByValue(int.parse(event.code));
      emit(state.copyWith(
        searchResults: searchResults.map((phrase) => [phrase, event.code]).toList(),
        isLoading: false,
        isSearching: true,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<PhrasesState> emit) {
    emit(state.copyWith(
      searchResults: [],
      isSearching: false,
    ));
  }

  Future<void> _onRecalculateAndUpload(RecalculateAndUpload event, Emitter<PhrasesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await repository.recalculateAndUpload();
      final updatedPhrases = await repository.getAllData();
      emit(state.copyWith(phrases: updatedPhrases, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
