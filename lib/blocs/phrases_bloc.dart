import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../events/phrases_event.dart';
import '../states/phrases_state.dart';
import '../repositories/google_sheets_repository.dart';
import '../services/cache_service.dart';

class PhrasesBloc extends Bloc<PhrasesEvent, PhrasesState> {
  final GoogleSheetsRepository repository;
  final CacheService cacheService;
  static const int _itemsPerPage = 50;

  PhrasesBloc(this.repository, this.cacheService) : super(const PhrasesState()) {
    on<LoadPhrases>(_onLoadPhrases);
    on<LoadMorePhrases>(_onLoadMorePhrases);
    on<SearchPhrases>(_onSearchPhrases);
    on<RecalculateAndUpload>(_onRecalculateAndUpload);
    on<ClearSearch>(_onClearSearch);

    add(LoadPhrases());
  }

  Future<void> _onLoadPhrases(LoadPhrases event, Emitter<PhrasesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      developer.log('Trying to load phrases from cache...');
      final allPhrases = await cacheService.getCachedData() ?? await repository.getAllData();
      developer.log('Loaded ${allPhrases.length} phrases');
      final initialPhrases = allPhrases.take(_itemsPerPage).toList();
      emit(state.copyWith(
        allPhrases: allPhrases,
        phrases: initialPhrases,
        isLoading: false,
        hasReachedMax: initialPhrases.length == allPhrases.length,
      ));
    } catch (e) {
      developer.log('Error loading phrases: $e');
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onLoadMorePhrases(LoadMorePhrases event, Emitter<PhrasesState> emit) async {
    if (state.hasReachedMax) return;
    try {
      final nextPhrases = state.allPhrases
          .skip(state.phrases.length)
          .take(_itemsPerPage)
          .toList();
      if (nextPhrases.isNotEmpty) {
        developer.log('Loading more phrases: ${nextPhrases.length}');
        emit(state.copyWith(
          phrases: List.of(state.phrases)..addAll(nextPhrases),
          hasReachedMax: state.phrases.length + nextPhrases.length == state.allPhrases.length,
        ));
      } else {
        emit(state.copyWith(hasReachedMax: true));
      }
    } catch (e) {
      developer.log('Error loading more phrases: $e');
    }
  }

  Future<void> _onSearchPhrases(SearchPhrases event, Emitter<PhrasesState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final searchResults = state.allPhrases
          .where((phrase) => phrase.length > 1 && phrase[1] == event.code)
          .toList();
      developer.log('Found ${searchResults.length} matching phrases');
      emit(state.copyWith(
        searchResults: searchResults,
        isLoading: false,
        isSearching: true,
      ));
    } catch (e) {
      developer.log('Error searching phrases: $e');
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
      await cacheService.cacheData(updatedPhrases);
      developer.log('Recalculated and uploaded ${updatedPhrases.length} phrases');
      emit(state.copyWith(
        allPhrases: updatedPhrases,
        phrases: updatedPhrases.take(_itemsPerPage).toList(),
        isLoading: false,
        hasReachedMax: false,
      ));
    } catch (e) {
      developer.log('Error recalculating and uploading: $e');
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
