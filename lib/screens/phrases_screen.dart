import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<PhrasesBloc, PhrasesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Фрази та їх коди'),
                Text(
                  'база з ${state.phrases.length} фраз',
                  style: AppTheme.smallBodyStyle.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.calculate),
                onPressed: () => context.read<PhrasesBloc>().add(RecalculateAndUpload()),
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
                      child: state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : state.error.isNotEmpty
                              ? Center(child: Text(state.error, style: const TextStyle(color: AppTheme.errorColor)))
                              : state.isSearching
                                  ? PhrasesTableWidget(phrases: state.searchResults)
                                  : PhrasesTableWidget(phrases: state.phrases),
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
