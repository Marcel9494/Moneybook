import 'package:flutter/material.dart';

import '../bottom_sheets/categorie_bottom_sheet.dart';

class CategorieInputField extends StatelessWidget {
  final TextEditingController categorieController;
  final String errorText;

  const CategorieInputField({
    super.key,
    required this.categorieController,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: categorieController,
      showCursor: false,
      readOnly: true,
      onTap: () => openCategorieBottomSheet(
        context: context,
        title: 'Kategorie auswählen:',
        controller: categorieController,
      ),
      decoration: InputDecoration(
        hintText: 'Kategorie...',
        counterText: '',
        prefixIcon: const Icon(Icons.donut_small),
        errorText: errorText.isEmpty ? null : errorText,
      ),
    );
  }
}
