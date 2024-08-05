import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/budgets/presentation/widgets/cards/budget_card.dart';
import 'package:moneybook/features/budgets/presentation/widgets/charts/budget_overview_chart.dart';

import '../../../../shared/presentation/widgets/deco/empty_list.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/presentation/bloc/booking_bloc.dart' as booking;
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
  void _loadAndCalculateBudgets(BuildContext context, List<Booking> bookings) {
    BlocProvider.of<budget.BudgetBloc>(context).add(
      budget.LoadAndCalculateMonthlyBudgets(bookings, widget.selectedDate),
    );
  }

  void _loadMonthlyBookings(BuildContext context) {
    BlocProvider.of<booking.BookingBloc>(context).add(
      booking.LoadSortedMonthlyBookings(widget.selectedDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<booking.BookingBloc, booking.BookingState>(
      builder: (context, bookingState) {
        _loadMonthlyBookings(context);
        if (bookingState is booking.Loaded) {
          return BlocBuilder<budget.BudgetBloc, budget.BudgetState>(
            builder: (context, budgetState) {
              _loadAndCalculateBudgets(context, bookingState.bookings);
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
                  return Column(
                    children: [
                      BudgetOverviewChart(budgets: budgetState.budgets),
                      Expanded(
                        child: ListView.builder(
                          itemCount: budgetState.budgets.length,
                          itemBuilder: (BuildContext context, int index) {
                            return BudgetCard(budget: budgetState.budgets[index]);
                          },
                        ),
                      ),
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
