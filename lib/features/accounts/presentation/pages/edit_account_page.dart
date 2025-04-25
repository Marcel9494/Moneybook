import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/accounts/domain/entities/account.dart';
import 'package:moneybook/features/accounts/presentation/widgets/input_fields/account_type_input_field.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';
import 'package:moneybook/features/bookings/presentation/widgets/input_fields/account_input_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/domain/value_objects/amount.dart';
import '../../../bookings/domain/value_objects/amount_type.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart' as booking;
import '../../domain/value_objects/account_type.dart';
import '../bloc/account_bloc.dart';

class EditAccountPage extends StatefulWidget {
  final Account account;

  const EditAccountPage({
    super.key,
    required this.account,
  });

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final GlobalKey<FormState> _accountFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _deleteAccountFormKey = GlobalKey<FormState>();
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final RoundedLoadingButtonController _editAccountBtnController = RoundedLoadingButtonController();
  late AccountType _accountType;
  String _oldAccountName = '';
  double _oldAccountAmount = 0.0;
  // Wird benötigt, damit im BlocConsumer der listener auf das Event CheckAccountNameExists auch mehrfach reagiert, wenn
  // dieser Zähler nicht hochgezählt wird, wird das Event CheckedAccountName nicht erneut emittet, da es der gleiche
  // State wie bei dem ersten Aufruf des Events ist und somit nicht erneut aufgerufen wird. Vielleicht gibt es eine bessere Lösung.
  int _numberOfEventCalls = 0;
  String _accountTypeForDb = '';
  String _accountNameForDb = '';
  String _toAccountNameForDb = '';

  @override
  void initState() {
    super.initState();
    _oldAccountName = widget.account.name;
    _oldAccountAmount = widget.account.amount;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeAccount(); // Wird erst hier aufgerufen, weil ab hier der context verfügbar ist, in initState noch nicht.
  }

  void _initializeAccount() {
    _accountNameController.text = AppLocalizations.of(context).translate(widget.account.name);
    _amountController.text = formatToMoneyAmount(widget.account.amount.toString());
    _accountTypeController.text = AppLocalizations.of(context).translate(widget.account.type.name);
    _accountType = widget.account.type;

    _accountTypeForDb = widget.account.type.name;
    _accountNameForDb = widget.account.name;
  }

