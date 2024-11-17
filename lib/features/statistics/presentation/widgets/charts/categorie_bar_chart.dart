import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../../bookings/domain/entities/booking.dart';
import '../../../../bookings/domain/value_objects/amount_type.dart';
import '../../../../bookings/domain/value_objects/booking_type.dart';
import 'legend.dart';

class CategorieBarChart extends StatefulWidget {
  final List<Booking> bookings;
  final BookingType bookingType;
  final DateTime selectedDate;
  final AmountType amountType;
  final Color leftBarColor = Colors.greenAccent;
  final Color midBarColor = Colors.redAccent;
  final Color rightBarColor = Colors.cyanAccent;
  final Color avgColor = Colors.orange;

  CategorieBarChart({
    super.key,
    required this.bookings,
    required this.bookingType,
    required this.selectedDate,
    required this.amountType,
  });

  @override
  State<StatefulWidget> createState() => CategorieBarChartState();
}

class CategorieBarChartState extends State<CategorieBarChart> {
  MapEntry<String, double> _maxAmountEntry = MapEntry("", 0.0);
  Map<String, double> _monthlyAmountSums = {};
  late List<BarChartGroupData> _rawBarGroups;
  late List<BarChartGroupData> _showingBarGroups;
  List<BarChartGroupData> _items = [];
  int touchedGroupIndex = -1;

  String _getFirstAmountType() {
    if (BookingType.expense == widget.bookingType) {
      return AmountType.overallExpense.name;
    } else if (BookingType.income == widget.bookingType) {
      return AmountType.overallIncome.name;
    } else if (BookingType.investment == widget.bookingType) {
      return AmountType.buy.name;
    }
    return '';
  }

  String _getSecondAmountType() {
    if (BookingType.expense == widget.bookingType) {
      return AmountType.variable.name;
    } else if (BookingType.income == widget.bookingType) {
      return AmountType.active.name;
    } else if (BookingType.investment == widget.bookingType) {
      return AmountType.sale.name;
    }
    return '';
  }

  String _getThirdAmountType() {
    if (BookingType.expense == widget.bookingType) {
      return AmountType.fix.name;
    } else if (BookingType.income == widget.bookingType) {
      return AmountType.passive.name;
    }
    return '';
  }

  List<BarChartGroupData> _calculateMonthlyAmounts(List<Booking> bookings) {
    _monthlyAmountSums.clear();
    for (int i = 6; i >= 0; i--) {
      DateTime currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month - i, 1);
      String monthKey = "${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}";
      _monthlyAmountSums[monthKey] = 0.0;
    }
    for (Booking booking in bookings) {
      String monthKey = "${booking.date.year}-${booking.date.month.toString().padLeft(2, '0')}";
      _monthlyAmountSums.update(monthKey, (value) => value + booking.amount, ifAbsent: () => booking.amount);
    }

    _items.clear();
    List<double> monthlyAmounts = _monthlyAmountSums.values.toList();
    for (int i = 0; i < monthlyAmounts.length; i++) {
      _items.add(makeGroupData(i, monthlyAmounts[i], 0));
    }
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    _items = _calculateMonthlyAmounts(widget.bookings);
    _maxAmountEntry = _monthlyAmountSums.entries.reduce((a, b) => a.value > b.value ? a : b);
    _rawBarGroups = _items;
    _showingBarGroups = _rawBarGroups;
    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                LegendsListWidget(
                  legends: [
                    Legend(_getFirstAmountType(), Colors.cyanAccent),
                    Legend(_getSecondAmountType(), Colors.redAccent),
                    BookingType.investment == widget.bookingType ? Legend('', Colors.transparent) : Legend(_getThirdAmountType(), Colors.greenAccent),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: _maxAmountEntry.value,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: ((group) {
                        return Colors.grey;
                      }),
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          _showingBarGroups = List.of(_rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          _showingBarGroups = List.of(_rawBarGroups);
                          return;
                        }
                        _showingBarGroups = List.of(_rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod in _showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum / _showingBarGroups[touchedGroupIndex].barRods.length;

                          _showingBarGroups[touchedGroupIndex] = _showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: _showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                              return rod.copyWith(toY: avg, color: widget.avgColor);
                            }).toList(),
                          );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 36.0,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 56.0,
                        interval: 1.0,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _showingBarGroups,
                  gridData: const FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14.0,
    );
    String amountText = '';
    if (value == 0) {
      amountText = formatToMoneyAmount('0', withoutDecimalPlaces: 0);
    } else if (value == (_maxAmountEntry.value / 2).round()) {
      amountText = formatToMoneyAmount((_maxAmountEntry.value / 2).toString(), withoutDecimalPlaces: 0);
    } else if (value == (_maxAmountEntry.value).floor()) {
      amountText = formatToMoneyAmount(_maxAmountEntry.value.toString(), withoutDecimalPlaces: 0);
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(amountText, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    List<String> months = [];
    for (int i = 6; i >= 0; i--) {
      DateTime monthDate = DateTime(widget.selectedDate.year, widget.selectedDate.month - i);
      String monthName = DateFormat('MMM', 'de-DE').format(monthDate);
      months.add(monthName);
    }

    if (value.toInt() >= months.length) {
      return Container(); // Avoid out-of-bound errors
    }

    final Widget monthText = Text(
      months[value.toInt()],
      style: TextStyle(
        color: value.toInt() != 6 ? Color(0xff7589a2) : Colors.cyanAccent, // Highlight current month
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16.0,
      child: monthText,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4.0,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.greenAccent,
          width: widget.bookingType.name == BookingType.investment.name ? 7.0 : 12.0,
        ),
        widget.bookingType.name == BookingType.investment.name
            ? BarChartRodData(
                toY: y2,
                color: Colors.redAccent,
                width: 7.0,
              )
            : BarChartRodData(
                toY: 0.0,
                color: Colors.redAccent,
                width: 0.0,
              ),
      ],
    );
  }
}
