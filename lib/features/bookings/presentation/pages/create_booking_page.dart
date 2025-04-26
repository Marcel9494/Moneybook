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
import '../../../../core/utils/app_localizations.dart';
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
  String _categorieNameForDb = '';
  String _fromAccountNameForDb = '';
  String _toAccountNameForDb = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dateController.text = DateFormatter.dateFormatDDMMYYYYEEDateTime(DateTime.now(), context);
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
        date: DateFormatter.dateFormatDDMMYYYYEEString(_dateController.text, context), // parse DateFormat in ISO-8601
        repetition: _repetitionType,
        amount: Amount.getValue(_amountController.text),
        amountType: _amountType,
        currency: Amount.getCurrency(_amountController.text),
        fromAccount: _fromAccountNameForDb,
        toAccount: _toAccountNameForDb,
        categorie: _categorieNameForDb,
        isBooked: DateFormatter.dateFormatDDMMYYYYEEString(_dateController.text, context).isBefore(DateTime.now()) ? true : false,
      );
      Timer(const Duration(milliseconds: durationInMs), () {
        if (newBooking.repetition == RepetitionType.noRepetition) {
          BlocProvider.of<BookingBloc>(context).add(CreateBooking(newBooking));
          if (_bookingType == BookingType.expense) {
            BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(booking: newBooking, bookedId: 0));
          } else if (_bookingType == BookingType.income) {
            BlocProvider.of<AccountBloc>(context).add(AccountDeposit(booking: newBooking, bookedId: 0));
          } else if (_bookingType == BookingType.transfer || _bookingType == BookingType.investment) {
            BlocProvider.of<AccountBloc>(context).add(AccountTransfer(booking: newBooking, bookedId: 0));
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
        _categorieController.text = AppLocalizations.of(context).translate('übertrag');
        _categorieNameForDb = 'übertrag';
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
    _repetitionType = newRepetitionType;
    if (_repetitionType == RepetitionType.monthlyBeginning) {
      final parsedDate = DateFormatter.dateFormatDDMMYYYYEEString(_dateController.text, context);
      final firstOfMonth = DateTime(parsedDate.year, parsedDate.month, 1);
      final formattedDate = DateFormatter.dateFormatDDMMYYYYEEDateTime(firstOfMonth, context);
      _dateController.text = formattedDate;
    } else if (_repetitionType == RepetitionType.monthlyEnding) {
      final parsedDate = DateFormatter.dateFormatDDMMYYYYEEString(_dateController.text, context);
      final firstOfMonth = DateTime(parsedDate.year, parsedDate.month + 1, 0);
      final formattedDate = DateFormatter.dateFormatDDMMYYYYEEDateTime(firstOfMonth, context);
      _dateController.text = formattedDate;
    }
    setState(() {});
    Navigator.pop(context);
  }

  void _changeAmountType(AmountType newAmountType) {
    setState(() {
      _amountType = newAmountType;
    });
    Navigator.pop(context);
  }

  void _setCategorieForDb(String categorieForDb) {
    setState(() {
      _categorieNameForDb = categorieForDb;
    });
  }

  void _setFromAccountNameForDb(String fromAccountNameForDb) {
    setState(() {
      _fromAccountNameForDb = fromAccountNameForDb;
    });
  }

  void _setToAccountNameForDb(String toAccountNameForDb) {
    setState(() {
      _toAccountNameForDb = toAccountNameForDb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('buchung_erstellen')),
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
                BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(booking: state.bookings[0], bookedId: 0));
              } else if (_bookingType == BookingType.income) {
                BlocProvider.of<AccountBloc>(context).add(AccountDeposit(booking: state.bookings[0], bookedId: 0));
              } else if (_bookingType == BookingType.transfer || _bookingType == BookingType.investment) {
                BlocProvider.of<AccountBloc>(context).add(AccountTransfer(booking: state.bookings[0], bookedId: 0));
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
                          TitleTextField(hintText: AppLocalizations.of(context).translate('titel') + '...', titleController: _titleController),
                          AmountTextField(
                            amountController: _amountController,
                            hintText: AppLocalizations.of(context).translate('betrag') + '...',
                            bookingType: _bookingType,
                            amountType: _amountType.name,
                            onAmountTypeChanged: (amountType) => _changeAmountType(amountType),
                          ),
                          AccountInputField(
                              accountController: _fromAccountController,
                              onAccountSelected: (accountNameForDb) => _setFromAccountNameForDb(accountNameForDb),
                              hintText: _bookingType.name == BookingType.expense.name || _bookingType.name == BookingType.income.name
                                  ? AppLocalizations.of(context).translate('konto') + '...'
                                  : AppLocalizations.of(context).translate('abbuchungskonto') + '...',
                              bottomSheetTitle: _bookingType.name == BookingType.expense.name || _bookingType.name == BookingType.income.name
                                  ? AppLocalizations.of(context).translate('konto_auswählen') + ':'
                                  : AppLocalizations.of(context).translate('abbuchungskonto_auswählen') + ':'),
                          _bookingType.name == BookingType.transfer.name || _bookingType.name == BookingType.investment.name
                              ? AccountInputField(
                                  accountController: _toAccountController,
                                  onAccountSelected: (accountNameForDb) => _setToAccountNameForDb(accountNameForDb),
                                  hintText: AppLocalizations.of(context).translate('konto') + '...',
                                  bottomSheetTitle: AppLocalizations.of(context).translate('konto_auswählen') + ':',
                                )
                              : const SizedBox(),
                          _bookingType.name == BookingType.transfer.name
                              ? const SizedBox()
                              : CategorieInputField(
                                  categorieController: _categorieController,
                                  onCategorieSelected: (categorieNameForDb) => _setCategorieForDb(categorieNameForDb),
                                  bookingType: _bookingType,
                                ),
                          SaveButton(
                              text: AppLocalizations.of(context).translate('erstellen'),
                              saveBtnController: _createBookingBtnController,
                              onPressed: () => _createBooking(context)),
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
