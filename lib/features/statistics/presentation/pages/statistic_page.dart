import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/statistics/presentation/widgets/buttons/booking_type_segmented_button.dart';
import 'package:moneybook/shared/presentation/widgets/deco/empty_list.dart';

import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/domain/value_objects/amount_type.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart';
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

  void _loadCategorieBookings(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      LoadSortedMonthlyBookings(widget.selectedDate),
    );
  }

  void _calculateCategoryStats(List<Booking> bookings) {
    BlocProvider.of<CategorieStatsBloc>(context).add(
      CalculateCategorieStats(bookings, _selectedBookingType, _selectedAmountType),
    );
  }

  void _calculateAmountTypeStats(List<Booking> bookings, BookingType bookingType) {
    _amountTypes.clear();
    if (bookingType.pluralName == BookingType.expense.pluralName) {
      //_selectedAmountType = AmountType.overallExpense;
      _amountTypes[AmountType.overallExpense] = 0.0;
      _amountTypes[AmountType.variable] = 0.0;
      _amountTypes[AmountType.fix] = 0.0;
    } else if (bookingType.pluralName == BookingType.income.pluralName) {
      //_selectedAmountType = AmountType.overallIncome;
      _amountTypes[AmountType.overallIncome] = 0.0;
      _amountTypes[AmountType.active] = 0.0;
      _amountTypes[AmountType.passive] = 0.0;
    } else if (bookingType.pluralName == BookingType.investment.pluralName) {
      //_selectedAmountType = AmountType.buy;
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

  void _onAmountTypeChanged(Set<AmountType> newAmountType) {
    print(newAmountType.first);
    setState(() {
      _selectedAmountType = newAmountType.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadCategorieBookings(context);
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, bookingState) {
        if (bookingState is Loaded) {
          _calculateCategoryStats(bookingState.bookings);
          _calculateAmountTypeStats(bookingState.bookings, _selectedBookingType);
          return BlocBuilder<CategorieStatsBloc, CategorieStatsState>(
            builder: (context, state) {
              if (state is CalculatedCategorieStats) {
                if (state.categorieStats.isEmpty) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 2,
                            child: CategoriePieChart(
                              categorieStats: state.categorieStats,
                              bookingType: _selectedBookingType,
                              onAmountTypeChanged: _onAmountTypeChanged,
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
                                        // TODO hier weitermachen warum wird der AmountType nicht geändert bei Klick?
                                        GestureDetector(
                                          onTap: () => _onAmountTypeChanged({amountType.key}),
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
                          });
                        },
                      ),
                      const Expanded(
                        child: EmptyList(
                          text: 'Noch keine Buchungen vorhanden',
                          icon: Icons.donut_small,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 2,
                            child: CategoriePieChart(
                              categorieStats: state.categorieStats,
                              bookingType: _selectedBookingType,
                              onAmountTypeChanged: _onAmountTypeChanged,
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
                                          onTap: () => _onAmountTypeChanged({_selectedAmountType}),
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
                          });
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.categorieStats.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CategoriePercentageCard(
                              categorieStats: state.categorieStats[index],
                              index: index,
                              selectedDate: widget.selectedDate,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              }
              return const SizedBox();
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
