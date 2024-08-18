import 'package:equatable/equatable.dart';

class KrayonCodeState extends Equatable {
  final Map<String, dynamic> result;
  final List<String> matchingPhrases;
  final bool isSearching;
  final String error;

  const KrayonCodeState({
    this.result = const {},
    this.matchingPhrases = const [],
    this.isSearching = false,
    this.error = '',
  });

  KrayonCodeState copyWith({
    Map<String, dynamic>? result,
    List<String>? matchingPhrases,
    bool? isSearching,
    String? error,
  }) {
    return KrayonCodeState(
      result: result ?? this.result,
      matchingPhrases: matchingPhrases ?? this.matchingPhrases,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [result, matchingPhrases, isSearching, error];
}
