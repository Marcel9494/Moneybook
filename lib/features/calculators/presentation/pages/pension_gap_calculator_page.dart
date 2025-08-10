import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../statistics/presentation/widgets/deco/calculator_item_text.dart';

class PensionGapCalculatorPage extends StatefulWidget {
  const PensionGapCalculatorPage({super.key});

  @override
  State<PensionGapCalculatorPage> createState() => _PensionGapCalculatorPageState();
}

class _PensionGapCalculatorPageState extends State<PensionGapCalculatorPage> {
  final GlobalKey<FormState> _pensionGapFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _closePensionGapFormKey = GlobalKey<FormState>();
  // Rentenlücke berechnen
  final TextEditingController _statePensionInsuranceController = TextEditingController();
  final TextEditingController _companyPensionSchemeController = TextEditingController();
  final TextEditingController _annualBasicAllowanceController = TextEditingController();
  final TextEditingController _estimatedTaxDeductionController = TextEditingController();
  final TextEditingController _monthlyDesiredPensionController = TextEditingController();
  final RoundedLoadingButtonController _pensionGapBtnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _closePensionGapBtnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _calculateClosePensionGapBtnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _addClosePensionGapGoalBtnController = RoundedLoadingButtonController();
  double _statePensionInsurance = 950.0; // 1200.0;
  double _companyPensionScheme = 100.0;
  double _estimatedTaxDeduction = 15.0;
  double _annualBasicAllowance = 12096.0;
  double _monthlyDesiredPension = 2200.0;
  double _grossMonthlyPension = 0.0;
  double _netMonthlyPension = 0.0;
  double _pensionGap = 0.0;

  // Zielvermögen um Rentenlücke zu schließen berechnen
  final TextEditingController _returnOnInvestmentAtRetirementController = TextEditingController();
  final TextEditingController _inflationRateController = TextEditingController();
  final TextEditingController _retirementAgeController = TextEditingController();
  final TextEditingController _lifeExpectancyController = TextEditingController();
  double _returnOnInvestmentAtRetirement = 3.0;
  bool _takeInflationIntoAccount = true;
  double _inflationRate = 2.0;
  int _retirementAge = 67;
  int _lifeExpectancy = 100;

  final TextEditingController _currentAgeController = TextEditingController();
  final TextEditingController _currentCapitalController = TextEditingController();
  final TextEditingController _returnOnInvestmentController = TextEditingController();
  final TextEditingController _taxRateController = TextEditingController();
  int _currentAge = 30;
  double _currentCapital = 0.0;
  double _returnOnInvestment = 5.0;
  double _taxRate = 26.375;
  double _targetCapital = 0.0;
  double _requiredMonthlySavings = 0.0;
  double _requiredCapitalAtRetirement = 0.0;

  @override
  void initState() {
    super.initState();
    // Rentenlücke berechnen
    _statePensionInsuranceController.text = formatToMoneyAmount(_statePensionInsurance.toString());
    _companyPensionSchemeController.text = formatToMoneyAmount(_companyPensionScheme.toString());
    _annualBasicAllowanceController.text = formatToMoneyAmount(_annualBasicAllowance.toString());
    _estimatedTaxDeductionController.text = _estimatedTaxDeduction.toString() + '%';
    _monthlyDesiredPensionController.text = formatToMoneyAmount(_monthlyDesiredPension.toString());

    // Zielvermögen um Rentenlücke zu schließen berechnen
    _returnOnInvestmentAtRetirementController.text = _returnOnInvestmentAtRetirement.toString() + '%';
    _inflationRateController.text = _inflationRate.toString() + '%';
    _retirementAgeController.text = _retirementAge.toString();
    _lifeExpectancyController.text = _lifeExpectancy.toString();
    _currentAgeController.text = _currentAge.toString();
    _currentCapitalController.text = formatToMoneyAmount(_currentCapital.toString());
    _returnOnInvestmentController.text = _returnOnInvestment.toString() + '%';
    _taxRateController.text = _taxRate.toString() + '%';
  }

