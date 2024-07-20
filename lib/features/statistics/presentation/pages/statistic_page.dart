import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart';
import '../bloc/categorie_stats_bloc.dart';
import '../widgets/cards/categorie_percentage_card.dart';
import '../widgets/charts/categorie_pie_chart.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  BookingType _selectedBookingType = BookingType.expense;

  void loadCategorieBookings(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      LoadSortedMonthlyBookings(DateTime.now()),
    );
  }

  void _calculateCategoryStats(List<Booking> bookings) {
    BlocProvider.of<CategorieStatsBloc>(context).add(
      CalculateCategorieStats(bookings, _selectedBookingType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, bookingState) {
        loadCategorieBookings(context);
        if (bookingState is Loaded) {
          _calculateCategoryStats(bookingState.bookings);
          return BlocBuilder<CategorieStatsBloc, CategorieStatsState>(
            builder: (context, state) {
              // TODO hier weitermachen und leere Liste UI erstellen extra State für leere Liste?
              if (state is CalculatedCategorieStats) {
                return Column(
                  children: [
                    CategoriePieChart(categorieStats: state.categorieStats),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, right: 6.0, left: 6.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<BookingType>(
                          segments: <ButtonSegment<BookingType>>[
                            ButtonSegment<BookingType>(
                              value: BookingType.expense,
                              label: Text(
                                BookingType.expense.name,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ),
                            ButtonSegment<BookingType>(
                              value: BookingType.income,
                              label: Text(
                                BookingType.income.name,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ),
                            ButtonSegment<BookingType>(
                              value: BookingType.investment,
                              label: Text(
                                BookingType.investment.name,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                          selected: <BookingType>{_selectedBookingType},
                          onSelectionChanged: (Set<BookingType> newSelection) {
                            setState(() {
                              _selectedBookingType = newSelection.first;
                            });
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
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
              return const SizedBox();
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
