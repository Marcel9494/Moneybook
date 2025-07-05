import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../../shared/presentation/widgets/switches/icon_switch.dart';
import '../../../statistics/presentation/widgets/deco/calculator_item_text.dart';

class FinancialFreedomCalculatorPage extends StatefulWidget {
  const FinancialFreedomCalculatorPage({super.key});

  @override
  State<FinancialFreedomCalculatorPage> createState() => _FinancialFreedomCalculatorPageState();
}

class _FinancialFreedomCalculatorPageState extends State<FinancialFreedomCalculatorPage> {
  final GlobalKey<FormState> _financialFreedomFormKey = GlobalKey<FormState>();
  final TextEditingController _currentAgeController = TextEditingController();
  final TextEditingController _targetAgeController = TextEditingController();
  final TextEditingController _lifeExpectancyController = TextEditingController();
  final TextEditingController _investmentAssetsController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _otherAssetsController = TextEditingController();
  final TextEditingController _averageMonthlyExpensesController = TextEditingController();
  final TextEditingController _averageMonthlyPassiveIncomeController = TextEditingController();
  final TextEditingController _withdrawalRateController = TextEditingController();
  final TextEditingController _inflationController = TextEditingController();
  final TextEditingController _taxRateController = TextEditingController();
  final RoundedLoadingButtonController _financialFreedomBtnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _personalValuesBtnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _addAsGoalBtnController = RoundedLoadingButtonController();
  double _averageMonthlyExpenses = 0.0;
  double _averageMonthlyPassiveIncome = 0.0;
  double _investmentAssets = 0.0;
  double _otherAssets = 0.0;
  double _debtAssets = 0.0;
  double _interestRate = 5.0;
  double _selectedTaxRate = 0.0;
  final Map<String, double> _taxRates = {
    '26,375% (25% + Solidaritätszuschlag)': 26.375,
    '27,819% (mit 8% Kirchensteuer)': 27.819,
    '28,625% (mit 9% Kirchensteuer)': 28.625,
    '27,5% (KESt Österreich)': 27.5,
    '0,0% (Steuerbefreit)': 0.0,
  };
  bool _useUpCapital = false;
  bool _withInflation = false;

  @override
  void initState() {
    super.initState();
    _selectedTaxRate = _taxRates.values.first;
    _currentAgeController.text = '30';
    _targetAgeController.text = '55';
    _interestRateController.text = '5,0%';
    _lifeExpectancyController.text = '90';
    _withdrawalRateController.text = '4,0%';
    _inflationController.text = '2,0%';
    _taxRateController.text = '26,375% (25% + Solidaritätszuschlag)';
    _calculateFinancialFreedomWithPersonalValues(context, true);
  }

  void _changeInvestmentAssets(double newInvestmentAssets) {
    setState(() {
      _investmentAssets = newInvestmentAssets;
    });
    Navigator.pop(context);
  }

  void _changeInterestRate(double newInterestRate) {
    setState(() {
      // TODO hier weitermachen und UI optimieren und Fehler abfangen Aktuelles Alter muss kleiner als Ziel Alter sein etc.
      _interestRate = newInterestRate;
      final locale = Localizations.localeOf(context).toString();
      final numberFormat = NumberFormat.decimalPattern(locale)
        ..minimumFractionDigits = 1
        ..maximumFractionDigits = 1;
      final parsed = double.tryParse(_interestRateController.text.replaceAll(',', '.'));
      _interestRateController.text = '${numberFormat.format(parsed)}%';
    });
    Navigator.pop(context);
  }

  void _changeOtherAssets(double newOtherAssets) {
    setState(() {
      _otherAssets = newOtherAssets;
    });
    Navigator.pop(context);
  }

  void _changeAverageMonthlyExpenses(double newAverageMonthlyExpenses) {
    setState(() {
      _averageMonthlyExpenses = newAverageMonthlyExpenses;
    });
    Navigator.pop(context);
  }

  void _changeAverageMonthlyPassiveIncome(double newAverageMonthlyPassiveIncome) {
    setState(() {
      _averageMonthlyPassiveIncome = newAverageMonthlyPassiveIncome;
    });
    Navigator.pop(context);
  }

  void _changeInflation(double newInflation) {
    setState(() {
      _inflationController.text = newInflation.toStringAsFixed(1);
    });
    Navigator.pop(context);
  }

  void _changeTaxRate(double newTaxRate) {
    setState(() {
      _selectedTaxRate = newTaxRate;
      _taxRateController.text = '${newTaxRate.toString()}%';
    });
  }

