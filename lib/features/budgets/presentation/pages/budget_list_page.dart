import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/budgets/presentation/widgets/cards/budget_card.dart';
import 'package:moneybook/features/budgets/presentation/widgets/charts/budget_overview_chart.dart';

import '../../../../shared/presentation/widgets/deco/empty_list.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart' as booking;
import '../../../categories/domain/entities/categorie.dart';
import '../../../categories/presentation/bloc/categorie_bloc.dart' as categorie;
import '../../../categories/presentation/bloc/categorie_bloc.dart';
import '../../domain/entities/budget.dart';
import '../bloc/budget_bloc.dart' as budget;

class BudgetListPage extends StatefulWidget {
  final DateTime selectedDate;

  const BudgetListPage({
    super.key,
    required this.selectedDate,
  });

  @override
  State<BudgetListPage> createState() => _BudgetListPageState();
}

class _BudgetListPageState extends State<BudgetListPage> {
  bool _categoriesLoaded = false;
  bool _budgetsLoaded = false;

  void _loadMonthlyBookings(BuildContext context) {
    BlocProvider.of<booking.BookingBloc>(context).add(
      booking.LoadSortedMonthlyBookings(widget.selectedDate),
    );
  }

  void _loadBudgets(BuildContext context) {
    BlocProvider.of<budget.BudgetBloc>(context).add(
      budget.LoadMonthlyBudgets(widget.selectedDate),
    );
  }

  void _loadCategories(BuildContext context, List<Budget> budgets) {
    List<int> categorieIds = [];
    for (int i = 0; i < budgets.length; i++) {
      categorieIds.add(budgets[i].categorieId);
    }
    BlocProvider.of<categorie.CategorieBloc>(context).add(
      categorie.LoadCategoriesWithIds(categorieIds),
    );
  }

  void _calculateBudgetValues(List<Booking> bookings, List<Budget> budgets, List<Categorie> categories) {
    for (int i = 0; i < budgets.length; i++) {
      budgets[i].used = 0.0;
      budgets[i].remaining = 0.0;
      budgets[i].percentage = 0.0;
    }
    for (int i = 0; i < bookings.length; i++) {
      for (int j = 0; j < budgets.length; j++) {
        if (bookings[i].categorie == categories[j].name) {
          budgets[j].used += bookings[i].amount;
          break;
        }
      }
    }
    for (int i = 0; i < budgets.length; i++) {
      budgets[i].remaining = budgets[i].amount - budgets[i].used;
      budgets[i].percentage = (budgets[i].used / budgets[i].amount) * 100;
    }
    budgets.sort((first, second) => second.percentage.compareTo(first.percentage));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<booking.BookingBloc, booking.BookingState>(
      builder: (context, bookingState) {
        _loadMonthlyBookings(context);
        if (bookingState is booking.Loaded) {
          return BlocBuilder<budget.BudgetBloc, budget.BudgetState>(
            builder: (context, budgetState) {
              if (!_budgetsLoaded && budgetState is! budget.Loaded) {
                _loadBudgets(context);
                _budgetsLoaded = true;
              }
              if (budgetState is budget.Loaded) {
                if (budgetState.budgets.isEmpty) {
                  return Column(
                    children: [
                      BudgetOverviewChart(budgets: budgetState.budgets),
                      const Expanded(
                        child: EmptyList(
                          text: 'Noch keine Budgets vorhanden',
                          icon: Icons.savings_rounded,
                        ),
                      ),
                    ],
                  );
                } else {
                  return BlocBuilder<CategorieBloc, CategorieState>(
                    builder: (context, categorieState) {
                      if (!_categoriesLoaded && categorieState is! categorie.ReceivedCategories) {
                        _loadCategories(context, budgetState.budgets);
                        _categoriesLoaded = true;
                      }
                      if (categorieState is categorie.ReceivedCategories) {
                        _calculateBudgetValues(bookingState.bookings, budgetState.budgets, categorieState.categories);
                        return Column(
                          children: [
                            BudgetOverviewChart(budgets: budgetState.budgets),
                            Expanded(
                              child: ListView.builder(
                                itemCount: budgetState.budgets.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return BudgetCard(
                                    budget: budgetState.budgets[index],
                                    categorie: categorieState.categories[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  );
                }
              }
              return const SizedBox();
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
