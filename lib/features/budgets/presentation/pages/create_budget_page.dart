import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/input_fields/categorie_input_field.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../injection_container.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../bookings/domain/value_objects/amount.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../../categories/domain/entities/categorie.dart';
import '../../../categories/domain/value_objects/categorie_type.dart';
import '../../../categories/presentation/bloc/categorie_bloc.dart' as categorie;
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

  void _createBudget(BuildContext context) {
    final FormState form = _budgetFormKey.currentState!;
    if (form.validate() == false) {
      _createBudgetBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _createBudgetBtnController.reset();
      });
    } else {
      _createBudgetBtnController.success();
      // TODO hier weitermachen und ausgewählte Categorie Daten über Categoriename laden und in Budget mitgeben
      // TODO für passende categorieId => load(categorieName) Funktion implementieren anschließend 1 in
      // TODO budget_local_data_source auf dynamisch ändern
      BlocProvider.of<categorie.CategorieBloc>(context).add(categorie.GetCategorieId(_categorieController.text, CategorieType.expense));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget erstellen'),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<BudgetBloc>(),
          ),
          BlocProvider(
            create: (context) => sl<categorie.CategorieBloc>(),
          ),
        ],
        child: BlocConsumer<categorie.CategorieBloc, categorie.CategorieState>(
          listener: (context, state) {
            if (state is categorie.ReceivedCategorie) {
              var dateFormatter = dateFormatterYYYYMMDD;
              // Format the current date and time to match the expected format
              var formattedDate = dateFormatter.format(DateTime.now());
              // Parse the formatted date string
              var parsedDate = dateFormatter.parse(formattedDate);
              Budget newBudget = Budget(
                id: 0,
                categorieId: state.categorie.id,
                date: dateFormatter.parse(formattedDate),
                amount: Amount.getValue(_amountController.text),
                used: 0.0,
                remaining: Amount.getValue(_amountController.text),
                percentage: 0.0,
                currency: Amount.getCurrency(_amountController.text),
                categorie: Categorie(id: state.categorie.id, name: _categorieController.text, type: CategorieType.expense),
              );
              Timer(const Duration(milliseconds: durationInMs), () {
                BlocProvider.of<BudgetBloc>(context).add(CreateBudget(newBudget));
              });
            }
          },
          builder: (context, state) {
            return BlocConsumer<BudgetBloc, BudgetState>(
              listener: (BuildContext context, BudgetState state) {
                if (state is Finished) {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(3));
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
                              CategorieInputField(categorieController: _categorieController, bookingType: BookingType.expense),
                              AmountTextField(amountController: _amountController, hintText: 'Budget...'),
                              SaveButton(text: 'Erstellen', saveBtnController: _createBudgetBtnController, onPressed: () => _createBudget(context)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            );
          },
        ),
      ),
    );
  }
}
