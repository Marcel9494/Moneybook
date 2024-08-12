import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/budgets/presentation/widgets/cards/budget_card.dart';
import 'package:moneybook/features/budgets/presentation/widgets/charts/budget_overview_chart.dart';

import '../../../../shared/presentation/widgets/deco/empty_list.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart' as booking;
import '../../../categories/domain/entities/categorie.dart';
import '../../../categories/domain/value_objects/categorie_type.dart';
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

  @override
  void initState() {
    super.initState();
    _resetLoadingStates();
    _loadData();
  }

  @override
  void didUpdateWidget(BudgetListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _resetLoadingStates();
      _loadData();
    }
  }

  void _resetLoadingStates() {
    _categoriesLoaded = false;
    _budgetsLoaded = false;
  }

  void _loadData() {
    _loadMonthlyBookings(context);
    _loadBudgets(context);
  }

  void _loadMonthlyBookings(BuildContext context) {
    BlocProvider.of<booking.BookingBloc>(context).add(
      booking.LoadSortedMonthlyBookings(widget.selectedDate),
    );
  }

  void _loadBudgets(BuildContext context) {
    BlocProvider.of<budget.BudgetBloc>(context).add(
      budget.LoadMonthlyBudgets(widget.selectedDate),
    );
    _budgetsLoaded = true;
  }

  void _loadCategories(BuildContext context, List<Budget> budgets) {
    List<int> categorieIds = budgets.map((budget) => budget.categorieId).toList();
    BlocProvider.of<categorie.CategorieBloc>(context).add(
      categorie.LoadCategoriesWithIds(categorieIds),
    );
    _categoriesLoaded = true;
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
    // TODO budgets.sort((first, second) => second.percentage.compareTo(first.percentage));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<budget.BudgetBloc, budget.BudgetState>(
      listener: (context, budgetState) {
        if (budgetState is budget.Loaded && !_categoriesLoaded) {
          _loadCategories(context, budgetState.budgets);
        }
      },
      child: BlocBuilder<booking.BookingBloc, booking.BookingState>(
        builder: (context, bookingState) {
          if (bookingState is booking.Loaded) {
            return BlocBuilder<budget.BudgetBloc, budget.BudgetState>(
              builder: (context, budgetState) {
                if (!_budgetsLoaded && budgetState is! budget.Loaded) {
                  _loadBudgets(context);
                }
                if (budgetState is budget.Loaded) {
                  // TODO hier weitermachen, wenn von leeren Budget Liste auf volle Budget Liste gewechselt wird tritt
                  // TODO noch ein Fehler auf Bsp.: Juli 24 auf August 24 wechseln
                  _loadCategories(context, budgetState.budgets);
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
                        if (categorieState is categorie.ReceivedCategories) {
                          _calculateBudgetValues(bookingState.bookings, budgetState.budgets, categorieState.categories);
                          return Column(
                            children: [
                              BudgetOverviewChart(budgets: budgetState.budgets),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: budgetState.budgets.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    Budget budget = budgetState.budgets[index];
                                    Categorie? category = categorieState.categories.firstWhere(
                                      (cat) => cat.id == budget.categorieId,
                                      orElse: () => const Categorie(name: 'Kategorie nicht vorhanden', id: -1, type: CategorieType.expense),
                                    );
                                    return BudgetCard(
                                      budget: budgetState.budgets[index],
                                      categorie: category,
                                    );
                                  },
                                ),
                              )
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
      ),
    );
  }
}
