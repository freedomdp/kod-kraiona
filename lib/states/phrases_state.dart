import 'package:equatable/equatable.dart';

class PhrasesState extends Equatable {
  final List<List<String>> phrases;
  final List<List<String>> searchResults;
  final bool isLoading;
  final bool isSearching;
  final String error;

  const PhrasesState({
    this.phrases = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.isSearching = false,
    this.error = '',
  });

  PhrasesState copyWith({
    List<List<String>>? phrases,
    List<List<String>>? searchResults,
    bool? isLoading,
    bool? isSearching,
    String? error,
  }) {
    return PhrasesState(
      phrases: phrases ?? this.phrases,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [phrases, searchResults, isLoading, isSearching, error];
}
