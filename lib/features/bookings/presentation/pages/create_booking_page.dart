import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';

import '../../../../core/consts/route_consts.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/booking.dart';
import '../widgets/input_fields/amount_text_field.dart';
import '../widgets/input_fields/title_text_field.dart';

class CreateBookingPage extends StatefulWidget {
  const CreateBookingPage({super.key});

  @override
  State<CreateBookingPage> createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void createBooking(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      CreateBooking(
        Booking(
          id: 0,
          title: _titleController.text,
          date: DateTime.now(),
          amount: double.parse(_amountController.text),
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
        child: BlocListener<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is Finished) {
              Navigator.popAndPushNamed(context, bookingListRoute);
            }
          },
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              if (state is Initial) {
                return Column(
                  children: [
                    TitleTextField(
                      titleController: _titleController,
                      errorText: '',
                    ),
                    AmountTextField(
                      amountController: _amountController,
                      errorText: '',
                    ),
                    ElevatedButton(
                      onPressed: () => createBooking(context),
                      child: const Text('Erstellen'),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
