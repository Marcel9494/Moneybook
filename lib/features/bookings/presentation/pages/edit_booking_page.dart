import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/shared/domain/value_objects/serie_mode_type.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
import '../../../accounts/presentation/bloc/account_bloc.dart' as account;
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
  final SerieModeType editMode;

  const EditBookingPage({
    super.key,
    required this.booking,
    required this.editMode,
  });

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final GlobalKey<FormState> _bookingFormKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _fromAccountController = TextEditingController();
  final TextEditingController _toAccountController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final RoundedLoadingButtonController _editBookingBtnController = RoundedLoadingButtonController();
  late RepetitionType _repetitionType;
  late BookingType _bookingType;
  late Booking _oldBooking;
  late Booking _updatedBooking;

  @override
  void initState() {
    super.initState();
    _initializeBooking();
    _backupOldBooking();
  }

  void _initializeBooking() {
    _dateController.text = dateFormatterDDMMYYYYEE.format(widget.booking.date);
    _titleController.text = widget.booking.title.trim();
    _amountController.text = formatToMoneyAmount(widget.booking.amount.toString());
    _fromAccountController.text = widget.booking.fromAccount;
    _toAccountController.text = widget.booking.toAccount;
    _categorieController.text = widget.booking.categorie;
    _repetitionType = widget.booking.repetition;
    _bookingType = widget.booking.type;
  }

  void _backupOldBooking() {
    _oldBooking = Booking(
      id: widget.booking.id,
      type: widget.booking.type,
      title: widget.booking.title,
      date: widget.booking.date,
      repetition: widget.booking.repetition,
      amount: Amount.getValue(widget.booking.amount.toString()),
      currency: Amount.getCurrency(widget.booking.amount.toString()),
      fromAccount: widget.booking.fromAccount,
      toAccount: widget.booking.toAccount,
      categorie: widget.booking.categorie,
      isBooked: widget.booking.isBooked,
    );
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
      _updatedBooking = Booking(
        id: widget.booking.id,
        type: _bookingType,
        title: _titleController.text,
        date: dateFormatterDDMMYYYYEE.parse(_dateController.text), // parse DateFormat in ISO-8601
        repetition: _repetitionType,
        amount: Amount.getValue(_amountController.text),
        currency: Amount.getCurrency(_amountController.text),
        fromAccount: _fromAccountController.text,
        toAccount: _toAccountController.text,
        categorie: _categorieController.text,
        isBooked: dateFormatterDDMMYYYYEE.parse(_dateController.text).isBefore(DateTime.now()) ? true : false,
      );
      Timer(const Duration(milliseconds: durationInMs), () async {
        _reverseBooking();
        BlocProvider.of<BookingBloc>(context).add(EditBooking(_updatedBooking, context));
      });
    }
  }

  void _reverseBooking() {
    // Alte Buchung zuerst rückgängig machen...
    if (_oldBooking.type == BookingType.expense) {
      BlocProvider.of<account.AccountBloc>(context).add(account.AccountDeposit(_oldBooking));
    } else if (_oldBooking.type == BookingType.income) {
      BlocProvider.of<account.AccountBloc>(context).add(account.AccountWithdraw(_oldBooking));
    } else if (_oldBooking.type == BookingType.transfer || _oldBooking.type == BookingType.investment) {
      BlocProvider.of<account.AccountBloc>(context).add(
        account.AccountTransfer(
          _oldBooking.copyWith(
            fromAccount: _oldBooking.toAccount,
            toAccount: _oldBooking.fromAccount,
          ),
        ),
      );
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
      _categorieController.text = '';
      if (_bookingType == BookingType.transfer) {
        _categorieController.text = 'Übertrag';
      }
    });
  }

  void _changeRepetitionType(RepetitionType newRepetition) {
    setState(() {
      _repetitionType = newRepetition;
    });
    Navigator.pop(context);
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
          child: BlocListener<account.AccountBloc, account.AccountState>(
            listener: (context, state) {
              // Nachdem alte Buchung rückgängig gemacht wurde wird die bearbeitete Buchung gebucht
              if (state is account.Booked) {
                if (_bookingType == BookingType.expense) {
                  BlocProvider.of<account.AccountBloc>(context).add(account.AccountWithdraw(_updatedBooking));
                } else if (_bookingType == BookingType.income) {
                  BlocProvider.of<account.AccountBloc>(context).add(account.AccountDeposit(_updatedBooking));
                } else if (_bookingType == BookingType.transfer || _bookingType == BookingType.investment) {
                  BlocProvider.of<account.AccountBloc>(context).add(account.AccountTransfer(_updatedBooking));
                }
              }
            },
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
                      onSelectionChanged: (repetitionType) => _changeRepetitionType(repetitionType),
                    ),
                    TitleTextField(hintText: 'Titel...', titleController: _titleController),
                    AmountTextField(amountController: _amountController),
                    AccountInputField(
                      accountController: _fromAccountController,
                      hintText: _bookingType.name == BookingType.expense.name ? 'Abbuchungskonto...' : 'Konto...',
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
                    SaveButton(text: 'Speichern', saveBtnController: _editBookingBtnController, onPressed: () => _editBooking(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
