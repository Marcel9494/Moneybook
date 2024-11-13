import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneybook/core/utils/number_formatter.dart';

import '../../../../bookings/domain/entities/booking.dart';
import '../../../../bookings/domain/value_objects/amount_type.dart';
import '../../../../bookings/domain/value_objects/booking_type.dart';
import 'legend.dart';

class CategorieBarChart extends StatefulWidget {
  final List<Booking> bookings;
  final BookingType bookingType;
  final DateTime selectedDate;
  final Color leftBarColor = Colors.greenAccent;
  final Color midBarColor = Colors.redAccent;
  final Color rightBarColor = Colors.cyanAccent;
  final Color avgColor = Colors.orange;

  CategorieBarChart({
    super.key,
    required this.bookings,
    required this.bookingType,
    required this.selectedDate,
  });

  @override
  State<StatefulWidget> createState() => CategorieBarChartState();
}

class CategorieBarChartState extends State<CategorieBarChart> {
  final double width = 7.0;

  final Map<String, double> _monthlyAmountSums = {};
  MapEntry<String, double> _maxAmountEntry = MapEntry("", 0.0);

  List<BarChartGroupData> items = [];
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  final Map<String, double> _monthlyAmountMap = {};

  @override
  void initState() {
    super.initState();
    items = _calculateMonthlyAmounts(widget.bookings);
    _maxAmountEntry = _monthlyAmountSums.entries.reduce((a, b) => a.value > b.value ? a : b);
    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  List<BarChartGroupData> _calculateMonthlyAmounts(List<Booking> bookings) {
    for (int i = 0; i < 7; i++) {
      DateTime currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month - i, 1);
      String monthKey = "${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}";
      _monthlyAmountSums[monthKey] = 0.0;
    }
    for (Booking booking in bookings) {
      String monthKey = "${booking.date.year}-${booking.date.month.toString().padLeft(2, '0')}";
      _monthlyAmountSums.update(monthKey, (value) => value + booking.amount, ifAbsent: () => booking.amount);
    }
    items = [];
    List<double> monthlyAmounts = _monthlyAmountSums.values.toList();
    for (int i = monthlyAmounts.length - 1; i >= 0; i--) {
      items.add(makeGroupData(i, monthlyAmounts[i], 0));
    }
    _monthlyAmountSums.forEach((month, totalAmount) {
      print("Monat: $month, Gesamtsumme: $totalAmount €");
    });
    return items;
  }

  // TODO hier weitermachen und bei jedem Datumswechsel neu aufrufen
  List<BarChartGroupData> _calculateDiagramValues() {
    _monthlyAmountMap.clear();
    for (int i = 6; i >= 0; i--) {
      DateTime monthDate = DateTime(widget.selectedDate.year, widget.selectedDate.month - i);
      String monthName = DateFormat('MMMM', 'de-DE').format(monthDate);
      _monthlyAmountMap[monthName] = 0.0;
    }
    for (int i = 0; i < widget.bookings.length; i++) {
      if (widget.bookings[i].type == widget.bookingType) {
        DateTime monthDate = DateTime(widget.bookings[i].date.year, widget.bookings[i].date.month, widget.bookings[i].date.day);
        String monthName = DateFormat('MMMM', 'de-DE').format(monthDate);
        double? monthlyAmount = 0.0;
        monthlyAmount = _monthlyAmountMap[monthName];
        _monthlyAmountMap[monthName] = monthlyAmount! + widget.bookings[i].amount;
      }
    }
    items = [];
    List<double> monthlyAmounts = _monthlyAmountMap.values.toList();
    for (int i = 0; i < monthlyAmounts.length; i++) {
      items.add(makeGroupData(i, monthlyAmounts[i], 0));
    }
    return items;
  }

  String _getFirstAmountType() {
    if (BookingType.expense.name == widget.bookingType.name) {
      return AmountType.variable.name;
    } else if (BookingType.income.name == widget.bookingType.name) {
      return AmountType.active.name;
    } else if (BookingType.investment.name == widget.bookingType.name) {
      return AmountType.buy.name;
    }
    return '';
  }

