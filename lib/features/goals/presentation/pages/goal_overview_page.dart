import 'package:flutter/material.dart';

import '../../../../core/utils/app_localizations.dart';
import '../widgets/cards/goal_card.dart';

class GoalOverviewPage extends StatefulWidget {
  const GoalOverviewPage({super.key});

  @override
  State<GoalOverviewPage> createState() => _GoalOverviewPageState();
}

class _GoalOverviewPageState extends State<GoalOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("ziele"),
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return GoalCard(
            title: AppLocalizations.of(context).translate("wie_lange_von_kapital_leben"),
            description: AppLocalizations.of(context).translate("wie_lange_von_kapital_leben_beschreibung"),
          );
        },
      ),
    );
  }
}
