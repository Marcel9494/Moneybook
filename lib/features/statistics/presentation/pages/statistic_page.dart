import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/statistics/presentation/widgets/buttons/booking_type_segmented_button.dart';
import 'package:moneybook/shared/presentation/widgets/deco/empty_list.dart';

import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/domain/value_objects/amount_type.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart';
import '../../domain/entities/categorie_stats.dart';
import '../bloc/categorie_stats_bloc.dart';
import '../widgets/cards/categorie_percentage_card.dart';
import '../widgets/charts/categorie_pie_chart.dart';
import '../widgets/charts/indicator.dart';

class StatisticPage extends StatefulWidget {
  final DateTime selectedDate;

  const StatisticPage({
    super.key,
    required this.selectedDate,
  });

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  BookingType _selectedBookingType = BookingType.expense;
  AmountType _selectedAmountType = AmountType.overallExpense;
  Map<AmountType, double> _amountTypes = {};
  List<CategorieStats> _categorieStats = [];
  bool _categorieFound = false;
  double _overallAmount = 0.0;

  void _loadMonthlyBookings(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      LoadSortedMonthlyBookings(widget.selectedDate),
    );
  }

  void _addCategoryStat(Booking booking) {
    _categorieFound = false;
    _overallAmount += booking.amount;
    for (int j = 0; j < _categorieStats.length; j++) {
      if (_categorieStats[j].categorie.contains(booking.categorie)) {
        _categorieStats[j].amount += booking.amount;
        _categorieFound = true;
        break;
      }
    }
    if (_categorieFound == false) {
      CategorieStats newCategorieStat = CategorieStats(
        categorie: booking.categorie,
        bookingType: booking.type,
        amount: booking.amount,
        percentage: 0.0,
      );
      _categorieStats.add(newCategorieStat);
    }
  }

  void _calculateCategoryStats(List<Booking> bookings) {
    _categorieFound = false;
    _overallAmount = 0.0;
    _categorieStats = [];
    for (int i = 0; i < bookings.length; i++) {
      if (bookings[i].type == _selectedBookingType && bookings[i].amountType.name == _selectedAmountType.name) {
        _addCategoryStat(bookings[i]);
      } else if (bookings[i].type == _selectedBookingType && _selectedAmountType.name == AmountType.overallExpense.name) {
        _addCategoryStat(bookings[i]);
      } else if (bookings[i].type == _selectedBookingType && _selectedAmountType.name == AmountType.overallIncome.name) {
        _addCategoryStat(bookings[i]);
      }
    }
    // Für jede Kategorie Prozentwert berechnen
    for (int i = 0; i < _categorieStats.length; i++) {
      _categorieStats[i].percentage = (_categorieStats[i].amount / _overallAmount) * 100;
    }
    _categorieStats.sort((first, second) => second.percentage.compareTo(first.percentage));
  }

  void _calculateAmountTypeStats(List<Booking> bookings, BookingType bookingType) {
    _amountTypes.clear();
    if (bookingType.pluralName == BookingType.expense.pluralName) {
      _amountTypes[AmountType.overallExpense] = 0.0;
      _amountTypes[AmountType.variable] = 0.0;
      _amountTypes[AmountType.fix] = 0.0;
    } else if (bookingType.pluralName == BookingType.income.pluralName) {
      _amountTypes[AmountType.overallIncome] = 0.0;
      _amountTypes[AmountType.active] = 0.0;
      _amountTypes[AmountType.passive] = 0.0;
    } else if (bookingType.pluralName == BookingType.investment.pluralName) {
      _amountTypes[AmountType.buy] = 0.0;
      _amountTypes[AmountType.sale] = 0.0;
    }
    for (int i = 0; i < bookings.length; i++) {
      if (bookings[i].type.name == BookingType.expense.name && bookingType.pluralName == BookingType.expense.pluralName) {
        if (bookings[i].amountType == AmountType.variable) {
          _amountTypes[AmountType.variable] = _amountTypes[AmountType.variable]! + bookings[i].amount;
        } else if (bookings[i].amountType == AmountType.fix) {
          _amountTypes[AmountType.fix] = _amountTypes[AmountType.fix]! + bookings[i].amount;
        }
        _amountTypes[AmountType.overallExpense] = _amountTypes[AmountType.overallExpense]! + bookings[i].amount;
      } else if (bookings[i].type.name == BookingType.income.name && bookingType.pluralName == BookingType.income.pluralName) {
        if (bookings[i].amountType == AmountType.active) {
          _amountTypes[AmountType.active] = _amountTypes[AmountType.active]! + bookings[i].amount;
        } else if (bookings[i].amountType == AmountType.passive) {
          _amountTypes[AmountType.passive] = _amountTypes[AmountType.passive]! + bookings[i].amount;
        }
        _amountTypes[AmountType.overallIncome] = _amountTypes[AmountType.overallIncome]! + bookings[i].amount;
      } else if (bookings[i].type.name == BookingType.investment.name && bookingType.pluralName == BookingType.investment.pluralName) {
        if (bookings[i].amountType == AmountType.buy) {
          _amountTypes[AmountType.buy] = _amountTypes[AmountType.buy]! + bookings[i].amount;
        } else if (bookings[i].amountType == AmountType.sale) {
          _amountTypes[AmountType.sale] = _amountTypes[AmountType.sale]! + bookings[i].amount;
        }
      }
    }
  }

  void _onBookingTypeChanged(BookingType newBookingType) {
    setState(() {
      _selectedBookingType = newBookingType;
      if (_selectedBookingType == BookingType.expense) {
        _selectedAmountType = AmountType.overallExpense;
      } else if (_selectedBookingType == BookingType.income) {
        _selectedAmountType = AmountType.overallIncome;
      } else if (_selectedBookingType == BookingType.investment) {
        _selectedAmountType = AmountType.buy;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadMonthlyBookings(context);
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, bookingState) {
        if (bookingState is Loaded) {
          _calculateCategoryStats(bookingState.bookings);
          _calculateAmountTypeStats(bookingState.bookings, _selectedBookingType);
          return BlocBuilder<CategorieStatsBloc, CategorieStatsState>(
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: CategoriePieChart(
                          categorieStats: _categorieStats,
                          bookingType: _selectedBookingType,
                          amountTypes: _amountTypes,
                          amountType: _selectedAmountType,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ..._amountTypes.entries.map((amountType) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedAmountType = amountType.key;
                                          _calculateCategoryStats(bookingState.bookings);
                                        });
                                      },
                                      child: Indicator(
                                        color: Colors.white,
                                        text: amountType.key.name,
                                        isSquare: false,
                                        amountType: _selectedAmountType,
                                        amount: amountType.value,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                  ],
                                );
                              }).toList(),
                              const SizedBox(height: 14.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  BookingTypeSegmentedButton(
                    selectedBookingType: _selectedBookingType,
                    onBookingTypeChanged: (Set<BookingType> newBookingType) {
                      setState(() {
                        _selectedBookingType = newBookingType.first;
                        _calculateAmountTypeStats(bookingState.bookings, _selectedBookingType);
                        _onBookingTypeChanged(_selectedBookingType);
                      });
                    },
                  ),
                  _categorieStats.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _categorieStats.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CategoriePercentageCard(
                                categorieStats: _categorieStats[index],
                                index: index,
                                selectedDate: widget.selectedDate,
                              );
                            },
                          ),
                        )
                      : const Expanded(
                          child: EmptyList(
                            text: 'Noch keine Buchungen vorhanden',
                            icon: Icons.donut_small,
                          ),
                        ),
                ],
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
