import 'package:flutter/material.dart';

import '../../../../categories/domain/value_objects/categorie_type.dart';

class CategorieTypeChoiceChips extends StatefulWidget {
  final List<CategorieType> categorieTypes;
  final Function onSelected;
  final List<bool> selectedCategorieValue;

  const CategorieTypeChoiceChips({
    super.key,
    required this.categorieTypes,
    required this.onSelected,
    required this.selectedCategorieValue,
  });

  @override
  State<CategorieTypeChoiceChips> createState() => _CategorieTypeChoiceChipsState();
}

class _CategorieTypeChoiceChipsState extends State<CategorieTypeChoiceChips> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 10.0),
        Wrap(
          spacing: 5.0,
          children: List<Widget>.generate(
            widget.categorieTypes.length,
            (int index) {
              return ChoiceChip(
                label: Text(widget.categorieTypes[index].name),
                selected: widget.selectedCategorieValue[index],
                onSelected: (newSelectedValue) => widget.onSelected(newSelectedValue, index),
                /*onSelected: (bool selected) {
                  setState(() {
                    _value = (selected ? index : null)!;
                    if (_value == 0) {
                      widget.selectedCategorieType = CategorieType.expense;
                    } else if (_value == 1) {
                      widget.selectedCategorieType = CategorieType.income;
                    } else if (_value == 2) {
                      widget.selectedCategorieType = CategorieType.investment;
                    }
                  });
                },*/
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
