import 'package:flutter/material.dart';
import 'package:moneybook/core/utils/number_formatter.dart';

import '../../../../../core/theme/colors.dart';
import '../../../domain/entities/categorie_stats.dart';

class CategoriePercentageCard extends StatefulWidget {
  final CategorieStats categorieStats;
  final int index;

  const CategoriePercentageCard({
    super.key,
    required this.categorieStats,
    required this.index,
  });

  @override
  State<CategoriePercentageCard> createState() => _CategoriePercentageCardState();
}

class _CategoriePercentageCardState extends State<CategoriePercentageCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: pieChartColors[widget.index % pieChartColors.length], width: 3.5)),
          ),
          child: ListTile(
            title: Text('${widget.categorieStats.percentage.toStringAsFixed(1).replaceAll('.', ',')} % ${widget.categorieStats.categorie}'),
            trailing: Text(
              formatToMoneyAmount(widget.categorieStats.amount.toString()),
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
        ),
      ),
    );
  }
}
