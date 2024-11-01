import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/booking_card.dart';

import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart';
import '../../../bookings/presentation/widgets/buttons/month_picker_buttons.dart';
import '../widgets/charts/categorie_bar_chart.dart';

class CategorieStatisticPage extends StatefulWidget {
  final String categorie;
  final BookingType bookingType;
  DateTime selectedDate;

  CategorieStatisticPage({
    super.key,
    required this.categorie,
    required this.bookingType,
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
      LoadPastMonthlyCategorieBookings(widget.categorie, widget.selectedDate, 7),
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
          actions: [
            MonthPickerButtons(
              selectedDate: widget.selectedDate,
              selectedDateCallback: (DateTime newDate) {
                setState(() {
                  widget.selectedDate = newDate;
                });
              },
            )
          ],
        ),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, bookingState) {
            if (bookingState is CategorieBookingsLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategorieBarChart(
                    bookingType: widget.bookingType,
                    selectedDate: widget.selectedDate,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 0.0, 12.0, 4.0),
                    child: Text(
                      'Buchungen',
                      style: const TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
                    ),
                  ),
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
