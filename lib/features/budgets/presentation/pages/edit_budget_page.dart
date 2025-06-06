import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/input_fields/categorie_input_field.dart';
import 'package:moneybook/features/budgets/domain/entities/budget.dart';
import 'package:moneybook/shared/domain/value_objects/serie_mode_type.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../injection_container.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../bookings/domain/value_objects/amount.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../bloc/budget_bloc.dart';

class EditBudgetPage extends StatefulWidget {
  final Budget budget;
  final SerieModeType serieMode;

  const EditBudgetPage({
    super.key,
    required this.budget,
    required this.serieMode,
  });

  @override
  State<EditBudgetPage> createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  final GlobalKey<FormState> _budgetFormKey = GlobalKey<FormState>();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final RoundedLoadingButtonController _editBudgetBtnController = RoundedLoadingButtonController();
  late Budget _updatedBudget;
  String _categorieNameForDb = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeBudget(); // Wird erst hier aufgerufen, weil ab hier der context verfügbar ist, in initState noch nicht.
  }

  void _initializeBudget() {
    _amountController.text = formatToMoneyAmount(widget.budget.amount.toString());
    _categorieController.text = AppLocalizations.of(context).translate(widget.budget.categorie);

    _categorieNameForDb = widget.budget.categorie;
  }

  void _editBudget(BuildContext context) {
    final FormState form = _budgetFormKey.currentState!;
    if (form.validate() == false) {
      _editBudgetBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _editBudgetBtnController.reset();
      });
    } else {
      _editBudgetBtnController.success();
      _updatedBudget = Budget(
        id: widget.budget.id,
        categorie: _categorieNameForDb,
        date: widget.budget.date,
        amount: Amount.getValue(_amountController.text),
        used: 0.0,
        remaining: 0.0,
        percentage: 0.0,
        currency: Amount.getCurrency(_amountController.text),
      );
      Timer(const Duration(milliseconds: durationInMs), () async {
        BlocProvider.of<BudgetBloc>(context).add(EditBudget(_updatedBudget, widget.serieMode, context));
      });
    }
  }

  void _deleteBudget(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('budget_löschen')),
          content: Text(AppLocalizations.of(context).translate('budget_löschen_beschreibung')),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).translate('ja')),
              onPressed: () {
                BlocProvider.of<BudgetBloc>(context).add(
                  DeleteBudget(widget.budget, widget.serieMode, context),
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
      },
    );
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
        title: Text(AppLocalizations.of(context).translate('budget_bearbeiten')),
        actions: [
          IconButton(
            onPressed: () => _deleteBudget(context),
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => sl<BudgetBloc>(),
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
                              text: AppLocalizations.of(context).translate('speichern'),
                              saveBtnController: _editBudgetBtnController,
                              onPressed: () => _editBudget(context)),
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
