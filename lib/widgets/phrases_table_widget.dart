import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PhrasesTableWidget extends StatelessWidget {
  final List<List<String>> phrases;

  const PhrasesTableWidget({super.key, required this.phrases});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1),
        },
        children: [
          const TableRow(
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
          ...phrases.map((phrase) => TableRow(
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
          )),
        ],
      ),
    );
  }
}
