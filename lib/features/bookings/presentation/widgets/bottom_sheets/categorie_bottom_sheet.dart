import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/features/bookings/domain/value_objects/booking_type.dart';

import '../../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
import '../../../../categories/domain/entities/categorie.dart';
import '../../../../categories/presentation/bloc/categorie_bloc.dart';
import '../buttons/grid_view_button.dart';

void loadCategories(BuildContext context) {
  BlocProvider.of<CategorieBloc>(context).add(
    const LoadAllCategories(),
  );
}

openCategorieBottomSheet({
  required BuildContext context,
  required String title,
  required TextEditingController controller,
  required BookingType bookingType,
}) {
  loadCategories(context);
  showCupertinoModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return BlocBuilder<CategorieBloc, CategorieState>(
        builder: (context, state) {
          if (state is Loading) {
            return const RefreshProgressIndicator();
          } else if (state is Loaded) {
            List<Categorie> categories = [];
            if (bookingType.name == BookingType.expense.name) {
              categories = state.expenseCategories;
            } else if (bookingType.name == BookingType.income.name) {
              categories = state.incomeCategories;
            } else if (bookingType.name == BookingType.investment.name) {
              categories = state.investmentCategories;
            }
            return Material(
              child: Wrap(
                children: [
                  Column(
                    children: [
                      BottomSheetHeader(title: title),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(24.0),
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            childAspectRatio: 1.6,
                            children: categories.map((categorie) {
                              return GridViewButton(
                                onPressed: () => _setCategorie(context, categorie.name, controller),
                                text: categorie.name,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      );
    },
  );
}

void _setCategorie(BuildContext context, String text, TextEditingController controller) {
  controller.text = text;
  Navigator.pop(context);
}
