import 'package:flutter/material.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:moneybook/features/statistics/presentation/widgets/page_arguments/categorie_statistic_page_arguments.dart';

import '../../../../../core/consts/route_consts.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_localizations.dart';
import '../../../../bookings/domain/value_objects/amount_type.dart';
import '../../../domain/entities/categorie_stats.dart';

class CategoriePercentageCard extends StatefulWidget {
  final CategorieStats categorieStats;
  final int index;
  final DateTime selectedDate;
  final AmountType amountType;

  const CategoriePercentageCard({
    super.key,
    required this.categorieStats,
    required this.index,
    required this.selectedDate,
    required this.amountType,
  });

  @override
  State<CategoriePercentageCard> createState() => _CategoriePercentageCardState();
}

class _CategoriePercentageCardState extends State<CategoriePercentageCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        categorieStatisticRoute,
        arguments: CategorieStatisticPageArguments(
          widget.categorieStats.categorie,
          widget.categorieStats.bookingType,
          widget.selectedDate,
          widget.amountType,
        ),
      ),
      child: Card(
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: pieChartColors[widget.index % pieChartColors.length], width: 3.5)),
            ),
            child: ListTile(
              title: Text(
                '${widget.categorieStats.percentage.toStringAsFixed(1).replaceAll('.', ',')} % ${AppLocalizations.of(context).translate(widget.categorieStats.categorie)}',
                style: const TextStyle(fontSize: 14.0),
              ),
              trailing: Text(
                formatToMoneyAmount(widget.categorieStats.amount.toString()),
                style: TextStyle(fontSize: 14.0, color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
