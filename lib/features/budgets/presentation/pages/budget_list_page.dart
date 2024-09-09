import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/budgets/presentation/widgets/cards/budget_card.dart';
import 'package:moneybook/features/budgets/presentation/widgets/charts/budget_overview_chart.dart';

import '../../../../shared/presentation/widgets/deco/empty_list.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart' as booking;
import '../../domain/entities/budget.dart';
import '../bloc/budget_bloc.dart' as budget;
import '../widgets/deco/create_budget_row.dart';

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
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Wird jedesmal aufgerufen, wenn der Benutzer den Monat wechselt
  @override
  void didUpdateWidget(BudgetListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _loadData();
    }
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
  }

  void _calculateBudgetValues(List<Booking> bookings, List<Budget> budgets) {
    for (int i = 0; i < budgets.length; i++) {
      budgets[i].used = 0.0;
      budgets[i].remaining = 0.0;
      budgets[i].percentage = 0.0;
    }
    for (int i = 0; i < bookings.length; i++) {
      for (int j = 0; j < budgets.length; j++) {
        if (bookings[i].categorie == budgets[j].categorie) {
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
        if (bookingState is booking.Loaded) {
          return BlocBuilder<budget.BudgetBloc, budget.BudgetState>(
            builder: (context, budgetState) {
              if (budgetState is budget.Loaded) {
                if (budgetState.budgets.isEmpty) {
                  return Column(
                    children: [
                      BudgetOverviewChart(
                        budgets: budgetState.budgets,
                        bookings: bookingState.bookings,
                      ),
                      const CreateBudgetRow(),
                      const Expanded(
                        child: EmptyList(
                          text: 'Noch keine Budgets vorhanden',
                          icon: Icons.savings_rounded,
                        ),
                      ),
                    ],
                  );
                } else {
                  _calculateBudgetValues(bookingState.bookings, budgetState.budgets);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BudgetOverviewChart(
                        budgets: budgetState.budgets,
                        bookings: bookingState.bookings,
                      ),
                      const CreateBudgetRow(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: budgetState.budgets.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BudgetCard(
                              budget: budgetState.budgets[index],
                              selectedDate: widget.selectedDate,
                            );
                          },
                        ),
                      )
                    ],
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
