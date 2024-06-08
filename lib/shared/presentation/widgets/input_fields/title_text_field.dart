import 'package:flutter/material.dart';

class TitleTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController titleController;

  const TitleTextField({
    super.key,
    required this.hintText,
    required this.titleController,
  });

  String? _checkTextInput() {
    if (titleController.text.isEmpty) {
      return 'Bitte geben Sie einen Titel ein.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      maxLength: 80,
      textCapitalization: TextCapitalization.sentences,
      validator: (input) => _checkTextInput(),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(Icons.title_rounded),
        suffixIcon: IconButton(
          onPressed: () => {
            titleController.text = '',
          },
          icon: const Icon(Icons.clear_rounded),
        ),
      ),
    );
  }
}
