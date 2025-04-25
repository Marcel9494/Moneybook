import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/core/theme/colors.dart';
import 'package:moneybook/features/bookings/domain/value_objects/amount_type.dart';

import '../../../../../core/consts/common_consts.dart';
import '../../../../../core/utils/app_localizations.dart';
import '../../../../bookings/domain/value_objects/booking_type.dart';
import '../../../domain/entities/categorie_stats.dart';

class CategoriePieChart extends StatefulWidget {
  final List<CategorieStats> categorieStats;
  final BookingType bookingType;
  final AmountType amountType;

  const CategoriePieChart({
    super.key,
    required this.categorieStats,
    required this.bookingType,
    required this.amountType,
  });

  @override
  State<StatefulWidget> createState() => CategoriePieChartState();
}

class CategoriePieChartState extends State<CategoriePieChart> {
  int _touchedPieIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1.05,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                    _touchedPieIndex = -1;
                    return;
                  }
                  _touchedPieIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(show: false),
            sectionsSpace: 4.0,
            centerSpaceRadius: 28.0,
            sections: widget.categorieStats.isEmpty ? showingEmptySection() : showingSections(widget.categorieStats),
          ),
          swapAnimationDuration: const Duration(milliseconds: animationDurationInMs),
          swapAnimationCurve: Curves.easeOutBack,
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<CategorieStats> categorieStats) {
    return List.generate(categorieStats.length, (i) {
      final isTouched = i == _touchedPieIndex;
      final fontSize = isTouched ? 18.0 : 13.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: pieChartColors[i % pieChartColors.length].withOpacity(0.75),
        value: categorieStats[i].percentage,
        title: categorieStats.length == 1
            ? '${categorieStats[i].percentage.toStringAsFixed(1).replaceAll('.', ',')}%\n${AppLocalizations.of(context).translate(categorieStats[i].categorie)}'
            : '${categorieStats[i].percentage.toStringAsFixed(1).replaceAll('.', ',')}% ${AppLocalizations.of(context).translate(categorieStats[i].categorie)}',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, color: Colors.white),
      );
    });
  }

  List<PieChartSectionData> showingEmptySection() {
    return List.generate(1, (_) {
      return PieChartSectionData(
        color: Colors.cyanAccent.withOpacity(0.75),
        value: 100.0,
        title: '',
        radius: 50.0,
        titleStyle: const TextStyle(
          fontSize: 13.0,
          color: Colors.white,
        ),
      );
    });
  }
}
