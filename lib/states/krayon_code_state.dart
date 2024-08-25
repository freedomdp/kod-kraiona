import 'package:equatable/equatable.dart';

class KrayonCodeState extends Equatable {
  final Map<String, dynamic> result;
  final List<String> matchingPhrases;
  final String secondLevelPhrase;
  final Map<String, dynamic> secondLevelResult;
  final List<String> secondLevelPhrases;
  final bool isLoading;
  final String error;

  const KrayonCodeState({
    this.result = const {},
    this.matchingPhrases = const [],
    this.secondLevelPhrase = '',
    this.secondLevelResult = const {},
    this.secondLevelPhrases = const [],
    this.isLoading = false,
    this.error = '',
  });

  KrayonCodeState copyWith({
    Map<String, dynamic>? result,
    List<String>? matchingPhrases,
    String? secondLevelPhrase,
    Map<String, dynamic>? secondLevelResult,
    List<String>? secondLevelPhrases,
    bool? isLoading,
    String? error,
  }) {
    return KrayonCodeState(
      result: result ?? this.result,
      matchingPhrases: matchingPhrases ?? this.matchingPhrases,
      secondLevelPhrase: secondLevelPhrase ?? this.secondLevelPhrase,
      secondLevelResult: secondLevelResult ?? this.secondLevelResult,
      secondLevelPhrases: secondLevelPhrases ?? this.secondLevelPhrases,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [result, matchingPhrases, secondLevelPhrase, secondLevelResult, secondLevelPhrases, isLoading, error];
}
