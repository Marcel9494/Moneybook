import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/booking.dart';

class CreateBookingPage extends StatefulWidget {
  const CreateBookingPage({super.key});

  @override
  State<CreateBookingPage> createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  void dispatchCreateBooking(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      CreateBooking(
        Booking(
          id: 0,
          title: 'Edeka',
          date: DateTime.now(),
          amount: 25.0,
          account: 'Geldbeutel',
          categorie: 'Lebensmittel',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buchung erstellen'),
      ),
      body: BlocProvider(
        create: (_) => sl<BookingBloc>(),
        child: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is Initial) {
              return Column(
                children: [
                  const Text('Buchung erstellen'),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Titel',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => dispatchCreateBooking(context),
                    child: const Text('Erstellen'),
                  ),
                ],
              );
            } else if (state is Loaded) {
              return Column(
                children: [
                  const Text('Buchung erstellt'),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Titel',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => dispatchCreateBooking(context),
                    child: const Text('Bereits erstellt'),
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
