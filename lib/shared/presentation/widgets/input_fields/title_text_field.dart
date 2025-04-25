import 'package:flutter/material.dart';

import '../../../../core/utils/app_localizations.dart';

class TitleTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController titleController;
  final int maxLength;
  final bool autofocus;
  final FocusNode focusNode = FocusNode();

  TitleTextField({
    super.key,
    required this.hintText,
    required this.titleController,
    this.maxLength = 50,
    this.autofocus = false,
  });

  String? _checkTextInput(BuildContext context) {
    if (titleController.text.isEmpty) {
      return AppLocalizations.of(context).translate('leerer_titel');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      maxLength: maxLength,
      autofocus: autofocus,
      focusNode: focusNode,
      textAlignVertical: TextAlignVertical.center,
      textCapitalization: TextCapitalization.sentences,
      validator: (input) => _checkTextInput(context),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(Icons.title_rounded),
        suffixIcon: IconButton(
          onPressed: () => {
            titleController.text = '',
            FocusScope.of(context).requestFocus(focusNode), // Setzt den Fokus und öffnet die Tastatur
          },
          icon: const Icon(Icons.clear_rounded),
        ),
      ),
    );
  }
}
