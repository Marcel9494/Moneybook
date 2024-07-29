import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BudgetOverviewChart extends StatefulWidget {
  const BudgetOverviewChart({super.key});

  @override
  State<BudgetOverviewChart> createState() => _BudgetOverviewChartState();
}

class _BudgetOverviewChartState extends State<BudgetOverviewChart> {
  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 13.0,
      animation: true,
      percent: 0.7,
      center: const Text(
        "70.0%",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
      footer: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "Gesamt: 100€ / 500€",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.cyan,
    );
  }
}
