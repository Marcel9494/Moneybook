import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:moneybook/core/consts/common_consts.dart';
import 'package:moneybook/features/statistics/presentation/widgets/deco/calculator_item_text.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/consts/database_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/value_objects/account_type.dart';
import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/domain/value_objects/amount_type.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../../bookings/domain/value_objects/repetition_type.dart';

class HowLongLiveOfCapitalCalculatorPage extends StatefulWidget {
  const HowLongLiveOfCapitalCalculatorPage({super.key});

  @override
  State<HowLongLiveOfCapitalCalculatorPage> createState() => _HowLongLiveOfCapitalCalculatorPageState();
}

class _HowLongLiveOfCapitalCalculatorPageState extends State<HowLongLiveOfCapitalCalculatorPage> {
  final GlobalKey<FormState> _howLongLiveOfCapitalFormKey = GlobalKey<FormState>();
  final TextEditingController _investmentAssetsController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _otherAssetsController = TextEditingController();
  final TextEditingController _averageMonthlyExpensesController = TextEditingController();
  final TextEditingController _averageMonthlyPassiveIncomeController = TextEditingController();
  final RoundedLoadingButtonController _howLongLiveOfCapitalBtnController = RoundedLoadingButtonController();
  final RoundedLoadingButtonController _personalValuesBtnController = RoundedLoadingButtonController();
  double _averageMonthlyExpenses = 0.0;
  double _averageMonthlyPassiveIncome = 0.0;
  double _investmentAssets = 0.0;
  double _otherAssets = 0.0;
  double _debtAssets = 0.0;
  double _interestRate = 5.0;
  int _yearsToLiveOfCapital = 0;
  int _monthsToLiveOfCapital = 0;

  @override
  void initState() {
    super.initState();
    _calculateHowLongLiveOfCapitalWithPersonalValues(context, true);
  }

  void _changeInvestmentAssets(double newInvestmentAssets) {
    setState(() {
      _investmentAssets = newInvestmentAssets;
    });
    Navigator.pop(context);
  }

