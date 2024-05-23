import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/input_fields/account_input_field.dart';
import 'package:moneybook/features/bookings/presentation/widgets/input_fields/date_input_field.dart';

import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/date_formatter.dart';
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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();

  void createBooking(BuildContext context) {
    BlocProvider.of<BookingBloc>(context).add(
      CreateBooking(
        Booking(
          id: 0,
          title: _titleController.text,
          date: DateTime.now(),
          amount: double.parse(_amountController.text),
          account: _accountController.text,
          categorie: 'Lebensmittel',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = dateFormatterDDMMYYYYEE.format(DateTime.now());
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
                    DateInputField(
                      dateController: _dateController,
                    ),
                    TitleTextField(
                      titleController: _titleController,
                      errorText: '',
                    ),
                    AmountTextField(
                      amountController: _amountController,
                      errorText: '',
                    ),
                    AccountInputField(
                      hintText: 'Abbuchungskonto...',
                      accountController: _accountController,
                      errorText: '',
                    ),
                    // TODO hier weitermachen mit Kategorie Auswahl
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
