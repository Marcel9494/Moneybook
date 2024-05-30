import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/core/consts/route_consts.dart';
import 'package:moneybook/features/bookings/presentation/widgets/cards/booking_card.dart';

import '../../../../injection_container.dart';
import '../bloc/booking_bloc.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  void loadBookings(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      LoadMonthlyBookings(DateTime.now()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            loadBookings(context);
            if (state is Loaded) {
              // TODO hier weitermachen und Buchungsliste UI erstellen
              return ListView.builder(
                itemCount: state.booking.length,
                itemBuilder: (BuildContext context, int index) {
                  return BookingCard(booking: state.booking[index]);
                },
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_rounded),
          onPressed: () => Navigator.pushNamed(context, createBookingRoute),
        ),
      ),
    );
  }
}
