abstract class PhrasesEvent {}

class LoadPhrases extends PhrasesEvent {}

class LoadMorePhrases extends PhrasesEvent {}

class SearchPhrases extends PhrasesEvent {
  final String code;
  SearchPhrases(this.code);
}

class RecalculateAndUpload extends PhrasesEvent {}

class ClearSearch extends PhrasesEvent {}
