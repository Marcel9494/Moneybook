import 'package:flutter/material.dart';
import 'package:moneybook/core/utils/date_formatter.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:percent_indicator/multi_segment_linear_indicator.dart';

import '../../../domain/entities/goal.dart';

class GoalCard extends StatefulWidget {
  final Goal goal;

  const GoalCard({
    super.key,
    required this.goal,
  });

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.cyanAccent, width: 3.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.goal.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '0 Buchungen', // TODO dynamisch machen
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                    ),
                  ],
                ),
                Text(
                  '${formatToMoneyAmount(((widget.goal.goalAmount - widget.goal.amount) / widget.goal.endDate.difference(widget.goal.startDate).inDays).toString())} pro Tag für ${widget.goal.endDate.difference(widget.goal.startDate).inDays} Tage',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 0.8,
                  height: 16.0,
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormatter.dateFormatDDMMYYDateTime(widget.goal.startDate, context),
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16.0, color: Colors.grey.shade400),
                      ),
                      Text(
                        DateFormatter.dateFormatDDMMYYDateTime(widget.goal.endDate, context),
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16.0, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ),
                // TODO hier weitermachen Werte dynamisch machen
                Stack(
                  alignment: Alignment.center,
                  children: [
                    MultiSegmentLinearIndicator(
                      width: MediaQuery.of(context).size.width - 64,
                      lineHeight: 20.0,
                      barRadius: Radius.circular(6.0),
                      segments: [
                        SegmentLinearIndicator(percent: 0.15, color: Color(0xFFBA0521)),
                        SegmentLinearIndicator(percent: 0.85, color: Color(0xFFEFEFEF)),
                      ],
                      animation: true,
                      animationDuration: 1000,
                      curve: Curves.decelerate,
                      animateFromLastPercent: true,
                    ),
                    Text(
                      "15,0 %",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Center(
                    child: Text(
                      '${formatToMoneyAmount(widget.goal.amount.toString())} / ${formatToMoneyAmount(widget.goal.goalAmount.toString())}',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
