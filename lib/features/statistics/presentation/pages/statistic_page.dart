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
  double _overallBuyAmount = 0.0;
  double _overallSaleAmount = 0.0;

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

  void _calculateAmountTypeStats(List<Booking> bookings) {
    _overallBuyAmount = 0.0;
    _overallSaleAmount = 0.0;
    for (int i = 0; i < bookings.length; i++) {
      if (bookings[i].type.name == BookingType.investment.name) {
        if (bookings[i].amountType.name == AmountType.buy.name) {
          _overallBuyAmount += bookings[i].amount;
        } else if (bookings[i].amountType.name == AmountType.sale.name) {
          _overallSaleAmount += bookings[i].amount;
        }
      }
    }
  }

  void _onBookingTypeChanged(Set<BookingType> newBookingType) {
    setState(() {
      _selectedBookingType = newBookingType.first;
    });
  }

  void _onAmountTypeChanged(Set<AmountType> newAmountType) {
    setState(() {
      _selectedAmountType = newAmountType.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, bookingState) {
        _loadCategorieBookings(context);
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
                        amountType: _selectedAmountType,
                        onAmountTypeChanged: _onAmountTypeChanged,
                        overallBuyAmount: _overallBuyAmount,
                        overallSaleAmount: _overallSaleAmount,
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
                        amountType: _selectedAmountType,
                        onAmountTypeChanged: _onAmountTypeChanged,
                        overallBuyAmount: _overallBuyAmount,
                        overallSaleAmount: _overallSaleAmount,
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
