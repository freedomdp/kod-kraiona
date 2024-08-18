import 'package:equatable/equatable.dart';

abstract class KrayonCodeEvent extends Equatable {
  const KrayonCodeEvent();

  @override
  List<Object> get props => [];
}

class CalculateCode extends KrayonCodeEvent {
  final String input;

  const CalculateCode(this.input);

  @override
  List<Object> get props => [input];
}

class SearchMatchingPhrases extends KrayonCodeEvent {
  final int code;

  const SearchMatchingPhrases(this.code);

  @override
  List<Object> get props => [code];
}

class ClearInput extends KrayonCodeEvent {}
