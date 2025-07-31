import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/input_fields/categorie_input_field.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../injection_container.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../bookings/domain/value_objects/amount.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../domain/entities/budget.dart';
import '../bloc/budget_bloc.dart';

class CreateBudgetPage extends StatefulWidget {
  const CreateBudgetPage({super.key});

  @override
  State<CreateBudgetPage> createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  final GlobalKey<FormState> _budgetFormKey = GlobalKey<FormState>();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final RoundedLoadingButtonController _createBudgetBtnController = RoundedLoadingButtonController();
  String _categorieNameForDb = '';

  void _createBudget(BuildContext context) {
    final FormState form = _budgetFormKey.currentState!;
    if (form.validate() == false) {
      _createBudgetBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _createBudgetBtnController.reset();
      });
    } else {
      _createBudgetBtnController.success();
      var dateFormatter = dateFormatterYYYYMMDD;
      var formattedDate = dateFormatter.format(DateTime.now());
      Budget newBudget = Budget(
        id: 0,
        categorie: _categorieNameForDb,
        date: dateFormatter.parse(formattedDate),
        amount: Amount.getValue(_amountController.text),
        used: 0.0,
        remaining: Amount.getValue(_amountController.text),
        percentage: 0.0,
        currency: Amount.getCurrency(_amountController.text),
      );
      Timer(const Duration(milliseconds: durationInMs), () {
        BlocProvider.of<BudgetBloc>(context).add(CreateBudget(newBudget));
        Posthog().capture(
          eventName: 'Budget erstellt',
          properties: {
            'Aktion': 'Budget erstellt',
          },
        );
      });
    }
  }

  void _setCategorieForDb(String categorieForDb) {
    setState(() {
      _categorieNameForDb = categorieForDb;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('budget_erstellen')),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<BudgetBloc>(),
          ),
        ],
        child: BlocProvider(
          create: (context) => sl<BudgetBloc>(),
          child: BlocConsumer<BudgetBloc, BudgetState>(
            listener: (BuildContext context, BudgetState state) {
              if (state is Finished) {
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(tabIndex: 3));
              }
            },
            builder: (BuildContext context, state) {
              if (state is Initial) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Card(
                      child: Form(
                        key: _budgetFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CategorieInputField(
                              categorieController: _categorieController,
                              onCategorieSelected: (categorieNameForDb) => _setCategorieForDb(categorieNameForDb),
                              bookingType: BookingType.expense,
                            ),
                            AmountTextField(
                              amountController: _amountController,
                              hintText: AppLocalizations.of(context).translate('budget') + '...',
                            ),
                            SaveButton(
                              text: AppLocalizations.of(context).translate('erstellen'),
                              saveBtnController: _createBudgetBtnController,
                              onPressed: () => _createBudget(context),
                            ),
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
      ),
    );
  }
}