  bool _checkFormFields() {
    // TODO hier weitermachen und SnackBar UI optimieren
    if (int.parse(_currentAgeController.text) >= int.parse(_targetAgeController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('aktuelles_alter_fehler')),
        ),
      );
      return false;
    } else if (_useUpCapital == true && int.parse(_currentAgeController.text) >= int.parse(_lifeExpectancyController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('lebenserwartung_fehler')),
        ),
      );
      return false;
    } else if (_useUpCapital == true && int.parse(_targetAgeController.text) >= int.parse(_lifeExpectancyController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('ziel_alter_fehler')),
        ),
      );
      return false;
    } else if (_useUpCapital == true && int.parse(_lifeExpectancyController.text) < int.parse(_currentAgeController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('lebenserwartung_zu_niedrig_fehler1')),
        ),
      );
      return false;
    } else if (_useUpCapital == true && int.parse(_lifeExpectancyController.text) < int.parse(_targetAgeController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('lebenserwartung_zu_niedrig_fehler2')),
        ),
      );
      return false;
    }
    return true;
  }

  void _calculateFinancialFreedom() {
    final FormState form = _financialFreedomFormKey.currentState!;
    if (form.validate() == false || _checkFormFields() == false) {
      _financialFreedomBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _financialFreedomBtnController.reset();
      });
    } else {
      // TODO
      _financialFreedomBtnController.success();
      Timer(const Duration(milliseconds: durationInMs), () {
        _financialFreedomBtnController.reset();
      });
    }
  }

  void _calculateFinancialFreedomWithPersonalValues(BuildContext context, bool isFirstCalculation) {
    // TODO
  }

  void _addAsGoal() {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('finanzielle_freiheit_rechner'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              Card(
                child: Form(
                  key: _financialFreedomFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('durchschnittliche_monatliche_ausgaben'),
                        description: AppLocalizations.of(context).translate('durchschnittliche_monatliche_ausgaben_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _averageMonthlyExpensesController,
                        prefixIcon: Icon(HugeIcons.strokeRoundedInvoice02),
                        hintText: AppLocalizations.of(context).translate('durchschnittliche_monatliche_ausgaben') + '...',
                        onAmountTypeChanged: (otherAssets) => _changeAverageMonthlyExpenses(otherAssets),
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('geplantes_renteneintrittsalter'),
                        description: AppLocalizations.of(context).translate('geplantes_renteneintrittsalter_beschreibung'),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                CalculatorItemText(
                                  title: AppLocalizations.of(context).translate('aktuelles_alter'),
                                  description: AppLocalizations.of(context).translate('aktuelles_alter_beschreibung'),
                                  fontWeight: FontWeight.normal,
                                  showInfoIcon: false,
                                  fontSize: 14.0,
                                ),
                                AmountTextField(
                                  amountController: _currentAgeController,
                                  prefixIcon: Icon(HugeIcons.strokeRoundedCalendarUser),
                                  hintText: AppLocalizations.of(context).translate('aktuelles_alter') + '...',
                                  onAmountTypeChanged: (otherAssets) => {},
                                  showSeparator: false,
                                  isAgeValue: true,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 32.0),
                          Flexible(
                            child: Column(
                              children: [
                                CalculatorItemText(
                                  title: AppLocalizations.of(context).translate('ziel_alter'),
                                  description: AppLocalizations.of(context).translate('ziel_alter_beschreibung'),
                                  fontWeight: FontWeight.normal,
                                  showInfoIcon: false,
                                  fontSize: 14.0,
                                ),
                                AmountTextField(
                                  amountController: _targetAgeController,
                                  prefixIcon: Icon(HugeIcons.strokeRoundedTarget02),
                                  hintText: AppLocalizations.of(context).translate('ziel_alter') + '...',
                                  onAmountTypeChanged: (otherAssets) => {},
                                  showSeparator: false,
                                  isAgeValue: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('kapitalanlage_vermögen'),
                        description: AppLocalizations.of(context).translate('kapitalanlage_vermögen_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _investmentAssetsController,
                        hintText: AppLocalizations.of(context).translate('kapitalanlage_vermögen') + '...',
                        onAmountTypeChanged: (investmentAssets) => _changeInvestmentAssets(investmentAssets),
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('zinssatz'),
                        description: AppLocalizations.of(context).translate('zinssatz_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _interestRateController,
                        prefixIcon: Icon(HugeIcons.strokeRoundedPercentSquare),
                        hintText: AppLocalizations.of(context).translate('zinssatz') + '...',
                        onAmountTypeChanged: (interestRate) => _changeInterestRate(interestRate),
                        isPercentValue: true,
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('weiteres_vermögen'),
                        description: AppLocalizations.of(context).translate('weiteres_vermögen_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _otherAssetsController,
                        hintText: AppLocalizations.of(context).translate('weiteres_vermögen') + '...',
                        onAmountTypeChanged: (otherAssets) => _changeOtherAssets(otherAssets),
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('durchschnittliche_passive_einnahmen'),
                        description: AppLocalizations.of(context).translate('durchschnittliche_passive_einnahmen_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _averageMonthlyPassiveIncomeController,
                        prefixIcon: Icon(HugeIcons.strokeRoundedProfit),
                        hintText: AppLocalizations.of(context).translate('durchschnittliche_passive_einnahmen') + '...',
                        onAmountTypeChanged: (otherAssets) => _changeAverageMonthlyPassiveIncome(otherAssets),
                      ),
                      IconSwitch(
                        text: AppLocalizations.of(context).translate('kapital_aufbrauchen'),
                        value: _useUpCapital,
                        onChanged: (newUseUpCapitalValue) {
                          setState(() {
                            _useUpCapital = newUseUpCapitalValue;
                          });
                        },
                      ),
                      _useUpCapital
                          ? Column(
                              children: [
                                CalculatorItemText(
                                  title: AppLocalizations.of(context).translate('lebenserwartung') +
                                      ' (' +
                                      AppLocalizations.of(context).translate('in_jahren') +
                                      ')',
                                  description: AppLocalizations.of(context).translate('lebenserwartung_beschreibung'),
                                ),
                                AmountTextField(
                                  amountController: _lifeExpectancyController,
                                  prefixIcon: Icon(HugeIcons.strokeRoundedCalendarUser),
                                  hintText: AppLocalizations.of(context).translate('lebenserwartung') + '...',
                                  onAmountTypeChanged: (otherAssets) => {},
                                  showSeparator: false,
                                  isAgeValue: true,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                CalculatorItemText(
                                  title: AppLocalizations.of(context).translate('entnahmerate'),
                                  description: AppLocalizations.of(context).translate('entnahmerate_beschreibung'),
                                ),
                                AmountTextField(
                                  amountController: _withdrawalRateController,
                                  prefixIcon: Icon(HugeIcons.strokeRoundedPercentSquare),
                                  hintText: AppLocalizations.of(context).translate('entnahmerate') + '...',
                                  onAmountTypeChanged: (otherAssets) => _changeAverageMonthlyPassiveIncome(otherAssets),
                                  isPercentValue: true,
                                ),
                              ],
                            ),
                      IconSwitch(
                        text: AppLocalizations.of(context).translate('inflation_berücksichtigen'),
                        value: _withInflation,
                        onChanged: (newWithInflationValue) {
                          setState(() {
                            _withInflation = newWithInflationValue;
                          });
                        },
                      ),
                      _withInflation
                          ? AmountTextField(
                              amountController: _inflationController,
                              prefixIcon: Icon(HugeIcons.strokeRoundedProfit),
                              hintText: AppLocalizations.of(context).translate('inflation_berücksichtigen') + '...',
                              onAmountTypeChanged: (inflation) => _changeInflation(inflation),
                              isPercentValue: true,
                            )
                          : const SizedBox.shrink(),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('steuersatz'),
                        description: AppLocalizations.of(context).translate('steuersatz_beschreibung'),
                      ),
                      DropdownButtonFormField<double>(
                        decoration: InputDecoration(
                          prefixIcon: Icon(HugeIcons.strokeRoundedPercentSquare),
                          border: UnderlineInputBorder(),
                        ),
                        value: _selectedTaxRate,
                        items: _taxRates.entries.map((entry) {
                          return DropdownMenuItem<double>(
                            value: entry.value,
                            child: SizedBox(
                              width: 360.0,
                              child: Text(entry.key, overflow: TextOverflow.ellipsis),
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return _taxRates.entries.map((entry) {
                            return SizedBox(
                              width: 250.0,
                              child: Text(entry.key, overflow: TextOverflow.ellipsis),
                            );
                          }).toList();
                        },
                        onChanged: (double? newTaxRate) {
                          if (newTaxRate != null) {
                            _changeTaxRate(newTaxRate);
                          }
                        },
                      ),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('berechnen'),
                        saveBtnController: _financialFreedomBtnController,
                        onPressed: () => _calculateFinancialFreedom(),
                      ),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('persönliche_werte_verwenden'),
                        saveBtnController: _personalValuesBtnController,
                        onPressed: () => _calculateFinancialFreedomWithPersonalValues(context, false),
                      ),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('als_ziel_hinzufügen'),
                        saveBtnController: _addAsGoalBtnController,
                        onPressed: () => _addAsGoal(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context).translate('ergebnis'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
