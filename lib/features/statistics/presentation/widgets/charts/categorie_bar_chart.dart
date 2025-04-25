import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/common_consts.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../core/utils/number_formatter.dart';
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
  bool _showSeparatedBars = false;
  int touchedGroupIndex = -1;

  String _getFirstAmountType() {
    if (BookingType.expense == widget.bookingType) {
      return AppLocalizations.of(context).translate(AmountType.overallExpense.name);
    } else if (BookingType.income == widget.bookingType) {
      return AppLocalizations.of(context).translate(AmountType.overallIncome.name);
    } else if (BookingType.investment == widget.bookingType) {
      return AppLocalizations.of(context).translate(AmountType.buy.name);
    }
    return '';
  }

  String _getFirstAmountTypeString() {
    if (BookingType.expense == widget.bookingType) {
      return AppLocalizations.of(context).translate(AmountType.variable.name);
    } else if (BookingType.income == widget.bookingType) {
      return AppLocalizations.of(context).translate(AmountType.active.name);
    } else if (BookingType.investment == widget.bookingType) {
      return AppLocalizations.of(context).translate(AmountType.sale.name);
    }
    return '';
  }

  String _getSecondAmountTypeString() {
    if (BookingType.expense == widget.bookingType) {
      return AppLocalizations.of(context).translate(AmountType.fix.name);
    } else if (BookingType.income == widget.bookingType) {
      return AppLocalizations.of(context).translate(AmountType.passive.name);
    }
    return '';
  }

  void _calculateMonthlyAmounts(List<Booking> bookings) {
    List<BarChartGroupData> items = [];
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
      String monthKey = "${booking.date.year}-${booking.date.month.toString().padLeft(2, '0')}";
      if (booking.type == BookingType.expense || booking.type == BookingType.income) {
        _monthlyAmountSums.update(monthKey, (value) => value + booking.amount, ifAbsent: () => booking.amount);
        if (booking.amountType == AmountType.variable || booking.amountType == AmountType.active) {
          _monthlyFirstBarValues.update(monthKey, (value) => value + booking.amount, ifAbsent: () => booking.amount);
        } else if (booking.amountType == AmountType.fix || booking.amountType == AmountType.passive) {
          _monthlySecondBarValues.update(monthKey, (value) => value + booking.amount, ifAbsent: () => booking.amount);
        }
      } else {
        if (booking.amountType == AmountType.buy) {
          _monthlyAmountSums.update(monthKey, (value) => value + booking.amount, ifAbsent: () => booking.amount);
        } else if (booking.amountType == AmountType.sale) {
          _monthlyFirstBarValues.update(monthKey, (value) => value + booking.amount, ifAbsent: () => booking.amount);
        }
      }
    }

    if (_showSeparatedBars == false) {
      List<double> monthlyAmounts = _monthlyAmountSums.values.toList();
      for (int i = 0; i < monthlyAmounts.length; i++) {
        items.add(makeGroupData(i, monthlyAmounts[i], monthlyAmounts[i], _showSeparatedBars));
      }
    } else {
      List<double> firstBarAmounts = _monthlyFirstBarValues.values.toList();
      List<double> secondBarAmounts = _monthlySecondBarValues.values.toList();
      for (int i = 0; i < secondBarAmounts.length; i++) {
        items.add(makeGroupData(i, firstBarAmounts[i], secondBarAmounts[i], _showSeparatedBars));
      }
    }
    _rawBarGroups = items;
    _showingBarGroups = _rawBarGroups;
  }

  void _setMaxAmountEntry() {
    if (_showSeparatedBars == false) {
      _maxAmountEntry = _monthlyAmountSums.entries.reduce((a, b) => a.value > b.value ? a : b);
    } else {
      MapEntry<String, double> maxFirstBarValue = _monthlyFirstBarValues.entries.reduce((a, b) => a.value > b.value ? a : b);
      MapEntry<String, double> maxSecondBarValue = _monthlySecondBarValues.entries.reduce((a, b) => a.value > b.value ? a : b);
      maxFirstBarValue.value >= maxSecondBarValue.value ? _maxAmountEntry = maxFirstBarValue : _maxAmountEntry = maxSecondBarValue;
    }
  }

  void _changeBarChartView(bool showSeparatedBars) {
    setState(() {
      _showSeparatedBars = showSeparatedBars;
    });
  }

  @override
  Widget build(BuildContext context) {
    _calculateMonthlyAmounts(widget.bookings);
    _setMaxAmountEntry();
    return AspectRatio(
      aspectRatio: 1.2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 56.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _changeBarChartView(false),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0, right: 6.0),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                color: _showSeparatedBars == false ? Colors.cyanAccent : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getFirstAmountType(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _showSeparatedBars == false ? Colors.cyanAccent : Colors.grey,
                                ),
                              ),
                              Text(
                                formatToMoneyAmount(_monthlyAmountSums.values.last.toString()),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: _showSeparatedBars == false ? Colors.white : Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: GestureDetector(
                      onTap: () => _changeBarChartView(true),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7.0, right: 6.0),
                              child: Container(
                                width: 8.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  color: _showSeparatedBars
                                      ? BookingType.investment == widget.bookingType
                                          ? Colors.greenAccent
                                          : Colors.cyanAccent
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _getFirstAmountTypeString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _showSeparatedBars ? Colors.greenAccent : Colors.grey,
                                      ),
                                    ),
                                    BookingType.investment != widget.bookingType
                                        ? Text(
                                            ' / ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _showSeparatedBars ? Colors.white : Colors.grey,
                                            ),
                                          )
                                        : const SizedBox(),
                                    BookingType.investment != widget.bookingType
                                        ? Text(
                                            _getSecondAmountTypeString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: _showSeparatedBars ? Colors.redAccent : Colors.grey,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                Text(
                                  '${formatToMoneyAmount(_monthlyFirstBarValues.values.last.toString())}'
                                  '${BookingType.investment != widget.bookingType ? ' / ${formatToMoneyAmount(_monthlySecondBarValues.values.last.toString())}' : ''}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: _showSeparatedBars ? Colors.white : Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Expanded(
              child: BarChart(
                swapAnimationCurve: Curves.fastOutSlowIn,
                swapAnimationDuration: Duration(milliseconds: barChartDurationInMs),
                BarChartData(
                  maxY: _maxAmountEntry.value,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: ((group) {
                        return Colors.grey;
                      }),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          _showSeparatedBars == false
                              ? BookingType.investment == widget.bookingType
                                  ? AppLocalizations.of(context).translate('kauf') + ':\n' + formatToMoneyAmount(rod.toY.toString())
                                  : AppLocalizations.of(context).translate('gesamt') + ':\n' + formatToMoneyAmount(rod.toY.toString())
                              : rodIndex == 0
                                  ? '${_getFirstAmountTypeString()}:\n${formatToMoneyAmount(rod.toY.toString())}'
                                  : '${_getSecondAmountTypeString()}:\n${formatToMoneyAmount(rod.toY.toString())}',
                          textAlign: TextAlign.start,
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
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
                  barGroups: _showingBarGroups.map((group) {
                    return BarChartGroupData(
                      x: group.x,
                      barRods: group.barRods.map((rod) {
                        final adjustedToY = rod.toY > _maxAmountEntry.value ? _maxAmountEntry.value : rod.toY;
                        return rod.copyWith(toY: adjustedToY);
                      }).toList(),
                    );
                  }).toList(),
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
      String monthName = DateFormatter.dateFormatMMM(monthDate, context);
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
          width: 12.0,
        ),
        showTwo
            ? BarChartRodData(
                toY: y2,
                color: Colors.redAccent,
                width: 12.0,
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
