import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/accounts/presentation/bloc/account_bloc.dart';
import 'package:moneybook/features/bookings/domain/value_objects/amount.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart' as booking_state;
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
import '../../domain/value_objects/amount_type.dart';
import '../../domain/value_objects/booking_type.dart';
import '../bloc/booking_bloc.dart';
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
  RepetitionType _repetitionType = RepetitionType.noRepetition;
  BookingType _bookingType = BookingType.expense;
  AmountType _amountType = AmountType.variable;

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
      Booking newBooking = Booking(
        id: 0,
        serieId: -1,
        type: _bookingType,
        title: _titleController.text.trim(),
        date: dateFormatterDDMMYYYYEE.parse(_dateController.text), // parse DateFormat in ISO-8601
        repetition: _repetitionType,
        amount: Amount.getValue(_amountController.text),
        amountType: _amountType,
        currency: Amount.getCurrency(_amountController.text),
        fromAccount: _fromAccountController.text,
        toAccount: _toAccountController.text,
        categorie: _categorieController.text,
        isBooked: dateFormatterDDMMYYYYEE.parse(_dateController.text).isBefore(DateTime.now()) ? true : false,
      );
      Timer(const Duration(milliseconds: durationInMs), () {
        if (newBooking.repetition == RepetitionType.noRepetition) {
          BlocProvider.of<BookingBloc>(context).add(CreateBooking(newBooking));
          if (_bookingType == BookingType.expense) {
            BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(newBooking, 0));
          } else if (_bookingType == BookingType.income) {
            BlocProvider.of<AccountBloc>(context).add(AccountDeposit(newBooking, 0));
          } else if (_bookingType == BookingType.transfer || _bookingType == BookingType.investment) {
            BlocProvider.of<AccountBloc>(context).add(AccountTransfer(newBooking, 0));
          }
        } else {
          BlocProvider.of<BookingBloc>(context).add(CreateSerieBooking(newBooking));
        }
      });
    }
  }

  void _changeBookingType(Set<BookingType> newBookingType) {
    setState(() {
      _bookingType = newBookingType.first;
      _categorieController.text = '';
      if (_bookingType == BookingType.transfer) {
        _categorieController.text = 'Übertrag';
        _amountType = AmountType.undefined;
      }
      if (_bookingType == BookingType.expense) {
        _amountType = AmountType.variable;
      } else if (_bookingType == BookingType.income) {
        _amountType = AmountType.active;
      } else if (_bookingType == BookingType.investment) {
        _amountType = AmountType.buy;
      }
    });
  }

  void _changeRepetitionType(RepetitionType newRepetitionType) {
    setState(() {
      _repetitionType = newRepetitionType;
    });
    if (_repetitionType == RepetitionType.monthlyBeginning) {
      _dateController.text = dateFormatterDDMMYYYYEE
          .format(DateTime(dateFormatterDDMMYYYYEE.parse(_dateController.text).year, dateFormatterDDMMYYYYEE.parse(_dateController.text).month, 1));
    } else if (_repetitionType == RepetitionType.monthlyEnding) {
      _dateController.text = dateFormatterDDMMYYYYEE.format(
          DateTime(dateFormatterDDMMYYYYEE.parse(_dateController.text).year, dateFormatterDDMMYYYYEE.parse(_dateController.text).month + 1, 0));
    }
    Navigator.pop(context);
  }

  void _changeAmountType(AmountType newAmountType) {
    setState(() {
      _amountType = newAmountType;
    });
    Navigator.pop(context);
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
            if (state is booking_state.Finished) {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0));
            } else if (state is booking_state.SerieFinished) {
              // Die Beträge der Serienbuchungen die in der Vergangenheit liegen werden zusammengerechnet und
              // das entsprechende Konto einmal aktualisiert mit dem gesamten Serienbuchungsbetrag. Datenbank
              // muss somit nur einmal aufgerufen werden.
              double overallSerieAmount = 0.0;
              for (int i = 0; i < state.bookings.length; i++) {
                if (state.bookings[i].date.isBefore(DateTime.now())) {
                  overallSerieAmount += state.bookings[i].amount;
                }
              }
              state.bookings[0] = state.bookings[0].copyWith(amount: overallSerieAmount);
              if (_bookingType == BookingType.expense) {
                BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(state.bookings[0], 0));
              } else if (_bookingType == BookingType.income) {
                BlocProvider.of<AccountBloc>(context).add(AccountDeposit(state.bookings[0], 0));
              } else if (_bookingType == BookingType.transfer || _bookingType == BookingType.investment) {
                BlocProvider.of<AccountBloc>(context).add(AccountTransfer(state.bookings[0], 0));
              }
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0));
            }
          },
          builder: (BuildContext context, state) {
            // TODO wird Initial state hier noch benötigt?
            if (state is booking_state.Initial) {
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
                            onSelectionChanged: (repetitionType) => _changeRepetitionType(repetitionType),
                          ),
                          TitleTextField(hintText: 'Titel...', titleController: _titleController),
                          AmountTextField(
                            amountController: _amountController,
                            bookingType: _bookingType,
                            amountType: _amountType.name,
                            onAmountTypeChanged: (amountType) => _changeAmountType(amountType),
                          ),
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