  String _getSecondAmountType() {
    if (BookingType.expense.name == widget.bookingType.name) {
      return AmountType.fix.name;
    } else if (BookingType.income.name == widget.bookingType.name) {
      return AmountType.passive.name;
    } else if (BookingType.investment.name == widget.bookingType.name) {
      return AmountType.sale.name;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
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
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum / showingBarGroups[touchedGroupIndex].barRods.length;

                          showingBarGroups[touchedGroupIndex] = showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
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
                        reservedSize: 60.0,
                        interval: 1.0,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: showingBarGroups,
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

  // TODO hier weitermachen aktuellen Monat farblich (cyanAccent) hervorheben im bottomTitle
  // TODO Variabel Fix mit Gesamt erweitern + andere Optionen
  // TODO Angezeigte Werte aufrunden und Anzeige perfektionieren
  // TODO Chart aktualisieren, wenn Monat gewechselt wird
  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14.0,
    );
    String amountText = '';
    if (value == 0) {
      amountText = '0,00 €';
    } else if (value == (_maxAmountEntry.value / 2).round()) {
      amountText = formatToMoneyAmount((_maxAmountEntry.value / 2).toString());
    } else if (value == (_maxAmountEntry.value).floor()) {
      amountText = formatToMoneyAmount(_maxAmountEntry.value.toString());
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
    for (int i = 0; i < 7; i++) {
      DateTime monthDate = DateTime(widget.selectedDate.year, widget.selectedDate.month - i);
      String monthName = DateFormat('MMM', 'de-DE').format(monthDate);
      months.add(monthName);
    }

    final Widget monthText = Text(
      months[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
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
          color: widget.leftBarColor,
          width: widget.bookingType.name == BookingType.investment.name ? width : 12.0,
        ),
        widget.bookingType.name == BookingType.investment.name
            ? BarChartRodData(
                toY: y2,
                color: widget.midBarColor,
                width: width,
              )
            : BarChartRodData(
                toY: 0.0,
                color: widget.midBarColor,
                width: 0.0,
              ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
/*import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'legend.dart';

class CategorieBarChart extends StatelessWidget {
  const CategorieBarChart({super.key});

  final pilateColor = Colors.purpleAccent;
  final cyclingColor = Colors.cyanAccent;
  final quickWorkoutColor = Colors.blueAccent;
  final betweenSpace = 0.2;

  BarChartGroupData generateGroupData(int x, double pilates, double quickWorkout, double cycling) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: pilates,
          color: pilateColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout,
          color: quickWorkoutColor,
          width: 5,
        ),
        BarChartRodData(
          fromY: pilates + betweenSpace + quickWorkout + betweenSpace,
          toY: pilates + betweenSpace + quickWorkout + betweenSpace + cycling,
          color: cyclingColor,
          width: 5,
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'JAN';
        break;
      case 1:
        text = 'FEB';
        break;
      case 2:
        text = 'MAR';
        break;
      case 3:
        text = 'APR';
        break;
      case 4:
        text = 'MAY';
        break;
      case 5:
        text = 'JUN';
        break;
      case 6:
        text = 'JUL';
        break;
      case 7:
        text = 'AUG';
        break;
      case 8:
        text = 'SEP';
        break;
      case 9:
        text = 'OCT';
        break;
      case 10:
        text = 'NOV';
        break;
      case 11:
        text = 'DEC';
        break;
      default:
        text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${value.toInt()}0k';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legende',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LegendsListWidget(
            legends: [
              Legend('Aktiv', pilateColor),
              Legend('Passiv', quickWorkoutColor),
              Legend('Undefiniert', cyclingColor),
            ],
          ),
          const SizedBox(height: 14),
          AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: leftTitles,
                      interval: 5,
                      reservedSize: 42,
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 20,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(enabled: true),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: [
                  generateGroupData(0, 2, 3, 2),
                  generateGroupData(1, 2, 5, 1.7),
                  generateGroupData(2, 1.3, 3.1, 2.8),
                  generateGroupData(3, 3.1, 4, 3.1),
                  generateGroupData(4, 0.8, 3.3, 3.4),
                  generateGroupData(5, 2, 5.6, 1.8),
                  generateGroupData(6, 1.3, 3.2, 2),
                  generateGroupData(7, 2.3, 3.2, 3),
                  generateGroupData(8, 2, 4.8, 2.5),
                  generateGroupData(9, 1.2, 3.2, 2.5),
                  generateGroupData(10, 1, 4.8, 3),
                  generateGroupData(11, 2, 4.4, 2.8),
                ],
                maxY: 11 + (betweenSpace * 3),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 3.3,
                      color: pilateColor,
                      strokeWidth: 1,
                      dashArray: [20, 4],
                    ),
                    HorizontalLine(
                      y: 8,
                      color: quickWorkoutColor,
                      strokeWidth: 1,
                      dashArray: [20, 4],
                    ),
                    HorizontalLine(
                      y: 11,
                      color: cyclingColor,
                      strokeWidth: 1,
                      dashArray: [20, 4],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
