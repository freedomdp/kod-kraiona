import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PhrasesTableWidget extends StatefulWidget {
  final List<List<String>> phrases;
  final Function() onLoadMore;
  final bool hasReachedMax;

  const PhrasesTableWidget({
    super.key,
    required this.phrases,
    required this.onLoadMore,
    required this.hasReachedMax,
  });

  @override
  State<PhrasesTableWidget> createState() => _PhrasesTableWidgetState();
}

class _PhrasesTableWidgetState extends State<PhrasesTableWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (!_isLoadingMore && !widget.hasReachedMax) {
      setState(() {
        _isLoadingMore = true;
      });
      widget.onLoadMore().then((_) {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.phrases.length + 2, // +1 для заголовка, +1 для индикатора загрузки
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildTableHeader();
        } else if (index == widget.phrases.length + 1) {
          return _isLoadingMore
              ? const Center(child: CircularProgressIndicator())
              : widget.hasReachedMax
                  ? const Center(child: Text('Больше данных нет'))
                  : const SizedBox.shrink();
        } else {
          final phraseIndex = index - 1;
          final phrase = widget.phrases[phraseIndex];
          return _buildTableRow(phrase);
        }
      },
    );
  }

  Widget _buildTableHeader() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
      },
      children: const [
        TableRow(
          decoration: BoxDecoration(color: AppTheme.tableHeaderColor),
          children: [
            TableCell(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Фраза', style: TextStyle(fontWeight: FontWeight.bold)),
            )),
            TableCell(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Код', style: TextStyle(fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildTableRow(List<String> phrase) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          children: [
            TableCell(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(phrase.isNotEmpty ? phrase[0] : '', style: AppTheme.smallBodyStyle),
            )),
            TableCell(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(phrase.length > 1 ? phrase[1] : '', style: AppTheme.smallBodyStyle),
            )),
          ],
        ),
      ],
    );
  }
}
