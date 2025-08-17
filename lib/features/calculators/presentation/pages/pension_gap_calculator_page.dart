import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:moneybook/shared/presentation/widgets/buttons/second_action_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../core/utils/error_flushbar.dart';
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
  final _scrollGlobalKey = GlobalKey();
  // Rentenlücke berechnen
  final TextEditingController _statePensionInsuranceController = TextEditingController();
  final TextEditingController _companyPensionSchemeController = TextEditingController();
  final TextEditingController _furtherPensionController = TextEditingController();
  final TextEditingController _annualBasicAllowanceController = TextEditingController();
  final TextEditingController _estimatedTaxDeductionController = TextEditingController();
  final TextEditingController _monthlyDesiredPensionController = TextEditingController();
  final ExpansionTileController _eTRetirementProvisionController = ExpansionTileController();
  final ExpansionTileController _eTTaxationController = ExpansionTileController();
  final ExpansionTileController _eTFurtherController = ExpansionTileController();
  final RoundedLoadingButtonController _pensionGapBtnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _calculateClosePensionGapBtnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _addClosePensionGapGoalBtnController = RoundedLoadingButtonController();
  double _statePensionInsurance = 1200.0;
  double _companyPensionScheme = 0.0;
  double _furtherPension = 0.0;
  double _estimatedTaxDeduction = 15.0;
  double _annualBasicAllowance = 12096.0;
  double _monthlyDesiredPension = 2200.0;
  double _grossMonthlyPension = 0.0;
  double _netMonthlyPension = 0.0;
  double _pensionGap = 0.0;
  bool _isClosePensionGapBtnEnabled = false;

  // Zielvermögen um Rentenlücke zu schließen berechnen
  final TextEditingController _returnOnInvestmentAtRetirementController = TextEditingController();
  final TextEditingController _inflationRateController = TextEditingController();
  final TextEditingController _retirementAgeController = TextEditingController();
  final TextEditingController _lifeExpectancyController = TextEditingController();
  double _returnOnInvestmentAtRetirement = 3.0;
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
  double _requiredMonthlySavingsWithDrawdown = 0.0;
  double _requiredMonthlySavingsWithoutDrawdown = 0.0;
  double _requiredCapitalAtRetirementWithDrawdown = 0.0;
  double _requiredCapitalAtRetirementWithoutDrawdown = 0.0;

  @override
  void initState() {
    super.initState();
    // Rentenlücke berechnen
    _statePensionInsuranceController.text = formatToMoneyAmount(_statePensionInsurance.toString());
    _companyPensionSchemeController.text = formatToMoneyAmount(_companyPensionScheme.toString());
    _furtherPensionController.text = formatToMoneyAmount(_furtherPension.toString());
    _annualBasicAllowanceController.text = formatToMoneyAmount(_annualBasicAllowance.toString());
    _estimatedTaxDeductionController.text = formatDoubleToPercent(_estimatedTaxDeduction);
    _monthlyDesiredPensionController.text = formatToMoneyAmount(_monthlyDesiredPension.toString());

    // Zielvermögen um Rentenlücke zu schließen berechnen
    _returnOnInvestmentAtRetirementController.text = formatDoubleToPercent(_returnOnInvestmentAtRetirement);
    _inflationRateController.text = formatDoubleToPercent(_inflationRate);
    _retirementAgeController.text = _retirementAge.toString();
    _lifeExpectancyController.text = _lifeExpectancy.toString();
    _currentAgeController.text = _currentAge.toString();
    _currentCapitalController.text = formatToMoneyAmount(_currentCapital.toString());
    _returnOnInvestmentController.text = formatDoubleToPercent(_returnOnInvestment);
    _taxRateController.text = formatDoubleToPercent(_taxRate);
  }

  void _calculatePensionGap() {
    final FormState form = _pensionGapFormKey.currentState!;
    if (formatPercentToDouble(_estimatedTaxDeductionController.text) >= 100.0) {
      _pensionGapBtnController.error();
      showErrorFlushbar(context, 'Der geschätzte Steuerabzug darf nicht 100% oder mehr betragen.');
      Timer(const Duration(milliseconds: durationInMs), () {
        _pensionGapBtnController.reset();
      });
      return;
    } else if (form.validate() == false) {
      _pensionGapBtnController.error();
      Timer(const Duration(milliseconds: durationInMs), () {
        _pensionGapBtnController.reset();
      });
    } else {
      _statePensionInsurance = formatMoneyAmountToDouble(_statePensionInsuranceController.text);
      _companyPensionScheme = formatMoneyAmountToDouble(_companyPensionSchemeController.text);
      _furtherPension = formatMoneyAmountToDouble(_furtherPensionController.text);
      _annualBasicAllowance = formatMoneyAmountToDouble(_annualBasicAllowanceController.text);
      _estimatedTaxDeduction = formatPercentToDouble(_estimatedTaxDeductionController.text);
      _monthlyDesiredPension = formatMoneyAmountToDouble(_monthlyDesiredPensionController.text);

      _grossMonthlyPension = _statePensionInsurance + _companyPensionScheme + _furtherPension;
      double grossAnnualPension = _grossMonthlyPension * 12.0;

      double taxableIncome = grossAnnualPension - _annualBasicAllowance;
      if (taxableIncome < 0) taxableIncome = 0;

      double taxAmount = taxableIncome * (_estimatedTaxDeduction / 100.0);
      double netAnnualPension = grossAnnualPension - taxAmount;

      _netMonthlyPension = netAnnualPension / 12.0;
      _pensionGap = _monthlyDesiredPension - _netMonthlyPension;
      if (_pensionGap < 0) {
        _pensionGap = 0.0;
      }

      setState(() {
        _isClosePensionGapBtnEnabled = true;
      });
      _pensionGapBtnController.success();
      Timer(const Duration(milliseconds: durationInMs), () {
        _pensionGapBtnController.reset();
      });
    }
  }

  void _scrollToClosePensionGapCalculation() {
    final context = _scrollGlobalKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  // TODO hier weitermachen und die Funktion verbessern
  void _calculateClosePensionGapValues() {
    final FormState form = _closePensionGapFormKey.currentState!;
    if (int.parse(_currentAgeController.text) >= int.parse(_retirementAgeController.text)) {
      _calculateClosePensionGapBtnController.error();
      showErrorFlushbar(context, 'Das aktuelle Alter muss kleiner als das Renteneintrittsalter sein.');
      Timer(const Duration(milliseconds: durationInMs), () {
        _calculateClosePensionGapBtnController.reset();
      });
      return;
    } else if (int.parse(_currentAgeController.text) >= int.parse(_lifeExpectancyController.text)) {
      _calculateClosePensionGapBtnController.error();
      showErrorFlushbar(context, 'Das aktuelle Alter muss kleiner als die geschätzte Lebenserwartung sein.');
      Timer(const Duration(milliseconds: durationInMs), () {
        _calculateClosePensionGapBtnController.reset();
      });
    } else if (int.parse(_retirementAgeController.text) >= int.parse(_lifeExpectancyController.text)) {
      _calculateClosePensionGapBtnController.error();
      showErrorFlushbar(context, 'Das Renteneintrittsalter muss kleiner als die geschätzte Lebenserwartung sein.');
      Timer(const Duration(milliseconds: durationInMs), () {
        _calculateClosePensionGapBtnController.reset();
      });
    } else if (formatPercentToDouble(_taxRateController.text) >= 100.0) {
      _calculateClosePensionGapBtnController.error();
      showErrorFlushbar(context, 'Der Steuersatz (Abgeltungssteuer) darf nicht 100% oder mehr betragen.');
      Timer(const Duration(milliseconds: durationInMs), () {
        _calculateClosePensionGapBtnController.reset();
      });
    } else if (!form.validate() || _isClosePensionGapBtnEnabled == false) {
      _calculateClosePensionGapBtnController.error();
      if (_isClosePensionGapBtnEnabled == false) {
        showErrorFlushbar(context, 'Bitte berechne zuerst deine Rentenlücke.');
      }
      Timer(const Duration(milliseconds: durationInMs), () {
        _calculateClosePensionGapBtnController.reset();
      });
      return;
    }
    _currentAge = int.parse(_currentAgeController.text);
    _retirementAge = int.parse(_retirementAgeController.text);
    _lifeExpectancy = int.parse(_lifeExpectancyController.text);
    _currentCapital = formatMoneyAmountToDouble(_currentCapitalController.text);
    _returnOnInvestment = formatPercentToDouble(_returnOnInvestmentController.text);
    _returnOnInvestmentAtRetirement = formatPercentToDouble(_returnOnInvestmentAtRetirementController.text);
    _inflationRate = formatPercentToDouble(_inflationRateController.text);
    _taxRate = formatPercentToDouble(_taxRateController.text);

    final int yearsToRetirement = _retirementAge - _currentAge;
    final int retirementYears = _lifeExpectancy - _retirementAge;
    final int monthsToRetirement = yearsToRetirement * 12;

    // 1) Bruttobetrag pro Monat (Steuern als Abzug auf Auszahlung)
    final double grossMonthlyPaymentAtRetirement = _pensionGap / (1 - _taxRate / 100);

    // 2) Monatszinssatz während der Rente (nominal)
    final double rRetMonth = pow(1 + _returnOnInvestmentAtRetirement / 100, 1 / 12) - 1;
    final int nRetMonths = retirementYears * 12;

    // ---------- Mit Kapitalverzehr ----------
    // Barwert einer Annuität (Auszahlung bis Lebensende)
    final double pvFactorWithDrawdown = (1 - pow(1 + rRetMonth, -nRetMonths)) / rRetMonth;
    _requiredCapitalAtRetirementWithDrawdown = grossMonthlyPaymentAtRetirement * pvFactorWithDrawdown - _currentCapital;

    // ---- Variante: Nur von Erträgen leben ----
    // 1) Lücke inflationsbereinigt zum Rentenstart
    final double futureGrossMonthlyGap = grossMonthlyPaymentAtRetirement * pow(1 + _inflationRate / 100, yearsToRetirement);

    // 3) Kapitalbedarf zum Rentenstart (Kapital bleibt erhalten)
    _requiredCapitalAtRetirementWithoutDrawdown = (futureGrossMonthlyGap / rRetMonth * (1 + (_taxRate / 100))) - _currentCapital;

    // 4) Reale Rendite bis Rentenstart (inflationsbereinigt)
    final double realReturnUntilRetirement = (1 + _returnOnInvestment / 100) / (1 + _inflationRate / 100) - 1;

    final double rMonthlyReal = realReturnUntilRetirement / 12;

    // 5) Faktor für Sparplan (Zinseszins)
    //final double factor = pow(1 + rMonthlyReal, monthsToRetirement) - 1;
    // 4) Reale Rendite bis Rentenbeginn (inflationsbereinigt)
    double realReturn = (1 + _returnOnInvestment / 100) / (1 + _inflationRate / 100) - 1;
    double r = realReturn / 12;
    double factor = pow(1 + r, monthsToRetirement) - 1;
    // 6) Monatliche Sparrate, um das Kapital zu erreichen
    _requiredMonthlySavingsWithoutDrawdown = (_requiredCapitalAtRetirementWithoutDrawdown * rMonthlyReal * (1 + (_taxRate / 100))) / factor;

    setState(() {
      // Mit Kapitalverzehr
      _requiredMonthlySavingsWithDrawdown = (_requiredCapitalAtRetirementWithDrawdown * r) / factor;

      // Nur Erträge
      _requiredMonthlySavingsWithoutDrawdown = (_requiredCapitalAtRetirementWithoutDrawdown * r * (1 + (_taxRate / 100))) / factor;
    });

    _calculateClosePensionGapBtnController.success();
    Timer(const Duration(milliseconds: durationInMs), () {
      _calculateClosePensionGapBtnController.reset();
    });
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
                        prefixIcon: Icon(HugeIcons.strokeRoundedMoneySavingJar),
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('monatliche_wunschrente'),
                        description: AppLocalizations.of(context).translate('monatliche_wunschrente_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _monthlyDesiredPensionController,
                        hintText: AppLocalizations.of(context).translate('monatliche_wunschrente') + '...',
                        prefixIcon: Icon(HugeIcons.strokeRoundedTarget02),
                      ),
                      ExpansionTile(
                        controller: _eTRetirementProvisionController,
                        iconColor: Colors.cyanAccent,
                        title: Text(
                          AppLocalizations.of(context).translate('weitere_altersvorsorgen'),
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          CalculatorItemText(
                            title: AppLocalizations.of(context).translate('betriebliche_altersvorsorge'),
                            description: AppLocalizations.of(context).translate('betriebliche_altersvorsorge_beschreibung'),
                          ),
                          AmountTextField(
                            amountController: _companyPensionSchemeController,
                            hintText: AppLocalizations.of(context).translate('betriebliche_altersvorsorge') + '...',
                            prefixIcon: Icon(HugeIcons.strokeRoundedMoneyReceiveFlow01),
                          ),
                          CalculatorItemText(
                            title: AppLocalizations.of(context).translate('weitere_vorsorgeleistungen'),
                            description: AppLocalizations.of(context).translate('weitere_vorsorgeleistungen_beschreibung'),
                          ),
                          AmountTextField(
                            amountController: _furtherPensionController,
                            hintText: AppLocalizations.of(context).translate('weitere_vorsorgeleistungen') + '...',
                            prefixIcon: Icon(HugeIcons.strokeRoundedMoneySend01),
                          ),
                        ],
                      ),
                      ExpansionTile(
                        controller: _eTTaxationController,
                        iconColor: Colors.cyanAccent,
                        title: Text(
                          AppLocalizations.of(context).translate('steuern'),
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          CalculatorItemText(
                            title: AppLocalizations.of(context).translate('geschätzter_steuerabzug'),
                            description: AppLocalizations.of(context).translate('geschätzter_steuerabzug_beschreibung'),
                          ),
                          AmountTextField(
                            amountController: _estimatedTaxDeductionController,
                            hintText: AppLocalizations.of(context).translate('geschätzter_steuerabzug') + '...',
                            prefixIcon: Icon(HugeIcons.strokeRoundedTaxes),
                            isPercentValue: true,
                          ),
                          CalculatorItemText(
                            title: AppLocalizations.of(context).translate('jährlicher_grundfreibetrag'),
                            description: AppLocalizations.of(context).translate('jährlicher_grundfreibetrag_beschreibung'),
                          ),
                          AmountTextField(
                            amountController: _annualBasicAllowanceController,
                            hintText: AppLocalizations.of(context).translate('jährlicher_grundfreibetrag') + '...',
                            prefixIcon: Icon(HugeIcons.strokeRoundedMoneySecurity),
                          ),
                        ],
                      ),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('rentenlücke_berechnen'),
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
                            AppLocalizations.of(context).translate("monatliche_rentenlücke"),
                            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context).translate("erwartete_mtl_brutto-rente") + ':',
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
                              AppLocalizations.of(context).translate("monatliche_wunschrente") + ':',
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
                                AppLocalizations.of(context).translate("erwartete_mtl_netto-rente") + ':',
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
                                AppLocalizations.of(context).translate("mtl_rentenlücke_betrag") + ':',
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${formatToMoneyAmount(_pensionGap.toString(), withoutDecimalPlaces: 0)}",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            _pensionGap == 0.0 && _isClosePensionGapBtnEnabled == true
                                ? 'Deine Rentenlücke ist bereits geschlossen. Du brauchst kein zusätzliches Vermögen.'
                                : '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        SecondActionButton(
                          text: AppLocalizations.of(context).translate('rentenlücke_schließen'),
                          onPressed: () => _scrollToClosePensionGapCalculation(),
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
                    key: _scrollGlobalKey,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  title: AppLocalizations.of(context).translate('renteneintrittsalter'),
                                  description: AppLocalizations.of(context).translate('renteneintrittsalter_beschreibung'),
                                  fontWeight: FontWeight.normal,
                                  showInfoIcon: false,
                                  fontSize: 14.0,
                                  leftPadding: 0.0,
                                  rightPadding: 2.0,
                                ),
                                AmountTextField(
                                  amountController: _retirementAgeController,
                                  prefixIcon: Icon(HugeIcons.strokeRoundedTarget02),
                                  hintText: AppLocalizations.of(context).translate('renteneintrittsalter') + '...',
                                  showSeparator: false,
                                  isAgeValue: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('geschätzte_lebenserwartung'),
                        description: AppLocalizations.of(context).translate('geschätzte_lebenserwartung_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _lifeExpectancyController,
                        hintText: AppLocalizations.of(context).translate('geschätzte_lebenserwartung') + '...',
                        prefixIcon: Icon(HugeIcons.strokeRoundedAccountSetting02),
                        isAgeValue: true,
                      ),
                      CalculatorItemText(
                        title: AppLocalizations.of(context).translate('bereits_vorhandenes_kapital'),
                        description: AppLocalizations.of(context).translate('bereits_vorhandenes_kapital_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _currentCapitalController,
                        hintText: AppLocalizations.of(context).translate('bereits_vorhandenes_kapital') + '...',
                        prefixIcon: Icon(HugeIcons.strokeRoundedMoneyBag02),
                        showMinus: true,
                      ),
                      ExpansionTile(
                        controller: _eTFurtherController,
                        iconColor: Colors.cyanAccent,
                        title: Text(
                          AppLocalizations.of(context).translate('weiteres'),
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        children: [
                          CalculatorItemText(
                            title: AppLocalizations.of(context).translate('erwartete_rendite_bis_rente'),
                            description: AppLocalizations.of(context).translate('erwartete_rendite_bis_rente_beschreibung'),
                          ),
                          AmountTextField(
                            amountController: _returnOnInvestmentController,
                            hintText: AppLocalizations.of(context).translate('erwartete_rendite_bis_rente') + '...',
                            prefixIcon: Icon(HugeIcons.strokeRoundedPercentSquare),
                            isPercentValue: true,
                          ),
                          CalculatorItemText(
                            title: AppLocalizations.of(context).translate('rendite_im_rentenalter'),
                            description: AppLocalizations.of(context).translate('rendite_im_rentenalter_beschreibung'),
                          ),
                          AmountTextField(
                            amountController: _returnOnInvestmentAtRetirementController,
                            hintText: AppLocalizations.of(context).translate('rendite_im_rentenalter') + '...',
                            prefixIcon: Icon(HugeIcons.strokeRoundedPercentSquare),
                            isPercentValue: true,
                          ),
                          CalculatorItemText(
                            title: AppLocalizations.of(context).translate('inflationsrate'),
                            description: AppLocalizations.of(context).translate('inflationsrate_beschreibung'),
                          ),
                          AmountTextField(
                            amountController: _inflationRateController,
                            hintText: AppLocalizations.of(context).translate('inflationsrate') + '...',
                            prefixIcon: Icon(HugeIcons.strokeRoundedSquareArrowUpRight),
                            isPercentValue: true,
                          ),
                          CalculatorItemText(
                            title: AppLocalizations.of(context).translate('steuersatz_abgeltungssteuer'),
                            description: AppLocalizations.of(context).translate('steuersatz_abgeltungssteuer_beschreibung'),
                          ),
                          AmountTextField(
                            amountController: _taxRateController,
                            hintText: AppLocalizations.of(context).translate('steuersatz_abgeltungssteuer') + '...',
                            prefixIcon: Icon(HugeIcons.strokeRoundedTaxes),
                            isPercentValue: true,
                            maximumFractionDigits: 3,
                          ),
                        ],
                      ),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('berechnen'),
                        saveBtnController: _calculateClosePensionGapBtnController,
                        onPressed: () => _calculateClosePensionGapValues(),
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
                            "Mit Kapitalverzehr",
                            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Zusätzliche benötigtes\nKapitalvermögen:",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                "${formatToMoneyAmount(_requiredCapitalAtRetirementWithDrawdown.toString(), withoutDecimalPlaces: 0)}",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Monatliche Sparrate:",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${formatToMoneyAmount(_requiredMonthlySavingsWithDrawdown.toString())}",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SecondActionButton(
                          text: AppLocalizations.of(context).translate('als_sparziel_hinzufügen'),
                          onPressed: () => {},
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            "Ohne Kapitalverzehr",
                            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Zusätzliche benötigtes\nKapitalvermögen:",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              "${formatToMoneyAmount(_requiredCapitalAtRetirementWithoutDrawdown.toString(), withoutDecimalPlaces: 0)}",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context).translate("monatliche_sparrate") + ':',
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${formatToMoneyAmount(_requiredMonthlySavingsWithoutDrawdown.toString())}",
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SecondActionButton(
                          text: AppLocalizations.of(context).translate('als_sparziel_hinzufügen'),
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
