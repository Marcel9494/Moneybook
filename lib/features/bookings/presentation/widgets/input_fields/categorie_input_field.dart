import 'package:flutter/material.dart';

import '../bottom_sheets/categorie_bottom_sheet.dart';

class CategorieInputField extends StatelessWidget {
  final TextEditingController categorieController;

  const CategorieInputField({
    super.key,
    required this.categorieController,
  });

  String? _checkCategorieInput() {
    if (categorieController.text.isEmpty) {
      return 'Bitte wählen Sie eine Kategorie aus.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: categorieController,
      showCursor: false,
      readOnly: true,
      validator: (input) => _checkCategorieInput(),
      onTap: () => openCategorieBottomSheet(
        context: context,
        title: 'Kategorie auswählen:',
        controller: categorieController,
      ),
      decoration: const InputDecoration(
        hintText: 'Kategorie...',
        counterText: '',
        prefixIcon: Icon(Icons.donut_small),
      ),
    );
  }
}
