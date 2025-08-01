import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/shared/domain/value_objects/serie_mode_type.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
import '../../../accounts/presentation/bloc/account_bloc.dart' as account;
import '../../../accounts/presentation/bloc/account_bloc.dart';
import '../../domain/entities/booking.dart';
import '../../domain/value_objects/amount.dart';
import '../../domain/value_objects/amount_type.dart';
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
  late AmountType _amountType;
  late Booking _oldBooking;
  List<Booking> _oldSerieBookings = [];
  Booking? _updatedBooking;
  bool _hasAccountListenerTriggered = false;
  String _categorieNameForDb = '';
  String _fromAccountNameForDb = '';
  String _toAccountNameForDb = '';

  @override
  void initState() {
    super.initState();
    if (widget.editMode == SerieModeType.one) {
      _backupOldBooking();
    } else if (widget.editMode == SerieModeType.onlyFuture || widget.editMode == SerieModeType.all) {
      _backupOldBookings();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeBooking(); // Wird erst hier aufgerufen, weil ab hier der context verfügbar ist, in initState noch nicht.
  }

  void _initializeBooking() {
    _dateController.text = DateFormatter.dateFormatDDMMYYYYEEDateTime(widget.booking.date, context);
    _titleController.text = widget.booking.title.trim();
    _amountController.text = formatToMoneyAmount(widget.booking.amount.toString());
    _fromAccountController.text = AppLocalizations.of(context).translate(widget.booking.fromAccount);
    _toAccountController.text = AppLocalizations.of(context).translate(widget.booking.toAccount);
    _categorieController.text = AppLocalizations.of(context).translate(widget.booking.categorie);
    _repetitionType = widget.booking.repetition;
    _bookingType = widget.booking.type;
    _amountType = widget.booking.amountType;

    _categorieNameForDb = widget.booking.categorie;
    _fromAccountNameForDb = widget.booking.fromAccount;
    _toAccountNameForDb = widget.booking.toAccount;
  }

  void _backupOldBooking() {
    _oldBooking = Booking(
      id: widget.booking.id,
      serieId: widget.booking.serieId,
      type: widget.booking.type,
      title: widget.booking.title,
      date: widget.booking.date,
      repetition: widget.booking.repetition,
      amount: widget.booking.amount,
      amountType: widget.booking.amountType,
      currency: Amount.getCurrency(widget.booking.amount.toString()),
      fromAccount: widget.booking.fromAccount,
      toAccount: widget.booking.toAccount,
      categorie: widget.booking.categorie,
      isBooked: widget.booking.isBooked,
    );
  }

  void _backupOldBookings() {
    BlocProvider.of<BookingBloc>(context).add(LoadSerieBookings(widget.booking.serieId));
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
        serieId: widget.booking.serieId,
        type: _bookingType,
        title: _titleController.text,
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
      Future.delayed(const Duration(milliseconds: durationInMs), () async {
        // TODO hier weitermachen und async und await entfernen?
        if (widget.editMode == SerieModeType.one) {
          await _reverseBooking();
          await _updateBooking(_updatedBooking!);
          BlocProvider.of<BookingBloc>(context).add(UpdateBooking(_updatedBooking!, context));
        } else if (widget.editMode == SerieModeType.onlyFuture) {
          BlocProvider.of<BookingBloc>(context).add(UpdateOnlyFutureSerieBookings(_updatedBooking!, _oldSerieBookings, _bookingType, context));
        } else if (widget.editMode == SerieModeType.all) {
          BlocProvider.of<BookingBloc>(context).add(UpdateAllSerieBookings(_updatedBooking!, _oldSerieBookings, _bookingType, context));
        }
        Posthog().capture(
          eventName: 'Buchung bearbeitet',
          properties: {
            'Aktion': 'Buchung bearbeitet',
          },
        );
      });
    }
  }

  // Alte Buchung zuerst rückgängig machen...
  Future<void> _reverseBooking() async {
    if (_oldBooking.type == BookingType.expense) {
      BlocProvider.of<AccountBloc>(context).add(AccountDeposit(booking: _oldBooking, bookedId: 0));
    } else if (_oldBooking.type == BookingType.income) {
      BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(booking: _oldBooking, bookedId: 0));
    } else if (_oldBooking.type == BookingType.transfer || _oldBooking.type == BookingType.investment) {
      BlocProvider.of<AccountBloc>(context).add(
        AccountTransfer(
          booking: _oldBooking.copyWith(
            fromAccount: _oldBooking.toAccount,
            toAccount: _oldBooking.fromAccount,
          ),
          bookedId: 0,
        ),
      );
    }
  }

  // ... dann bearbeitete Buchung buchen
  Future<void> _updateBooking(Booking updatedBooking) async {
    // TODO bessere Lösung für Random().nextInt(1000000) finden!
    if (_bookingType == BookingType.expense) {
      BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(booking: updatedBooking, bookedId: Random().nextInt(1000000)));
    } else if (_bookingType == BookingType.income) {
      BlocProvider.of<AccountBloc>(context).add(AccountDeposit(booking: updatedBooking, bookedId: Random().nextInt(1000000)));
    } else if (_bookingType == BookingType.transfer || _bookingType == BookingType.investment) {
      BlocProvider.of<AccountBloc>(context).add(AccountTransfer(booking: updatedBooking, bookedId: Random().nextInt(1000000)));
    }
  }

  void _deleteBooking(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('buchung_löschen')),
          content: Text(AppLocalizations.of(context).translate('buchung_löschen_beschreibung')),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).translate('ja')),
              onPressed: () {
                _hasAccountListenerTriggered = true;
                if (widget.editMode == SerieModeType.one) {
                  BlocProvider.of<BookingBloc>(context).add(DeleteBooking(widget.booking, context));
                } else if (widget.editMode == SerieModeType.onlyFuture) {
                  BlocProvider.of<BookingBloc>(context)
                      .add(DeleteOnlyFutureSerieBookings(widget.booking.serieId, _oldSerieBookings, widget.booking.date, context));
                } else if (widget.editMode == SerieModeType.all) {
                  BlocProvider.of<BookingBloc>(context).add(DeleteAllSerieBookings(widget.booking.serieId, _oldSerieBookings, context));
                }
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).translate('nein')),
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
        _categorieController.text = AppLocalizations.of(context).translate('übertrag');
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

  void _changeRepetitionType(RepetitionType newRepetition) {
    setState(() {
      _repetitionType = newRepetition;
    });
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
        title: Text(AppLocalizations.of(context).translate('buchung_bearbeiten')),
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
          child: MultiBlocListener(
            listeners: [
              BlocListener<account.AccountBloc, account.AccountState>(
                listener: (context, state) {
                  // Serienbuchungen rückgängig machen...
                  if (state is account.Booked && _hasAccountListenerTriggered == false) {
                    if (widget.editMode == SerieModeType.onlyFuture || widget.editMode == SerieModeType.all) {
                      // TODO kann entfernt werden ifs auch?
                      /*double overallOldSerieAmount = 0.0;
                      if (widget.editMode == SerieModeType.onlyFuture) {
                        for (int i = 0; i < _oldSerieBookings.length; i++) {
                          if (_oldSerieBookings[i].date.isAfter(_oldSerieBookings[0].date) && _oldSerieBookings[i].date.isBefore(DateTime.now())) {
                            overallOldSerieAmount += _oldSerieBookings[i].amount;
                          }
                        }
                      } else if (widget.editMode == SerieModeType.all) {
                        for (int i = 0; i < _oldSerieBookings.length; i++) {
                          if (_oldSerieBookings[i].date.isBefore(DateTime.now())) {
                            overallOldSerieAmount += _oldSerieBookings[i].amount;
                          }
                        }
                      }
                      _oldSerieBookings[0] = _oldSerieBookings[0].copyWith(amount: overallOldSerieAmount);
                      if (_oldSerieBookings[0].type == BookingType.expense) {
                        BlocProvider.of<AccountBloc>(context).add(AccountDeposit(_oldSerieBookings[0], 0));
                      } else if (_oldSerieBookings[0].type == BookingType.income) {
                        BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(_oldSerieBookings[0], 0));
                      } else if (_oldSerieBookings[0].type == BookingType.transfer || _oldSerieBookings[0].type == BookingType.investment) {
                        BlocProvider.of<AccountBloc>(context).add(AccountTransfer(_oldSerieBookings[0], 0)); // TODO funktioniert das so?
                      }
                      // Account Listener soll nur 1x getriggert werden, weil es sonst zu Mehrfachbuchungen auf Konten kommen kann.
                      setState(() {
                        _hasAccountListenerTriggered = true;
                      });*/
                      //Navigator.pushNamedAndRemoveUntil(context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 0), (route) => false);
                    }
                  }
                },
              ),
              BlocListener<BookingBloc, BookingState>(
                listener: (context, state) {
                  if (state is SerieLoaded) {
                    for (int i = 0; i < state.bookings.length; i++) {
                      _oldSerieBookings.add(Booking(
                        id: state.bookings[i].id,
                        serieId: state.bookings[i].serieId,
                        type: state.bookings[i].type,
                        title: state.bookings[i].title,
                        date: state.bookings[i].date,
                        repetition: state.bookings[i].repetition,
                        amount: Amount.getValue(state.bookings[i].amount.toString()),
                        amountType: state.bookings[i].amountType,
                        currency: Amount.getCurrency(state.bookings[i].amount.toString()),
                        fromAccount: state.bookings[i].fromAccount,
                        toAccount: state.bookings[i].toAccount,
                        categorie: state.bookings[i].categorie,
                        isBooked: state.bookings[i].isBooked,
                      ));
                    }
                  } else if (state is SerieUpdated) {
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
                    // TODO Random().nextInt(1000000) bessere Lösung finden!
                    if (_bookingType == BookingType.expense) {
                      BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(booking: state.bookings[0], bookedId: Random().nextInt(1000000)));
                    } else if (_bookingType == BookingType.income) {
                      BlocProvider.of<AccountBloc>(context).add(AccountDeposit(booking: state.bookings[0], bookedId: Random().nextInt(1000000)));
                    } else if (_bookingType == BookingType.transfer || _bookingType == BookingType.investment) {
                      BlocProvider.of<AccountBloc>(context).add(AccountTransfer(booking: state.bookings[0], bookedId: Random().nextInt(1000000)));
                    }
                  }
                },
              ),
            ],
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
                      activateRepetition: false,
                      activateDatePicker: widget.editMode == SerieModeType.one ? true : false,
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
                          : AppLocalizations.of(context).translate('abbuchungskonto_auswählen') + ':',
                    ),
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
                        text: AppLocalizations.of(context).translate('speichern'),
                        saveBtnController: _editBookingBtnController,
                        onPressed: () => _editBooking(context)),
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
