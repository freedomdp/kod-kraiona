import 'package:flutter/material.dart';

class PhrasesTable extends StatelessWidget {
  final List<List<String>> phrases;

  const PhrasesTable({Key? key, required this.phrases}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Фраза')),
            DataColumn(label: Text('Код')),
          ],
          rows: phrases.map((phrase) {
            return DataRow(cells: [
              DataCell(Text(phrase.isNotEmpty ? phrase[0] : '')),
              DataCell(Text(phrase.length > 1 ? phrase[1] : '')),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
