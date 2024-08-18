import 'package:equatable/equatable.dart';

abstract class PhrasesEvent extends Equatable {
  const PhrasesEvent();

  @override
  List<Object> get props => [];
}

class LoadPhrases extends PhrasesEvent {}

class SearchPhrases extends PhrasesEvent {
  final String code;

  const SearchPhrases(this.code);

  @override
  List<Object> get props => [code];
}

class RecalculateAndUpload extends PhrasesEvent {}

class ClearSearch extends PhrasesEvent {}
