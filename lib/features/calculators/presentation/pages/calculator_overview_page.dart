import 'package:flutter/material.dart';
import 'package:moneybook/features/calculators/presentation/widgets/cards/calculator_card.dart';

import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../domain/entities/calculator.dart';

class CalculatorOverviewPage extends StatefulWidget {
  const CalculatorOverviewPage({super.key});

  @override
  State<CalculatorOverviewPage> createState() => _CalculatorOverviewPageState();
}

class _CalculatorOverviewPageState extends State<CalculatorOverviewPage> {
  final List<Calculator> _calculators = [];
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized == false) {
      initCalculators();
      _isInitialized = true;
    }
  }

  void initCalculators() {
    _calculators.add(
      Calculator(
        title: AppLocalizations.of(context).translate("wie_lange_von_kapital_leben"),
        description: AppLocalizations.of(context).translate("wie_lange_von_kapital_leben_beschreibung"),
        route: howLongLiveOfCapitalCalculatorRoute,
      ),
    );
    _calculators.add(
      Calculator(
        title: AppLocalizations.of(context).translate("finanzielle_freiheit_rechner"),
        description: AppLocalizations.of(context).translate("finanzielle_freiheit_rechner_beschreibung"),
        route: financialFreedomCalculatorRoute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate("rechnerübersicht"),
        ),
      ),
      body: ListView.builder(
        itemCount: _calculators.length,
        itemBuilder: (BuildContext context, int index) {
          return CalculatorCard(
            title: _calculators[index].title,
            description: _calculators[index].description,
            route: _calculators[index].route,
          );
        },
      ),
    );
  }
}
