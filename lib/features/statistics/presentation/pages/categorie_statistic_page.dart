import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/booking_card.dart';

import '../../../bookings/presentation/bloc/booking_bloc.dart';
import '../widgets/charts/categorie_bar_chart.dart';

class CategorieStatisticPage extends StatefulWidget {
  final String categorie;
  final DateTime selectedDate;

  const CategorieStatisticPage({
    super.key,
    required this.categorie,
    required this.selectedDate,
  });

  @override
  State<CategorieStatisticPage> createState() => _CategorieStatisticPageState();
}

class _CategorieStatisticPageState extends State<CategorieStatisticPage> {
  @override
  void initState() {
    super.initState();
    _loadCategorieBookings(context);
  }

  // TODO hier weitermachen und auf LoadMonthlyCategorieBookings erweitern mit widget.selectedDate
  void _loadCategorieBookings(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      LoadCategorieBookings(widget.categorie),
    );
  }

  Future<bool> _onBackButtonPressed() async {
    BlocProvider.of<BookingBloc>(context).add(
      LoadSortedMonthlyBookings(widget.selectedDate),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => _onBackButtonPressed(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.categorie}'),
        ),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, bookingState) {
            if (bookingState is CategorieBookingsLoaded) {
              return Column(
                children: [
                  CategorieBarChart(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: bookingState.categorieBookings.length,
                      itemBuilder: (BuildContext context, int index) {
                        return BookingCard(
                          booking: bookingState.categorieBookings[index],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
