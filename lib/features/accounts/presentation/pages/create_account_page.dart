import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/accounts/domain/entities/account.dart';
import 'package:moneybook/features/accounts/presentation/widgets/input_fields/account_type_input_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../injection_container.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
import '../../../bookings/domain/value_objects/amount.dart';
import '../../domain/value_objects/account_type.dart';
import '../bloc/account_bloc.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormState> _accountFormKey = GlobalKey<FormState>();
  final TextEditingController _accountTypeController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final RoundedLoadingButtonController _createAccountBtnController = RoundedLoadingButtonController();
  final AccountType _accountType = AccountType.none;
  // Wird benötigt, damit im BlocConsumer der listener auf das Event CheckAccountNameExists auch mehrfach reagiert, wenn
  // dieser Zähler nicht hochgezählt wird, wird das Event CheckedAccountName nicht erneut emittet, da es der gleiche
  // State wie bei dem ersten Aufruf des Events ist und somit nicht erneut aufgerufen wird. Vielleicht gibt es eine bessere Lösung.
  int _numberOfEventCalls = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konto erstellen'),
      ),
      body: BlocProvider(
        create: (_) => sl<AccountBloc>(),
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: (BuildContext context, AccountState state) {
            if (state is Finished) {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(1));
            } else if (state is CheckedAccountName) {
              FocusManager.instance.primaryFocus?.unfocus();
              final FormState form = _accountFormKey.currentState!;
              _numberOfEventCalls++;
              if (state.accountNameExists) {
                _createAccountBtnController.error();
                Flushbar(
                  title: 'Kontoname existiert bereits',
                  message: 'Der Kontoname ${_accountNameController.text.trim()} existiert bereits. Bitte benennen Sie den Kontoname um.',
                  icon: const Icon(Icons.error_outline_rounded, color: Colors.yellowAccent),
                  duration: const Duration(milliseconds: flushbarDurationInMs),
                ).show(context);
                Timer(const Duration(milliseconds: durationInMs), () {
                  _createAccountBtnController.reset();
                });
              } else {
                if (form.validate() == false) {
                  _createAccountBtnController.error();
                  Timer(const Duration(milliseconds: durationInMs), () {
                    _createAccountBtnController.reset();
                  });
                } else {
                  _createAccountBtnController.success();
                  Timer(const Duration(milliseconds: durationInMs), () {
                    BlocProvider.of<AccountBloc>(context).add(
                      CreateAccount(
                        Account(
                          id: 0,
                          type: AccountType.fromString(_accountTypeController.text),
                          name: _accountNameController.text.trim(),
                          amount: Amount.getValue(_amountController.text),
                          currency: Amount.getCurrency(_amountController.text),
                        ),
                      ),
                    );
                  });
                }
              }
            }
          },
          builder: (BuildContext context, state) {
            return SingleChildScrollView(
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
                        AmountTextField(amountController: _amountController, showMinus: true),
                        SaveButton(
                          text: 'Erstellen',
                          saveBtnController: _createAccountBtnController,
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
            );
          },
        ),
      ),
    );
  }
}
