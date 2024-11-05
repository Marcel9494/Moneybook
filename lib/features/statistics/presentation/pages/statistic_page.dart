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
  AmountType _selectedAmountType = AmountType.buy;
  Map<AmountType, double> _amountTypes = {};

  @override
  void initState() {
    super.initState();
    _getAmountTypes();
  }

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

  // TODO hier weitermachen und wenn man von der Kategorie Statistik Seite zurückkommt sollen die Werte weiterhin richtig berechnet und angezeigt werden
  void _calculateAmountTypeStats(List<Booking> bookings) {
    //_amountTypes.clear();
    for (int i = 0; i < bookings.length; i++) {
      if (_selectedBookingType.name == BookingType.expense.name) {
        if (bookings[i].amountType.name == AmountType.overall.name) {
          _amountTypes[AmountType.overall] = _amountTypes[AmountType.overall]! + bookings[i].amount;
        } else if (bookings[i].amountType.name == AmountType.variable.name) {
          _amountTypes[AmountType.variable] = _amountTypes[AmountType.variable]! + bookings[i].amount;
        } else if (bookings[i].amountType.name == AmountType.fix.name) {
          _amountTypes[AmountType.fix] = _amountTypes[AmountType.fix]! + bookings[i].amount;
        }
      } else if (_selectedBookingType.name == BookingType.income.name) {
        if (bookings[i].amountType.name == AmountType.overall.name) {
          _amountTypes[AmountType.overall] = _amountTypes[AmountType.overall]! + bookings[i].amount;
        } else if (bookings[i].amountType.name == AmountType.active.name) {
          _amountTypes[AmountType.active] = _amountTypes[AmountType.active]! + bookings[i].amount;
        } else if (bookings[i].amountType.name == AmountType.passive.name) {
          _amountTypes[AmountType.passive] = _amountTypes[AmountType.passive]! + bookings[i].amount;
        }
      } else if (_selectedBookingType.name == BookingType.investment.name) {
        if (bookings[i].amountType.name == AmountType.buy.name) {
          _amountTypes[AmountType.buy] = _amountTypes[AmountType.buy]! + bookings[i].amount;
        } else if (bookings[i].amountType.name == AmountType.sale.name) {
          _amountTypes[AmountType.sale] = _amountTypes[AmountType.sale]! + bookings[i].amount;
        }
      }
    }
  }

  Map<AmountType, double> _getAmountTypes() {
    _amountTypes.clear();
    if (BookingType.expense.name == _selectedBookingType.name) {
      _selectedAmountType = AmountType.overall;
      _amountTypes[AmountType.overall] = 0.0;
      _amountTypes[AmountType.variable] = 0.0;
      _amountTypes[AmountType.fix] = 0.0;
    } else if (BookingType.income.name == _selectedBookingType.name) {
      _selectedAmountType = AmountType.overall;
      _amountTypes[AmountType.overall] = 0.0;
      _amountTypes[AmountType.active] = 0.0;
      _amountTypes[AmountType.passive] = 0.0;
    } else if (BookingType.investment.name == _selectedBookingType.name) {
      _selectedAmountType = AmountType.buy;
      _amountTypes[AmountType.buy] = 0.0;
      _amountTypes[AmountType.sale] = 0.0;
    }
    return _amountTypes;
  }

  void _onBookingTypeChanged(Set<BookingType> newBookingType) {
    setState(() {
      _selectedBookingType = newBookingType.first;
      _getAmountTypes();
    });
  }

  void _onAmountTypeChanged(Set<AmountType> newAmountType) {
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
          _calculateAmountTypeStats(bookingState.bookings);
          return BlocBuilder<CategorieStatsBloc, CategorieStatsState>(
            builder: (context, state) {
              if (state is CalculatedCategorieStats) {
                if (state.categorieStats.isEmpty) {
                  return Column(
                    children: [
                      CategoriePieChart(
                        categorieStats: state.categorieStats,
                        bookingType: _selectedBookingType,
                        onAmountTypeChanged: _onAmountTypeChanged,
                        amountTypes: _amountTypes,
                      ),
                      BookingTypeSegmentedButton(
                        selectedBookingType: _selectedBookingType,
                        onBookingTypeChanged: _onBookingTypeChanged,
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
                      CategoriePieChart(
                        categorieStats: state.categorieStats,
                        bookingType: _selectedBookingType,
                        onAmountTypeChanged: _onAmountTypeChanged,
                        amountTypes: _amountTypes,
                      ),
                      BookingTypeSegmentedButton(
                        selectedBookingType: _selectedBookingType,
                        onBookingTypeChanged: _onBookingTypeChanged,
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
