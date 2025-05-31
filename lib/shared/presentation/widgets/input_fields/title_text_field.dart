import 'package:flutter/material.dart';

import '../../../../core/utils/app_localizations.dart';

class TitleTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController titleController;
  final int maxLength;
  final bool autofocus;

  TitleTextField({
    super.key,
    required this.hintText,
    required this.titleController,
    this.maxLength = 50,
    this.autofocus = false,
  });

  @override
  State<TitleTextField> createState() => _TitleTextFieldState();
}

class _TitleTextFieldState extends State<TitleTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Tastatur automatisch öffnen, wenn autofocus gesetzt ist
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }
  }

  String? _checkTextInput(BuildContext context) {
    if (widget.titleController.text.isEmpty) {
      return AppLocalizations.of(context).translate('leerer_titel');
    }
    return null;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.titleController,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      focusNode: _focusNode,
      textAlignVertical: TextAlignVertical.center,
      textCapitalization: TextCapitalization.sentences,
      validator: (input) => _checkTextInput(context),
      decoration: InputDecoration(
        hintText: widget.hintText,
        counterText: '',
        prefixIcon: const Icon(Icons.title_rounded),
        suffixIcon: IconButton(
          onPressed: () => {
            widget.titleController.text = '',
            FocusScope.of(context).requestFocus(_focusNode), // Setzt den Fokus und öffnet die Tastatur
          },
          icon: const Icon(Icons.clear_rounded),
        ),
      ),
    );
  }
}
