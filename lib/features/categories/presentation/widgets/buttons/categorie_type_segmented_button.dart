import 'package:flutter/material.dart';

import '../../../domain/value_objects/categorie_type.dart';

class CategorieTypeSegmentedButton extends StatefulWidget {
  CategorieType categorieType;
  Function onSelectionChanged;

  CategorieTypeSegmentedButton({
    super.key,
    required this.categorieType,
    required this.onSelectionChanged,
  });

  @override
  State<CategorieTypeSegmentedButton> createState() => _CategorieTypeSegmentedButtonState();
}

class _CategorieTypeSegmentedButtonState extends State<CategorieTypeSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton(
        segments: <ButtonSegment<CategorieType>>[
          ButtonSegment(
            value: CategorieType.expense,
            label: Text(
              CategorieType.expense.name,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          ButtonSegment(
            value: CategorieType.income,
            label: Text(
              CategorieType.income.name,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
          ButtonSegment(
            value: CategorieType.investment,
            label: Text(
              CategorieType.investment.name,
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ],
        selected: {widget.categorieType},
        onSelectionChanged: (newSelectedValue) => widget.onSelectionChanged(newSelectedValue),
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.0),
              bottom: Radius.circular(4.0),
            ),
          ),
        ),
      ),
    );
  }
}
