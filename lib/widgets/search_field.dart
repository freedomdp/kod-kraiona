import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class SearchField extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onClear;

  const SearchField({Key? key, required this.onSearch, required this.onClear}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 3), () {
      if (_controller.text.length >= 2) {
        widget.onSearch(_controller.text);
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onClear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Пошук за кодом',
        hintText: 'Введіть код',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.delete, color: theme.hintColor),
          onPressed: _clearSearch,
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
