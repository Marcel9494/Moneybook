import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_localizations.dart';
import '../bloc/goal_bloc.dart';
import '../widgets/buttons/add_goal_button.dart';
import '../widgets/cards/goal_card.dart';

class GoalOverviewPage extends StatefulWidget {
  const GoalOverviewPage({super.key});

  @override
  State<GoalOverviewPage> createState() => _GoalOverviewPageState();
}

class _GoalOverviewPageState extends State<GoalOverviewPage> {
  @override
  void initState() {
    super.initState();
    // Lade Ziele beim ersten Öffnen des Screens
    context.read<GoalBloc>().add(LoadAllGoals());
  }

  void _loadGoals(BuildContext context) {
    BlocProvider.of<GoalBloc>(context).add(LoadAllGoals());
  }

  @override
  Widget build(BuildContext context) {
    _loadGoals(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('ziele'),
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<GoalBloc, GoalState>(
            builder: (context, state) {
              print(state);
              if (state is GoalLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AllGoalsLoadedSuccessful) {
                if (state.goals.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.goals.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < state.goals.length) {
                          return GoalCard(goal: state.goals[index]);
                        } else {
                          return AddGoalButton();
                        }
                      },
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Center(
                        child: Text(
                          AppLocalizations.of(context).translate('noch_keine_ziele_vorhanden'),
                        ),
                      ),
                      AddGoalButton(),
                    ],
                  );
                }
              } else if (state is Error) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context).translate('fehler_beim_laden_der_ziele'),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