  void _changeInterestRate(double newInterestRate) {
    setState(() {
      _interestRate = newInterestRate;
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

  void _calculateHowLongLiveOfCapital(
    String investmentAssets,
    String interestRate,
    String otherAssets,
    String averageMonthlyExpenses,
    String averageMonthlyPassiveIncome,
    RoundedLoadingButtonController btnController,
    bool isFirstCalculation,
  ) {
    final FormState form = _howLongLiveOfCapitalFormKey.currentState!;
    if (form.validate() == false) {
      if (isFirstCalculation == false) {
        btnController.error();
        Timer(const Duration(milliseconds: durationInMs), () {
          btnController.reset();
        });
      }
    } else {
      double _investmentAssets = formatMoneyAmountToDouble(investmentAssets.toString());
      double _interestRate = formatMoneyAmountToDouble(interestRate.toString());
      double _otherAssets = formatMoneyAmountToDouble(otherAssets.toString());
      double _averageMonthlyExpenses = formatMoneyAmountToDouble(averageMonthlyExpenses.toString());
      double _averageMonthlyPassiveIncome = formatMoneyAmountToDouble(averageMonthlyPassiveIncome.toString());

      /*double investedCapital = _investmentAssets * (1 + (_interestRate / 100));
      double totalAssets = investedCapital + _otherAssets - _debtAssets;
      double monthlyGap = _averageMonthlyExpenses - _averageMonthlyPassiveIncome;

      double monthsToLiveOfCapital = 0.0;
      if (monthlyGap <= 0) {
        monthsToLiveOfCapital = double.infinity;
      } else {
        monthsToLiveOfCapital = totalAssets / monthlyGap;
      }
      int totalMonths = monthsToLiveOfCapital.floor();*/

      double investmentCapital = _investmentAssets;
      double otherCapital = _otherAssets - _debtAssets;
      double monthlyGap = _averageMonthlyExpenses - _averageMonthlyPassiveIncome;

      double monthsToLiveOfCapital = 0.0;

      if (monthlyGap <= 0) {
        monthsToLiveOfCapital = double.infinity;
      } else {
        double monthlyInterestRate = (_interestRate / 100) / 12;
        int months = 0;

        while ((investmentCapital + otherCapital) > 0) {
          investmentCapital *= (1 + monthlyInterestRate); // Verzinsung nur für Investment-Kapital
          double totalCapital = investmentCapital + otherCapital;

          totalCapital -= monthlyGap; // Monatlicher Kapitalverbrauch

          if (totalCapital < 0) break;

          // Kapital aufteilen für nächsten Monat
          if (totalCapital <= otherCapital) {
            otherCapital = totalCapital;
            investmentCapital = 0;
          } else {
            investmentCapital = totalCapital - otherCapital;
          }

          months++;
          print(months);
          if (months >= 1200) {
            months = 1200;
            break;
          }
        }

        monthsToLiveOfCapital = months.toDouble();
      }

      int totalMonths = monthsToLiveOfCapital.floor();

      _investmentAssetsController.text = formatToMoneyAmount(_investmentAssets.toString(), withoutDecimalPlaces: -1);
      final formatter = NumberFormat("#,##0.0", Localizations.localeOf(context).toString());
      _interestRateController.text = formatter.format(_interestRate) + '%';
      _otherAssetsController.text = formatToMoneyAmount((_otherAssets - _debtAssets).toString(), withoutDecimalPlaces: -1);
      _averageMonthlyExpensesController.text = formatToMoneyAmount(_averageMonthlyExpenses.toString(), withoutDecimalPlaces: -1);
      _averageMonthlyPassiveIncomeController.text = formatToMoneyAmount(_averageMonthlyPassiveIncome.toString(), withoutDecimalPlaces: -1);

      setState(() {
        _yearsToLiveOfCapital = totalMonths ~/ 12;
        _monthsToLiveOfCapital = totalMonths % 12;
      });
      if (isFirstCalculation == false) {
        btnController.success();
        Timer(const Duration(milliseconds: durationInMs), () {
          btnController.reset();
        });
      }
    }
  }

  void _calculateHowLongLiveOfCapitalWithPersonalValues(BuildContext context, bool isFirstCalculation) async {
    double monthlyPassiveIncome = 0.0;
    double monthlyExpenses = 0.0;
    _investmentAssets = 0.0;
    _otherAssets = 0.0;

    db = await openDatabase(localDbName);
    List<Map> bookingMap = await db.rawQuery('SELECT * FROM $bookingDbName');
    List<Booking> bookingList = bookingMap
        .map(
          (booking) => Booking(
            id: booking['id'],
            serieId: booking['serieId'],
            type: BookingType.fromString(booking['type']),
            title: booking['title'],
            date: DateTime.parse(booking['date']),
            repetition: RepetitionType.fromString(booking['repetition']),
            amount: booking['amount'],
            amountType: AmountType.fromString(booking['amountType']),
            currency: booking['currency'],
            fromAccount: booking['fromAccount'],
            toAccount: booking['toAccount'],
            categorie: booking['categorie'],
            isBooked: booking['isBooked'] == 0 ? false : true,
          ),
        )
        .toList();

    bookingList.sort((a, b) => a.date.compareTo(b.date));
    DateTime firstDate = bookingList.first.date;
    DateTime lastDate = bookingList.last.date;

    int months = (lastDate.year - firstDate.year) * 12 + (lastDate.month - firstDate.month) + 1;

    for (int i = 0; i < bookingList.length; i++) {
      if (bookingList[i].type == BookingType.income && bookingList[i].amountType == AmountType.passive) {
        monthlyPassiveIncome += bookingList[i].amount;
      } else if (bookingList[i].type == BookingType.expense) {
        monthlyExpenses += bookingList[i].amount;
      }
    }
    _averageMonthlyExpenses = months > 0 ? monthlyExpenses / months : monthlyExpenses = 0.0;
    _averageMonthlyPassiveIncome = months > 0 ? monthlyPassiveIncome / months : monthlyPassiveIncome = 0.0;

    List<Map> accountMap = await db.rawQuery('SELECT * FROM $accountDbName');
    List<Account> accountList = accountMap
        .map(
          (account) => Account(
            id: account['id'],
            type: AccountType.fromString(account['type']),
            name: account['name'],
            amount: account['amount'],
            currency: account['currency'],
          ),
        )
        .toList();
    for (int i = 0; i < accountList.length; i++) {
      if (accountList[i].type == AccountType.credit || accountList[i].amount < 0.0) {
        _debtAssets += accountList[i].amount;
      } else if (accountList[i].type == AccountType.capitalInvestment) {
        _investmentAssets += accountList[i].amount;
      } else {
        _otherAssets += accountList[i].amount;
      }
    }

    _investmentAssetsController.text = _investmentAssets.toStringAsFixed(2);
    _interestRateController.text = _interestRate.toStringAsFixed(1);
    _otherAssetsController.text = (_otherAssets - _debtAssets).toStringAsFixed(2);
    _averageMonthlyExpensesController.text = _averageMonthlyExpenses.toStringAsFixed(2);
    _averageMonthlyPassiveIncomeController.text = _averageMonthlyPassiveIncome.toStringAsFixed(2);

    _calculateHowLongLiveOfCapital(
      _investmentAssetsController.text,
      _interestRateController.text,
      _otherAssetsController.text,
      _averageMonthlyExpensesController.text,
      _averageMonthlyPassiveIncomeController.text,
      _personalValuesBtnController,
      isFirstCalculation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('wie_lange_von_kapital_leben'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              Card(
                child: Form(
                  key: _howLongLiveOfCapitalFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        onAmountTypeChanged: (otherAssets) => _changeInterestRate(otherAssets),
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
                        title: AppLocalizations.of(context).translate('durchschnittliche_passive_einnahmen'),
                        description: AppLocalizations.of(context).translate('durchschnittliche_passive_einnahmen_beschreibung'),
                      ),
                      AmountTextField(
                        amountController: _averageMonthlyPassiveIncomeController,
                        prefixIcon: Icon(HugeIcons.strokeRoundedProfit),
                        hintText: AppLocalizations.of(context).translate('durchschnittliche_passive_einnahmen') + '...',
                        onAmountTypeChanged: (otherAssets) => _changeAverageMonthlyPassiveIncome(otherAssets),
                      ),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('berechnen'),
                        saveBtnController: _howLongLiveOfCapitalBtnController,
                        onPressed: () => _calculateHowLongLiveOfCapital(
                          _investmentAssetsController.text,
                          _interestRateController.text,
                          _otherAssetsController.text,
                          _averageMonthlyExpensesController.text,
                          _averageMonthlyPassiveIncomeController.text,
                          _howLongLiveOfCapitalBtnController,
                          false,
                        ),
                      ),
                      SaveButton(
                        text: AppLocalizations.of(context).translate('persönliche_werte_verwenden'),
                        saveBtnController: _personalValuesBtnController,
                        onPressed: () => _calculateHowLongLiveOfCapitalWithPersonalValues(context, false),
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
                    AppLocalizations.of(context).translate('ergebnis') +
                        ': ' +
                        AppLocalizations.of(context).translate('du_kannst') +
                        ' ' +
                        _yearsToLiveOfCapital.toString() +
                        ' ' +
                        AppLocalizations.of(context).translate('jahre') +
                        ' ' +
                        AppLocalizations.of(context).translate('und') +
                        ' ' +
                        _monthsToLiveOfCapital.toString() +
                        ' ' +
                        AppLocalizations.of(context).translate('monate') +
                        AppLocalizations.of(context).translate('von_deinem_kapital_leben'),
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
