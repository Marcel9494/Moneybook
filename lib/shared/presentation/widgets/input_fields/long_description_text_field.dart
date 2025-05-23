import 'package:flutter/material.dart';

import '../../../../core/utils/app_localizations.dart';

class LongDescriptionTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController descriptionController;
  final int maxLength;
  final int maxLines;
  final bool autofocus;
  final FocusNode focusNode = FocusNode();

  LongDescriptionTextField({
    super.key,
    required this.hintText,
    required this.descriptionController,
    this.maxLength = 1000,
    this.maxLines = 7,
    this.autofocus = false,
  });

  String? _checkTextInput(BuildContext context) {
    if (descriptionController.text.isEmpty) {
      return AppLocalizations.of(context).translate('leere_beschreibung');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: descriptionController,
      maxLength: maxLength,
      maxLines: maxLines,
      autofocus: autofocus,
      focusNode: focusNode,
      textAlignVertical: TextAlignVertical.center,
      textCapitalization: TextCapitalization.sentences,
      validator: (input) => _checkTextInput(context),
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
        ),
      ),
    );
  }
}