  void _deleteAccount(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        if (widget.account.amount == 0.0) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).translate('buchung_löschen')),
            content: Text(AppLocalizations.of(context).translate('buchung_löschen_beschreibung')),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context).translate('ja')),
                onPressed: () {
                  BlocProvider.of<AccountBloc>(context).add(
                    DeleteAccount(widget.account.id),
                  );
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
        } else {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).translate('konto_löschen')),
            content: Form(
              key: _deleteAccountFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('konto_löschen_übertrag_beschreibung'),
                    textAlign: TextAlign.justify,
                  ),
                  AccountInputField(
                    hintText: AppLocalizations.of(context).translate('konto'),
                    accountController: _accountController,
                    onAccountSelected: (toAccountNameForDb) => _setToAccountNameForDb(toAccountNameForDb),
                    accountNameFilter: [_oldAccountName],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context).translate('ja')),
                onPressed: () {
                  final FormState form = _deleteAccountFormKey.currentState!;
                  if (form.validate()) {
                    Booking transferBooking = Booking(
                      id: 0, // id wird automatisch hochgezählt (SQL: AUTOINCREMENT)
                      serieId: -1,
                      type: BookingType.transfer,
                      title: AppLocalizations.of(context).translate('übertrag'),
                      date: DateTime.now(), // parse DateFormat in ISO-8601,
                      repetition: RepetitionType.noRepetition,
                      amount: widget.account.amount,
                      amountType: AmountType.undefined,
                      currency: Amount.getCurrency(formatToMoneyAmount(widget.account.amount.toString())),
                      fromAccount: _accountNameForDb, // widget.account.name,
                      toAccount: _toAccountNameForDb, //_accountController.text,
                      categorie: AppLocalizations.of(context).translate('übertrag'),
                      isBooked: true,
                    );
                    BlocProvider.of<booking.BookingBloc>(context).add(booking.CreateBooking(transferBooking));
                    BlocProvider.of<AccountBloc>(context).add(AccountTransfer(booking: transferBooking, bookedId: 0));
                    BlocProvider.of<AccountBloc>(context).add(DeleteAccount(widget.account.id));
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
        }
      },
    );
  }

  void _editAccount(BuildContext context) {
    if (_oldAccountAmount != formatMoneyAmountToDouble(_amountController.text)) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).translate('neue_buchung')),
            content: Text(AppLocalizations.of(context).translate('neue_buchung_beschreibung')),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context).translate('ja')),
                onPressed: () {
                  _editAccountWithNewAmount(context, true);
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context).translate('nein')),
                onPressed: () {
                  _editAccountWithNewAmount(context, false);
                },
              ),
            ],
          );
        },
      );
    } else {
      Timer(const Duration(milliseconds: durationInMs), () {
        BlocProvider.of<AccountBloc>(context).add(
          EditAccount(
            Account(
              id: widget.account.id,
              type: AccountType.fromString(_accountTypeForDb),
              name: _accountNameController.text.trim(),
              amount: Amount.getValue(_amountController.text),
              currency: Amount.getCurrency(_amountController.text),
            ),
          ),
        );
        BlocProvider.of<booking.BookingBloc>(context).add(
          booking.UpdateBookingsWithAccount(
            _oldAccountName,
            _accountNameController.text,
          ),
        );
      });
      _editAccountBtnController.success();
    }
  }

  void _editAccountWithNewAmount(BuildContext context, bool createBooking) {
    Booking newBooking = Booking(
      id: 0,
      serieId: -1,
      type: _oldAccountAmount < formatMoneyAmountToDouble(_amountController.text) ? BookingType.income : BookingType.expense,
      title: AppLocalizations.of(context).translate('kontoänderung'),
      date: DateTime.now(),
      repetition: RepetitionType.noRepetition,
      amount: (formatMoneyAmountToDouble(_amountController.text) - _oldAccountAmount).abs(),
      amountType: AmountType.undefined,
      currency: Amount.getCurrency(_amountController.text),
      fromAccount: widget.account.name,
      toAccount: '',
      categorie: AppLocalizations.of(context).translate('kontoänderung'),
      isBooked: true,
    );
    if (createBooking) {
      BlocProvider.of<booking.BookingBloc>(context).add(booking.CreateBooking(newBooking));
    }
    if (_oldAccountAmount < formatMoneyAmountToDouble(_amountController.text)) {
      BlocProvider.of<AccountBloc>(context).add(AccountDeposit(booking: newBooking, bookedId: 0));
    } else if (_oldAccountAmount > formatMoneyAmountToDouble(_amountController.text)) {
      BlocProvider.of<AccountBloc>(context).add(AccountWithdraw(booking: newBooking, bookedId: 0));
    }
    Timer(const Duration(milliseconds: durationInMs), () {
      BlocProvider.of<AccountBloc>(context).add(
        EditAccount(
          Account(
            id: widget.account.id,
            type: AccountType.fromString(_accountTypeForDb),
            name: _accountNameController.text.trim(),
            amount: Amount.getValue(_amountController.text),
            currency: Amount.getCurrency(_amountController.text),
          ),
        ),
      );
      BlocProvider.of<booking.BookingBloc>(context).add(
        booking.UpdateBookingsWithAccount(
          _oldAccountName,
          _accountNameController.text,
        ),
      );
      Navigator.pop(context);
      _editAccountBtnController.success();
    });
  }

  void _setAccountTypeForDb(String accountTypeForDb) {
    setState(() {
      _accountTypeForDb = accountTypeForDb;
    });
  }

  void _setToAccountNameForDb(String toAccountNameForDb) {
    setState(() {
      _toAccountNameForDb = toAccountNameForDb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async {
        BlocProvider.of<AccountBloc>(context).add(LoadAccounts());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('konto_bearbeiten')),
          actions: [
            IconButton(
              onPressed: () => _deleteAccount(context),
              icon: const Icon(Icons.delete_forever_rounded),
            ),
          ],
        ),
        body: BlocListener<AccountBloc, AccountState>(
          listener: (BuildContext context, AccountState state) {
            if (state is Deleted || state is Finished) {
              Navigator.pushNamedAndRemoveUntil(context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 1), (route) => false);
            } else if (state is CheckedAccountName) {
              FocusManager.instance.primaryFocus?.unfocus();
              final FormState form = _accountFormKey.currentState!;
              _numberOfEventCalls++;
              if (state.accountNameExists && _oldAccountName != _accountNameController.text.trim()) {
                _editAccountBtnController.error();
                Flushbar(
                  title: AppLocalizations.of(context).translate('kontoname_existiert_bereits') + '...',
                  message: AppLocalizations.of(context).translate('kontoname_existiert_bereits_beschreibung'),
                  icon: const Icon(Icons.error_outline_rounded, color: Colors.yellowAccent),
                  duration: const Duration(milliseconds: flushbarDurationInMs),
                ).show(context);
                Timer(const Duration(milliseconds: durationInMs), () {
                  _editAccountBtnController.reset();
                });
              } else if (form.validate() == false) {
                _editAccountBtnController.error();
                Timer(const Duration(milliseconds: durationInMs), () {
                  _editAccountBtnController.reset();
                });
              } else {
                _editAccount(context);
              }
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Card(
                child: Form(
                  key: _accountFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AccountTypeInputField(
                        accountTypeController: _accountTypeController,
                        onAccountTypeSelected: (accountTypeForDb) => _setAccountTypeForDb(accountTypeForDb),
                        accountType: AppLocalizations.of(context).translate(_accountTypeForDb),
                      ),
                      TitleTextField(
                        hintText: AppLocalizations.of(context).translate('kontoname') + '...',
                        titleController: _accountNameController,
                        maxLength: 30,
                      ),
                      AmountTextField(
                        amountController: _amountController,
                        hintText: AppLocalizations.of(context).translate('betrag') + '...',
                        showMinus: true,
                      ),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('speichern'),
                        saveBtnController: _editAccountBtnController,
                        onPressed: () => BlocProvider.of<AccountBloc>(context).add(
                          CheckAccountNameExists(
                            _accountNameController.text.trim(),
                            _numberOfEventCalls,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
