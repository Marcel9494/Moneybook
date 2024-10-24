import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/core/theme/colors.dart';
import 'package:moneybook/features/bookings/domain/value_objects/amount_type.dart';

import '../../../../../core/consts/common_consts.dart';
import '../../../../bookings/domain/value_objects/booking_type.dart';
import '../../../domain/entities/categorie_stats.dart';
import 'indicator.dart';

class CategoriePieChart extends StatefulWidget {
  final List<CategorieStats> categorieStats;
  final BookingType bookingType;

  const CategoriePieChart({
    super.key,
    required this.categorieStats,
    required this.bookingType,
  });

  @override
  State<StatefulWidget> createState() => CategoriePieChartState();
}

class CategoriePieChartState extends State<CategoriePieChart> {
  int touchedIndex = -1;
  final String _amountType = AmountType.buy.name;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 4.0,
                  centerSpaceRadius: 40.0,
                  sections: widget.categorieStats.isEmpty ? showingEmptySection() : showingSections(widget.categorieStats),
                ),
                swapAnimationDuration: const Duration(milliseconds: animationDurationInMs),
                swapAnimationCurve: Curves.easeOutBack,
              ),
            ),
          ),
          // TODO hier weitermachen und Kauf / Verkauf implementieren neuen Branch erstellen und mit Passiv/Aktiv & Fix/Variabel überlegen
          widget.bookingType.pluralName == BookingType.investment.pluralName
              ? Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => {},
                        child: const Indicator(
                          color: Colors.green,
                          text: 'Kauf',
                          isSquare: true,
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      GestureDetector(
                        onTap: () => {},
                        child: const Indicator(
                          color: Colors.redAccent,
                          text: 'Verkauf',
                          isSquare: true,
                        ),
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<CategorieStats> categorieStats) {
    return List.generate(categorieStats.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 13.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 1)];
      return PieChartSectionData(
        color: pieChartColors[i % pieChartColors.length].withOpacity(0.75),
        value: categorieStats[i].percentage,
        title: '${categorieStats[i].percentage.toStringAsFixed(1)}% ${categorieStats[i].categorie}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          shadows: shadows,
        ),
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
