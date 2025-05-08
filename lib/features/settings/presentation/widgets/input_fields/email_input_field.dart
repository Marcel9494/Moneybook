import 'package:flutter/material.dart';

import '../../../../../core/consts/regex_consts.dart';
import '../../../../../core/utils/app_localizations.dart';

class EmailInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController emailController;
  final int maxLength;
  final bool autofocus;
  final FocusNode focusNode = FocusNode();

  EmailInputField({
    super.key,
    required this.hintText,
    required this.emailController,
    this.maxLength = 60,
    this.autofocus = false,
  });

  String? _checkEmailInput(BuildContext context) {
    if (emailController.text.isEmpty) {
      return null;
    } else {
      if (isEmailValid(emailController.text) == false) {
        return AppLocalizations.of(context).translate('email_ungültig');
      }
    }
    return null;
  }

  bool isEmailValid(String email) {
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      maxLength: maxLength,
      autofocus: autofocus,
      focusNode: focusNode,
      textAlignVertical: TextAlignVertical.center,
      textCapitalization: TextCapitalization.sentences,
      validator: (input) => _checkEmailInput(context),
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        prefixIcon: const Icon(Icons.email_rounded),
        suffixIcon: IconButton(
          onPressed: () => {
            emailController.text = '',
            FocusScope.of(context).requestFocus(focusNode), // Setzt den Fokus und öffnet die Tastatur
          },
          icon: const Icon(Icons.clear_rounded),
        ),
      ),
    );
  }
}
