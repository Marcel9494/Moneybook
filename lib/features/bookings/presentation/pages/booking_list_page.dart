import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/booking_card.dart';
import 'package:moneybook/features/bookings/presentation/widgets/deco/daily_report_summary.dart';

import '../../../../injection_container.dart';
import '../bloc/booking_bloc.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  late DateTime previousBookingDate;
  late DateTime bookingDate;

  void loadBookings(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      LoadSortedMonthlyBookings(DateTime.now()),
    );
    // TODO eigenes Event für tägliche Einnahmen und Ausgaben berechnen implementieren
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingBloc>(),
      child: Scaffold(
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            loadBookings(context);
            if (state is Loaded) {
              return ListView.builder(
                itemCount: state.booking.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index > 0) {
                    previousBookingDate = state.booking[index - 1].date;
                    bookingDate = state.booking[index].date;
                  }
                  if (index == 0 || previousBookingDate != bookingDate) {
                    return Column(
                      children: [
                        DailyReportSummary(date: state.booking[index].date),
                        BookingCard(booking: state.booking[index]),
                      ],
                    );
                  } else {
                    return BookingCard(booking: state.booking[index]);
                  }
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
