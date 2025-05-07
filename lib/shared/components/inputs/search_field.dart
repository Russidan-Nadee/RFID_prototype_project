import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  const SearchField({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'ค้นหา',
    this.onClear,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      focusNode: focusNode,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) {
        if (onSubmitted != null) onSubmitted!();
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            controller.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                    if (onClear != null) onClear!();
                  },
                )
                : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
