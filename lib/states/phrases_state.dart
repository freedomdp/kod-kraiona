class PhrasesState {
  final List<List<String>> allPhrases;
  final List<List<String>> phrases;
  final List<List<String>> searchResults;
  final bool isLoading;
  final bool isSearching;
  final String error;
  final bool hasReachedMax;

  const PhrasesState({
    this.allPhrases = const [],
    this.phrases = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.isSearching = false,
    this.error = '',
    this.hasReachedMax = false,
  });

  PhrasesState copyWith({
    List<List<String>>? allPhrases,
    List<List<String>>? phrases,
    List<List<String>>? searchResults,
    bool? isLoading,
    bool? isSearching,
    String? error,
    bool? hasReachedMax,
  }) {
    return PhrasesState(
      allPhrases: allPhrases ?? this.allPhrases,
      phrases: phrases ?? this.phrases,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
