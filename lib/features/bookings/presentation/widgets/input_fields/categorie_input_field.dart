import 'package:flutter/material.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../domain/value_objects/booking_type.dart';
import '../bottom_sheets/categorie_bottom_sheet.dart';

class CategorieInputField extends StatelessWidget {
  final TextEditingController categorieController;
  final Function(String)? onCategorieSelected;
  final BookingType bookingType;

  const CategorieInputField({
    super.key,
    required this.categorieController,
    this.onCategorieSelected,
    required this.bookingType,
  });

  String? _checkCategorieInput(BuildContext context) {
    if (categorieController.text.isEmpty) {
      return AppLocalizations.of(context).translate('leere_kategorie_beschreibung');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: categorieController,
      showCursor: false,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      validator: (input) => _checkCategorieInput(context),
      onTap: () => openCategorieBottomSheet(
        context: context,
        title: AppLocalizations.of(context).translate('kategorie_auswählen') + ':',
        controller: categorieController,
        onCategorieSelected: onCategorieSelected,
        bookingType: bookingType,
      ),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).translate('kategorie') + '...',
        counterText: '',
        prefixIcon: Icon(Icons.donut_small),
      ),
    );
  }
}
