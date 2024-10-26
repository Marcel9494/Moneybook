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

  void _onSelectionChanged(Set<BookingType> newSelection) {
    setState(() {
      _selectedBookingType = newSelection.first;
    });
  }

  void _onAmountTypeChanged(Set<AmountType> newAmountType) {
    print('Test');
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
                        onAmountTypeChanged: (_selectedAmountType) => _onAmountTypeChanged(_selectedAmountType),
                      ),
                      BookingTypeSegmentedButton(
                        selectedBookingType: _selectedBookingType,
                        onSelectionChanged: _onSelectionChanged,
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
                        onAmountTypeChanged: (_selectedAmountType) => _onAmountTypeChanged(_selectedAmountType),
                      ),
                      BookingTypeSegmentedButton(
                        selectedBookingType: _selectedBookingType,
                        onSelectionChanged: _onSelectionChanged,
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
