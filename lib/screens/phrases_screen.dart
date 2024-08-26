import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../blocs/phrases_bloc.dart';
import '../events/phrases_event.dart';
import '../states/phrases_state.dart';
import '../widgets/phrases_table_widget.dart';
import '../widgets/search_field.dart';
import '../theme/app_theme.dart';

class PhrasesScreen extends StatelessWidget {
  const PhrasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhrasesBloc, PhrasesState>(
      listener: (context, state) {
        developer.log('PhrasesState updated: ${state.phrases.length} phrases, isLoading: ${state.isLoading}');
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Фрази та їх коди'),
                Text(
                  'база з ${state.allPhrases.length} фраз',
                  style: AppTheme.smallBodyStyle.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.calculate),
                onPressed: () {
                  context.read<PhrasesBloc>().add(RecalculateAndUpload());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Обробка даних, зачекайте оновлення сторінки'),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppTheme.maxWidth),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.padding),
                child: Column(
                  children: [
                    SearchField(
                      onSearch: (code) => context.read<PhrasesBloc>().add(SearchPhrases(code)),
                      onClear: () => context.read<PhrasesBloc>().add(ClearSearch()),
                    ),
                    const SizedBox(height: AppTheme.padding),
                    Expanded(
                      child: state.isLoading && state.phrases.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : state.error.isNotEmpty
                              ? Center(child: Text(state.error, style: const TextStyle(color: AppTheme.errorColor)))
                              : PhrasesTableWidget(
                                  phrases: state.isSearching ? state.searchResults : state.phrases,
                                  hasReachedMax: state.hasReachedMax,
                                  isSearchResult: state.isSearching,
                                  onLoadMore: () async {
                                    if (!state.isSearching && !state.hasReachedMax) {
                                      context.read<PhrasesBloc>().add(LoadMorePhrases());
                                    }
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
