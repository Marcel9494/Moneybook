import 'package:flutter/material.dart';

class TitleTextField extends StatelessWidget {
  final TextEditingController titleController;
  final String errorText;

  const TitleTextField({
    super.key,
    required this.titleController,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      maxLength: 80,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Titel...',
        counterText: '',
        prefixIcon: const Icon(Icons.title_rounded),
        suffixIcon: IconButton(
          onPressed: () => {
            titleController.text = '',
          },
          icon: const Icon(Icons.clear_rounded),
        ),
        errorText: errorText.isEmpty ? null : errorText,
      ),
    );
  }
}
