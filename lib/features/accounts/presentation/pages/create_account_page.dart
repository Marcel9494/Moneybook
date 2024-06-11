import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/accounts/domain/entities/account.dart';
import 'package:moneybook/features/accounts/presentation/widgets/account_type_input_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../injection_container.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final RoundedLoadingButtonController _createAccountBtnController = RoundedLoadingButtonController();
  final AccountType _accountType = AccountType.none;

  void _createAccount(BuildContext context) {
    final FormState form = _accountFormKey.currentState!;
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
              type: _accountType,
              name: _titleController.text,
              amount: Amount.getValue(_amountController.text),
              currency: Amount.getCurrency(_amountController.text),
            ),
          ),
        );
      });
    }
  }

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
              Navigator.popAndPushNamed(context, bottomNavBarRoute);
            }
          },
          builder: (BuildContext context, state) {
            if (state is Initial) {
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
                          TitleTextField(hintText: 'Kontoname...', titleController: _titleController),
                          AmountTextField(amountController: _amountController),
                          SaveButton(text: 'Erstellen', saveBtnController: _createAccountBtnController, onPressed: () => _createAccount(context)),
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
