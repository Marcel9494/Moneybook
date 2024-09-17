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
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/domain/value_objects/amount.dart';
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
  // Wird benötigt, damit im BlocConsumer der listener auf das Event CheckAccountNameExists auch mehrfach reagiert, wenn
  // dieser Zähler nicht hochgezählt wird, wird das Event CheckedAccountName nicht erneut emittet, da es der gleiche
  // State wie bei dem ersten Aufruf des Events ist und somit nicht erneut aufgerufen wird. Vielleicht gibt es eine bessere Lösung.
  int _numberOfEventCalls = 0;

  @override
  void initState() {
    super.initState();
    _initializeAccount();
    _oldAccountName = widget.account.name;
  }

  void _initializeAccount() {
    _accountNameController.text = widget.account.name;
    _amountController.text = formatToMoneyAmount(widget.account.amount.toString());
    _accountTypeController.text = widget.account.type.name;
    _accountType = widget.account.type;
  }

  void _deleteAccount(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        if (widget.account.amount == 0.0) {
          return AlertDialog(
            title: const Text('Konto löschen?'),
            content: const Text('Wollen Sie das Konto wirklich löschen?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Ja'),
                onPressed: () {
                  BlocProvider.of<AccountBloc>(context).add(
                    DeleteAccount(widget.account.id),
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
        } else {
          return AlertDialog(
            title: const Text('Konto löschen?'),
            content: Form(
              key: _deleteAccountFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bevor Sie das Konto löschen können müssen Sie den restlichen Betrag von ${formatToMoneyAmount(widget.account.amount.toString())} auf ein anderes Konto übertragen.',
                    textAlign: TextAlign.justify,
                  ),
                  AccountInputField(
                    hintText: 'Konto',
                    accountController: _accountController,
                    accountNameFilter: [_oldAccountName],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ja'),
                onPressed: () {
                  // TODO hier weitermachen und prüfen das nicht auf gleiches Konto gebucht wird oder garnicht erst anzeigen lassen
                  final FormState form = _deleteAccountFormKey.currentState!;
                  if (form.validate()) {
                    Booking transferBooking = Booking(
                      id: widget.account.id,
                      type: BookingType.transfer,
                      title: 'Übertrag',
                      date: DateTime.now(), // parse DateFormat in ISO-8601,
                      repetition: RepetitionType.noRepetition,
                      amount: widget.account.amount,
                      currency: Amount.getCurrency(formatToMoneyAmount(widget.account.amount.toString())),
                      fromAccount: widget.account.name,
                      toAccount: _accountController.text,
                      categorie: 'Übertrag',
                      isBooked: true,
                    );
                    BlocProvider.of<booking.BookingBloc>(context).add(booking.CreateBooking(transferBooking));
                    BlocProvider.of<AccountBloc>(context).add(AccountTransfer(transferBooking));
                    BlocProvider.of<AccountBloc>(context).add(DeleteAccount(widget.account.id));
                  }
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
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async {
        BlocProvider.of<AccountBloc>(context).add(LoadAllAccounts());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Konto bearbeiten'),
          actions: [
            IconButton(
              onPressed: () => _deleteAccount(context),
              icon: const Icon(Icons.delete_forever_rounded),
            ),
          ],
        ),
        body: BlocListener<AccountBloc, AccountState>(
          listener: (BuildContext context, AccountState state) {
            if (state is Finished) {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(1));
            } else if (state is Deleted) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(0));
            } else if (state is CheckedAccountName) {
              FocusManager.instance.primaryFocus?.unfocus();
              final FormState form = _accountFormKey.currentState!;
              _numberOfEventCalls++;
              if (state.accountNameExists && _oldAccountName != _accountNameController.text.trim()) {
                _editAccountBtnController.error();
                Flushbar(
                  title: 'Kontoname existiert bereits',
                  message: 'Der Kontoname ${_accountNameController.text.trim()} existiert bereits. Bitte benennen Sie den Kontoname um.',
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
                _editAccountBtnController.success();
                Timer(const Duration(milliseconds: durationInMs), () {
                  BlocProvider.of<AccountBloc>(context).add(
                    EditAccount(
                      Account(
                        id: widget.account.id,
                        type: AccountType.fromString(_accountTypeController.text),
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
                      AccountTypeInputField(accountTypeController: _accountTypeController, accountType: _accountType.name),
                      TitleTextField(hintText: 'Kontoname...', titleController: _accountNameController, maxLength: 30),
                      AmountTextField(amountController: _amountController),
                      SaveButton(
                        text: 'Speichern',
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
