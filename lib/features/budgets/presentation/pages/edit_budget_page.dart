import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/bookings/presentation/widgets/input_fields/categorie_input_field.dart';
import 'package:moneybook/shared/domain/value_objects/edit_mode_type.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/route_consts.dart';
import '../../../../injection_container.dart';
import '../../../../shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../domain/entities/budget.dart';
import '../bloc/budget_bloc.dart';

class EditBudgetPage extends StatefulWidget {
  final Budget budget;
  final EditModeType editMode;

  const EditBudgetPage({
    super.key,
    required this.budget,
    required this.editMode,
  });

  @override
  State<EditBudgetPage> createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  final GlobalKey<FormState> _budgetFormKey = GlobalKey<FormState>();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final RoundedLoadingButtonController _editBudgetBtnController = RoundedLoadingButtonController();

  void _editBudget(BuildContext context) {
    // TODO
  }

  void _deleteBudget(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Budget löschen?'),
          content: const Text('Wollen Sie das Budget wirklich löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Ja'),
              onPressed: () {
                // TODO hier weitermachen und Budget löschen implementieren editieren gleich mit vorbereiten
                /*BlocProvider.of<BudgetBloc>(context).add(
                  DeleteBudget(widget.budget.id, context),
                );*/
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget bearbeiten'),
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
                          SaveButton(text: 'Speichern', saveBtnController: _editBudgetBtnController, onPressed: () => _editBudget(context)),
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