  void _calculatePensionGap() {
    final FormState form = _pensionGapFormKey.currentState!;
    if (form.validate() == false) {
      _pensionGapBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _pensionGapBtnController.reset();
      });
    } else {
      _statePensionInsurance = formatMoneyAmountToDouble(_statePensionInsuranceController.text);
      _companyPensionScheme = formatMoneyAmountToDouble(_companyPensionSchemeController.text);
      _annualBasicAllowance = formatMoneyAmountToDouble(_annualBasicAllowanceController.text);
      _estimatedTaxDeduction = formatMoneyAmountToDouble(_estimatedTaxDeductionController.text);
      _monthlyDesiredPension = formatMoneyAmountToDouble(_monthlyDesiredPensionController.text);

      _grossMonthlyPension = _statePensionInsurance + _companyPensionScheme;
      double grossAnnualPension = _grossMonthlyPension * 12.0;

      double taxableIncome = grossAnnualPension - _annualBasicAllowance;
      if (taxableIncome < 0) taxableIncome = 0;

      double taxAmount = taxableIncome * (_estimatedTaxDeduction / 100.0);
      double netAnnualPension = grossAnnualPension - taxAmount;

      _netMonthlyPension = netAnnualPension / 12.0;

      setState(() {
        _pensionGap = _monthlyDesiredPension - _netMonthlyPension;
      });
      _pensionGapBtnController.success();
      Timer(const Duration(milliseconds: durationInMs), () {
        _pensionGapBtnController.reset();
      });
    }
  }

  void _calculateClosePensionGap() {
    _calculateTargetCapital2();
    //_calculateMonthlySavings();
  }

  void _calculateTargetCapital2() {
    final int yearsToRetirement = _retirementAge - _currentAge;
    final int retirementYears = _lifeExpectancy - _retirementAge;
    print(yearsToRetirement);
    print(retirementYears);

    print(_pensionGap);
    // 1) Lücke bis zur Rente inflationsbereinigt (nominal bei Rentenbeginn)
    //final double monthlyGapAtRetirement = _netMonthlyPension * pow(1 + _inflationRate / 100, yearsToRetirement);
    //print(monthlyGapAtRetirement);

    // 2) Bruttobetrag (Steuern vereinfacht als Abzug auf Auszahlung)
    final double grossMonthlyPaymentAtRetirement = _pensionGap / (1 - _taxRate / 100);
    print(grossMonthlyPaymentAtRetirement);

    // 3) Monatszinssatz während der Rente (aus nominaler Jahresrendite)
    final double rRetMonth = pow(1 + _returnOnInvestmentAtRetirement / 100, 1 / 12) - 1;
    final int nRetMonths = retirementYears * 12;
    print(nRetMonths);

    // Barwert einer sofort beginnenden Annuität (monatliche Auszahlung am Ende jedes Monats)
    // PV = PMT * (1 - (1 + r)^-n) / r
    final double pvFactor = (1 - pow(1 + rRetMonth, -nRetMonths)) / rRetMonth;
    print(pvFactor);

    _requiredCapitalAtRetirement = grossMonthlyPaymentAtRetirement * pvFactor - _currentCapital;
    print('Benötigtes Kapital bei Renteneintritt: $_requiredCapitalAtRetirement');

    print(_returnOnInvestment);

    int jahre = _retirementAge - _currentAge;
    int monate = jahre * 12;
    double realeRendite = (1 + _returnOnInvestment / 100) / (1 + _inflationRate / 100) - 1;

    double r = realeRendite / 12; // Monatszins
    double faktor = pow(1 + r, monate) - 1;
    setState(() {
      _requiredMonthlySavings = (_requiredCapitalAtRetirement * r) / faktor;
    });
    // 4) Berechne benötigte monatliche Sparrate bis zur Rente
    /*final double rSaveMonth = pow(1 + _returnOnInvestment / 100, 1 / 12) - 1;
    final int nSaveMonths = yearsToRetirement * 12;
    print(rSaveMonth);
    print(nSaveMonths);

    // FV eines monatlichen Sparplans: FV = s * ( (1+r)^N - 1 ) / r
    final double fvFactor = (pow(1 + double.parse(rSaveMonth.toStringAsFixed(6)), nSaveMonths) - 1) / double.parse(rSaveMonth.toStringAsFixed(6));
    print(fvFactor);

    setState(() {
      _requiredMonthlySavings = _requiredCapitalAtRetirement <= 0.0 ? 0.0 : _requiredCapitalAtRetirement / fvFactor;
      print('Benötigte monatliche Sparrate: $_requiredMonthlySavings');
    });*/
  }

  // TODO hier weitermachen und Berechnung verbessern
  void _calculateTargetCapital() {
    _lifeExpectancy = int.parse(_lifeExpectancyController.text);
    _retirementAge = int.parse(_retirementAgeController.text);
    _returnOnInvestmentAtRetirement = formatMoneyAmountToDouble(_returnOnInvestmentAtRetirementController.text);
    _taxRate = formatMoneyAmountToDouble(_taxRateController.text);
    final yearsUntilRetirement = _retirementAge - _currentAge;
    final retirementYears = _lifeExpectancy - _retirementAge;
    final months = retirementYears * 12;
    print(months);
    final futureMonthlyGap = _pensionGap * pow(1 + _inflationRate / 100.0, yearsUntilRetirement);

    final grossReturn = _returnOnInvestmentAtRetirement / 100.0;
    final netReturn = grossReturn * (1 - _taxRate / 100.0);
    print(netReturn);
    final monthlyRate = netReturn / 12.0;
    print(monthlyRate);

    /*double base = pow(1 + monthlyRate, -months).toDouble();
    print(base);
    double annuityFactor = (1 - base) / monthlyRate;
    print(annuityFactor);
    double factor = annuityFactor * (1 + monthlyRate);
    print(factor);
    final months = (_lifeExpectancy - _retirementAge) * 12;
    print(months);
    final monthlyRate = (_returnOnInvestmentAtRetirement / 100) * (1 - _taxRate / 100) / 12;
    print(monthlyRate);*/
    double factor = ((1 - pow(1 + monthlyRate, -months)) / monthlyRate) * (1 + monthlyRate);
    print(factor);
    setState(() {
      print(futureMonthlyGap);
      _targetCapital = futureMonthlyGap * factor;
      print(_targetCapital);
    });

    /*final months = 33 * 12;
    final monthlyRate = (3.0 / 100) / 12;

    final factor = (1 - pow(1 + monthlyRate, -months)) / monthlyRate * (1 + monthlyRate);

    return _netMonthlyPension * factor;*/

    /*final yearsInRetirement = _lifeExpectancy - _retirementAge;
    final annualGap = _pensionGap * 12;
    final retirementReturnRateAfterTax = _returnOnInvestmentAtRetirement / 100.0 * (1 - _taxRate / 100.0);
    final factor = (1 - 1 / pow(1 + retirementReturnRateAfterTax, yearsInRetirement)) / retirementReturnRateAfterTax;
    _targetCapital = annualGap * factor;
    return _targetCapital;*/
  }

  double _calculateMonthlySavings() {
    print(_currentCapital);
    print(_targetCapital);
    final monthsToRetirement = (_retirementAge - _currentAge) * 12;
    print(monthsToRetirement);
    final monthlyRate = (_returnOnInvestment / 100) / 12;
    print(monthlyRate);
    final futureValueOfCurrentCapital = _currentCapital * pow(1 + (_returnOnInvestment / 100), _retirementAge - _currentAge);
    print(futureValueOfCurrentCapital);
    final capitalNeededFromSavings = _targetCapital - futureValueOfCurrentCapital;
    print(capitalNeededFromSavings);

    if (capitalNeededFromSavings <= 0) {
      return 0.0;
    }
    final factor = (pow(1 + monthlyRate, monthsToRetirement) - 1) / monthlyRate;
    print(capitalNeededFromSavings / factor);
    setState(() {
      _requiredMonthlySavings = capitalNeededFromSavings / factor;
    });
    return _requiredMonthlySavings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('rentenlücke_rechner'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              Card(
                child: Form(
                  key: _pensionGapFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('staatliche_rentenversicherung'),
                        description: AppLocalizations.of(context).translate('staatliche_rentenversicherung_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _statePensionInsuranceController,
                        hintText: AppLocalizations.of(context).translate('staatliche_rentenversicherung') + '...',
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('betriebliche_altersvorsorge'),
                        description: AppLocalizations.of(context).translate('betriebliche_altersvorsorge_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _companyPensionSchemeController,
                        hintText: AppLocalizations.of(context).translate('betriebliche_altersvorsorge') + '...',
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('geschätzter_steuerabzug'),
                        description: AppLocalizations.of(context).translate('geschätzter_steuerabzug_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _estimatedTaxDeductionController,
                        hintText: AppLocalizations.of(context).translate('geschätzter_steuerabzug') + '...',
                        isPercentValue: true,
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('jährlicher_grundfreibetrag'),
                        description: AppLocalizations.of(context).translate('jährlicher_grundfreibetrag_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _annualBasicAllowanceController,
                        hintText: AppLocalizations.of(context).translate('jährlicher_grundfreibetrag') + '...',
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('monatliche_wunschrente'),
                        description: AppLocalizations.of(context).translate('monatliche_wunschrente_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _monthlyDesiredPensionController,
                        hintText: AppLocalizations.of(context).translate('monatliche_wunschrente') + '...',
                      ),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('berechnen'),
                        saveBtnController: _pensionGapBtnController,
                        onPressed: () => _calculatePensionGap(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            "Monatliche Rentenlücke",
                            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Erwartete mtl. Brutto-Rente:",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                "${formatToMoneyAmount(_grossMonthlyPension.toString(), withoutDecimalPlaces: 0)}",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Monatliche Wunschrente:",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              "${formatToMoneyAmount(_monthlyDesiredPension.toString(), withoutDecimalPlaces: 0)}",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Erwartete mtl. Netto-Rente:",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                "${formatToMoneyAmount(_netMonthlyPension.toString(), withoutDecimalPlaces: 0)}",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 2.0),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mtl. Rentenlücke Betrag:",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${formatToMoneyAmount(_pensionGap.toString(), withoutDecimalPlaces: 0)}",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SaveButton(
                          text: AppLocalizations.of(context).translate('rentenlücke_schließen'),
                          saveBtnController: _closePensionGapBtnController,
                          onPressed: () => {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Form(
                  key: _closePensionGapFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('rendite_im_rentenalter'),
                        description: AppLocalizations.of(context).translate('rendite_im_rentenalter_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _returnOnInvestmentAtRetirementController,
                        hintText: AppLocalizations.of(context).translate('rendite_im_rentenalter') + '...',
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('inflation_berücksichtigen'),
                        description: AppLocalizations.of(context).translate('inflation_berücksichtigen_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _inflationRateController,
                        hintText: AppLocalizations.of(context).translate('inflation_berücksichtigen') + '...',
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('renteneintrittsalter'),
                        description: AppLocalizations.of(context).translate('renteneintrittsalter_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _retirementAgeController,
                        hintText: AppLocalizations.of(context).translate('renteneintrittsalter') + '...',
                        isAgeValue: true,
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('geschätzte_lebenserwartung'),
                        description: AppLocalizations.of(context).translate('geschätzte_lebenserwartung_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _lifeExpectancyController,
                        hintText: AppLocalizations.of(context).translate('geschätzte_lebenserwartung') + '...',
                        isAgeValue: true,
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('aktuelles_alter'),
                        description: AppLocalizations.of(context).translate('aktuelles_alter_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _currentAgeController,
                        hintText: AppLocalizations.of(context).translate('aktuelles_alter') + '...',
                        isAgeValue: true,
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('bereits_vorhandenes_kapital'),
                        description: AppLocalizations.of(context).translate('bereits_vorhandenes_kapital_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _currentCapitalController,
                        hintText: AppLocalizations.of(context).translate('bereits_vorhandenes_kapital') + '...',
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('erwartete_rendite'),
                        description: AppLocalizations.of(context).translate('erwartete_rendite_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _returnOnInvestmentController,
                        hintText: AppLocalizations.of(context).translate('erwartete_rendite') + '...',
                        isPercentValue: true,
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('steuersatz_abgeltungssteuer'),
                        description: AppLocalizations.of(context).translate('steuersatz_abgeltungssteuer_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _taxRateController,
                        hintText: AppLocalizations.of(context).translate('steuersatz_abgeltungssteuer') + '...',
                      ),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('berechnen'),
                        saveBtnController: _calculateClosePensionGapBtnController,
                        onPressed: () => _calculateClosePensionGap(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            "Zielvermögen",
                            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Zusätzliche benötigtes\nKapitalvermögen mit\nKapitalverzehr:",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                "${formatToMoneyAmount(_requiredCapitalAtRetirement.toString(), withoutDecimalPlaces: 0)}",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Zusätzliche benötigtes\nKapitalvermögen ohne\nKapitalverzehr:",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              "${formatToMoneyAmount(_monthlyDesiredPension.toString(), withoutDecimalPlaces: 0)}",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          child: Text(
                            "Monatliche Sparrate",
                            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mtl. Sparrate\nmit Kapitalverzehr:",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${formatToMoneyAmount(_requiredMonthlySavings.toString(), withoutDecimalPlaces: 0)}",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mtl. Sparrate\nohne Kapitalverzehr:",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${formatToMoneyAmount(_pensionGap.toString(), withoutDecimalPlaces: 0)}",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SaveButton(
                          text: AppLocalizations.of(context).translate('als_ziel_hinzufügen'),
                          saveBtnController: _addClosePensionGapGoalBtnController,
                          onPressed: () => {},
                        ),
                      ],
                    ),
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
