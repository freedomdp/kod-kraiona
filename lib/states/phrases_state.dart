import 'package:equatable/equatable.dart';

class PhrasesState extends Equatable {
  final List<List<String>> phrases;
  final bool isLoading;
  final String error;
  final List<List<String>>? searchResults;

  const PhrasesState({
    this.phrases = const [],
    this.isLoading = false,
    this.error = '',
    this.searchResults,
  });

  PhrasesState copyWith({
    List<List<String>>? phrases,
    bool? isLoading,
    String? error,
    List<List<String>>? searchResults,
  }) {
    return PhrasesState(
      phrases: phrases ?? this.phrases,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  @override
  List<Object?> get props => [phrases, isLoading, error, searchResults];
}
