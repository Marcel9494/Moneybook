import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
import '../../domain/entities/booking.dart';
import '../../domain/value_objects/amount.dart';
import '../../domain/value_objects/booking_type.dart';
import '../../domain/value_objects/repetition_type.dart';
import '../bloc/booking_bloc.dart';
import '../widgets/buttons/type_segmented_button.dart';
import '../widgets/input_fields/account_input_field.dart';
import '../widgets/input_fields/categorie_input_field.dart';
import '../widgets/input_fields/date_and_repeat_input_field.dart';

class EditBookingPage extends StatefulWidget {
  final Booking booking;

  const EditBookingPage({
    super.key,
    required this.booking,
  });

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final GlobalKey<FormState> _bookingFormKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final RoundedLoadingButtonController _editBookingBtnController = RoundedLoadingButtonController();
  late RepetitionType _repetitionType;
  late BookingType _bookingType;

  @override
  void initState() {
    super.initState();
    _initializeBooking();
  }

  void _initializeBooking() {
    _dateController.text = dateFormatterDDMMYYYYEE.format(widget.booking.date);
    _titleController.text = widget.booking.title;
    _amountController.text = formatToMoneyAmount(widget.booking.amount.toString());
    _accountController.text = widget.booking.account;
    _categorieController.text = widget.booking.categorie;
    _repetitionType = widget.booking.repetition;
    _bookingType = widget.booking.type;
  }

  void _editBooking(BuildContext context) {
    final FormState form = _bookingFormKey.currentState!;
    if (form.validate() == false) {
      _editBookingBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _editBookingBtnController.reset();
      });
    } else {
      _editBookingBtnController.success();
      Timer(const Duration(milliseconds: durationInMs), () {
        BlocProvider.of<BookingBloc>(context).add(
          EditBooking(
            Booking(
              id: widget.booking.id,
              type: _bookingType,
              title: _titleController.text,
              date: dateFormatterDDMMYYYYEE.parse(_dateController.text), // parse DateFormat in ISO-8601
              repetition: _repetitionType,
              amount: Amount.getValue(_amountController.text),
              currency: Amount.getCurrency(_amountController.text),
              account: _accountController.text,
              categorie: _categorieController.text,
            ),
            context,
          ),
        );
      });
    }
  }

  void _deleteBooking(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buchung löschen?'),
          content: const Text('Wollen Sie die Buchung wirklich löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ja'),
              onPressed: () {
                BlocProvider.of<BookingBloc>(context).add(
                  DeleteBooking(widget.booking.id, context),
                );
              },
            ),
            TextButton(
              child: const Text('Nein'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _changeBookingType(Set<BookingType> newBookingType) {
    setState(() {
      _bookingType = newBookingType.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buchung bearbeiten'),
        actions: [
          IconButton(
            onPressed: () => _deleteBooking(context),
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    accountController: _accountController,
                    hintText: _bookingType.name == BookingType.expense.name ? 'Abbuchungskonto...' : 'Konto...',
                  ),
                  CategorieInputField(categorieController: _categorieController),
                  SaveButton(text: 'Speichern', saveBtnController: _editBookingBtnController, onPressed: () => _editBooking(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
