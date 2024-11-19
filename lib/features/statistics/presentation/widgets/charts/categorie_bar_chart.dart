import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/number_formatter.dart';
import '../../../../../shared/presentation/widgets/deco/half_circle_painter.dart';
import '../../../../bookings/domain/entities/booking.dart';
import '../../../../bookings/domain/value_objects/amount_type.dart';
import '../../../../bookings/domain/value_objects/booking_type.dart';

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
  Map<String, double> _monthlyFirstBarValues = {};
  Map<String, double> _monthlySecondBarValues = {};
  late List<BarChartGroupData> _rawBarGroups;
  late List<BarChartGroupData> _showingBarGroups;
  List<BarChartGroupData> _items = [];
  bool _showSeparatedBars = false;
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
      return '${AmountType.variable.name} / ${AmountType.fix.name}';
    } else if (BookingType.income == widget.bookingType) {
      return '${AmountType.active.name} / ${AmountType.passive.name}';
    } else if (BookingType.investment == widget.bookingType) {
      return AmountType.sale.name;
    }
    return '';
  }

  // TODO hier weitermachen und Gesamt und Variabel/Fix etc. aktuelle Werte anzeigen und Tooltip implementieren
  // TODO Code refactorn
  List<BarChartGroupData> _calculateMonthlyAmounts(List<Booking> bookings) {
    _monthlyAmountSums.clear();
    _monthlyFirstBarValues.clear();
    _monthlySecondBarValues.clear();
    for (int i = 6; i >= 0; i--) {
      DateTime currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month - i, 1);
      String monthKey = "${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}";
      _monthlyAmountSums[monthKey] = 0.0;
      _monthlyFirstBarValues[monthKey] = 0.0;
      _monthlySecondBarValues[monthKey] = 0.0;
    }
    for (Booking booking in bookings) {
      if (_showSeparatedBars == false) {
        String monthKey = "${booking.date.year}-${booking.date.month.toString().padLeft(2, '0')}";
        _monthlyAmountSums.update(monthKey, (value) => value + booking.amount, ifAbsent: () => booking.amount);
      } else {
        String monthKey = "${booking.date.year}-${booking.date.month.toString().padLeft(2, '0')}";
        if (booking.amountType == AmountType.variable || booking.amountType == AmountType.active) {
          _monthlyFirstBarValues.update(monthKey, (value) => value + booking.amount, ifAbsent: () => booking.amount);
        } else if (booking.amountType == AmountType.fix || booking.amountType == AmountType.passive) {
          _monthlySecondBarValues.update(monthKey, (value) => value + booking.amount, ifAbsent: () => booking.amount);
        }
      }
    }

    _items.clear();
    if (_showSeparatedBars == false) {
      List<double> monthlyAmounts = _monthlyAmountSums.values.toList();
      for (int i = 0; i < monthlyAmounts.length; i++) {
        _items.add(makeGroupData(i, monthlyAmounts[i], monthlyAmounts[i], _showSeparatedBars));
      }
    } else {
      List<double> firstBarAmounts = _monthlyFirstBarValues.values.toList();
      List<double> secondBarAmounts = _monthlySecondBarValues.values.toList();
      for (int i = 0; i < secondBarAmounts.length; i++) {
        _items.add(makeGroupData(i, firstBarAmounts[i], secondBarAmounts[i], _showSeparatedBars));
      }
    }
    return _items;
  }

  void _changeBarChartView(bool showSeparatedBars) {
    setState(() {
      _showSeparatedBars = showSeparatedBars;
    });
  }

  @override
  Widget build(BuildContext context) {
    _items = _calculateMonthlyAmounts(widget.bookings);
    // TODO Code refactorn (in eigene Funktion auslagern)
    if (_showSeparatedBars == false) {
      _maxAmountEntry = _monthlyAmountSums.entries.reduce((a, b) => a.value > b.value ? a : b);
    } else {
      MapEntry<String, double> maxFirstBarValue = _monthlyFirstBarValues.entries.reduce((a, b) => a.value > b.value ? a : b);
      MapEntry<String, double> maxSecondBarValue = _monthlySecondBarValues.entries.reduce((a, b) => a.value > b.value ? a : b);
      maxFirstBarValue.value >= maxSecondBarValue.value ? _maxAmountEntry = maxFirstBarValue : _maxAmountEntry = maxSecondBarValue;
    }
    _rawBarGroups = _items;
    _showingBarGroups = _rawBarGroups;
    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 56.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _changeBarChartView(false),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12.0,
                              height: 12.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _showSeparatedBars ? Colors.grey : Colors.cyanAccent,
                              ),
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              _getFirstAmountType(),
                              style: TextStyle(
                                color: _showSeparatedBars ? Color(0xff757391) : Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        Text(formatToMoneyAmount(_monthlyAmountSums.values.last.toString())),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: GestureDetector(
                      onTap: () => _changeBarChartView(true),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12.0,
                                height: 12.0,
                                decoration: _showSeparatedBars
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      )
                                    : BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      ),
                                child: _showSeparatedBars
                                    ? CustomPaint(
                                        painter: HalfCirclePainter(),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                _getSecondAmountType(),
                                style: TextStyle(
                                  color: _showSeparatedBars ? Colors.white : Color(0xff757391),
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(formatToMoneyAmount(_monthlyFirstBarValues.values.last.toString())),
                              Text(' / '),
                              Text(formatToMoneyAmount(_monthlySecondBarValues.values.last.toString())),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*LegendsListWidget(
                    legends: [
                      //Legend(_getFirstAmountType(), Colors.cyanAccent),
                      Legend(_getSecondAmountType(), Colors.redAccent),
                    ],
                  ),*/
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: ClipRect(
                child: BarChart(
                  swapAnimationCurve: Curves.fastOutSlowIn,
                  swapAnimationDuration: Duration(seconds: 1),
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
    } else if (value == (_maxAmountEntry.value).floor() - 4) {
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
      return Container();
    }

    final Widget monthText = Text(
      months[value.toInt()],
      style: TextStyle(
        color: value.toInt() != 6 ? Color(0xff7589a2) : Colors.cyanAccent,
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

  BarChartGroupData makeGroupData(int x, double y1, double y2, bool showTwo) {
    return BarChartGroupData(
      barsSpace: 4.0,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: _showSeparatedBars ? Colors.greenAccent : Colors.cyanAccent,
          width: widget.bookingType.name == BookingType.investment.name ? 7.0 : 12.0,
        ),
        showTwo
            ? BarChartRodData(
                toY: y2,
                color: Colors.redAccent,
                width: widget.bookingType.name == BookingType.investment.name ? 7.0 : 12.0,
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
