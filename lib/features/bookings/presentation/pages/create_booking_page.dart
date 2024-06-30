import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/domain/value_objects/amount.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/buttons/type_segmented_button.dart';
import 'package:moneybook/features/bookings/presentation/widgets/input_fields/account_input_field.dart';
import 'package:moneybook/features/bookings/presentation/widgets/input_fields/date_and_repeat_input_field.dart';
import 'package:moneybook/shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import 'package:moneybook/shared/presentation/widgets/buttons/save_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../injection_container.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
import '../../domain/entities/booking.dart';
import '../../domain/value_objects/booking_type.dart';
import '../widgets/input_fields/categorie_input_field.dart';

class CreateBookingPage extends StatefulWidget {
  const CreateBookingPage({super.key});

  @override
  State<CreateBookingPage> createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  final GlobalKey<FormState> _bookingFormKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _fromAccountController = TextEditingController();
  final TextEditingController _toAccountController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final RoundedLoadingButtonController _createBookingBtnController = RoundedLoadingButtonController();
  final RepetitionType _repetitionType = RepetitionType.noRepetition;
  BookingType _bookingType = BookingType.expense;

  @override
  void initState() {
    super.initState();
    _dateController.text = dateFormatterDDMMYYYYEE.format(DateTime.now());
  }

  void _createBooking(BuildContext context) {
    final FormState form = _bookingFormKey.currentState!;
    if (form.validate() == false) {
      _createBookingBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _createBookingBtnController.reset();
      });
    } else {
      _createBookingBtnController.success();
      Timer(const Duration(milliseconds: durationInMs), () {
        BlocProvider.of<BookingBloc>(context).add(
          CreateBooking(
            Booking(
              id: 0,
              type: _bookingType,
              title: _titleController.text,
              date: dateFormatterDDMMYYYYEE.parse(_dateController.text), // parse DateFormat in ISO-8601
              repetition: _repetitionType,
              amount: Amount.getValue(_amountController.text),
              currency: Amount.getCurrency(_amountController.text),
              fromAccount: _fromAccountController.text,
              toAccount: _toAccountController.text,
              categorie: _categorieController.text,
            ),
          ),
        );
      });
    }
  }

  void _changeBookingType(Set<BookingType> newBookingType) {
    setState(() {
      _bookingType = newBookingType.first;
      _categorieController.text = '';
      if (_bookingType == BookingType.transfer) {
        _categorieController.text = 'Übertrag';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buchung erstellen'),
      ),
      body: BlocProvider(
        create: (_) => sl<BookingBloc>(),
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (BuildContext context, BookingState state) {
            if (state is Finished) {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(0));
            }
          },
          builder: (BuildContext context, state) {
            if (state is Initial) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Card(
                    child: Form(
                      key: _bookingFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TypeSegmentedButton(
                            bookingType: _bookingType,
                            onSelectionChanged: (bookingType) => _changeBookingType(bookingType),
                          ),
                          DateAndRepeatInputField(
                            dateController: _dateController,
                            repetitionType: _repetitionType.name,
                          ),
                          TitleTextField(hintText: 'Titel...', titleController: _titleController),
                          AmountTextField(amountController: _amountController),
                          AccountInputField(
                            accountController: _fromAccountController,
                            hintText: _bookingType.name == BookingType.income.name ? 'Konto...' : 'Abbuchungskonto...',
                          ),
                          _bookingType.name == BookingType.transfer.name || _bookingType.name == BookingType.investment.name
                              ? AccountInputField(
                                  accountController: _toAccountController,
                                  hintText: 'Konto...',
                                )
                              : const SizedBox(),
                          _bookingType.name == BookingType.transfer.name
                              ? const SizedBox()
                              : CategorieInputField(
                                  categorieController: _categorieController,
                                  bookingType: _bookingType,
                                ),
                          SaveButton(text: 'Erstellen', saveBtnController: _createBookingBtnController, onPressed: () => _createBooking(context)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
