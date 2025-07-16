import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:moneybook/core/consts/route_consts.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:moneybook/features/accounts/presentation/widgets/cards/overview_cards.dart';
import 'package:moneybook/features/budgets/presentation/widgets/deco/create_row.dart';

import '../../../../core/consts/common_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../shared/presentation/widgets/deco/empty_list.dart';
import '../../domain/entities/account.dart';
import '../../domain/value_objects/account_type.dart';
import '../bloc/account_bloc.dart';
import '../widgets/cards/account_card.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({super.key});

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  final Map<AccountType, double> _accountTypeAmounts = {};
  double _assets = 0.0;
  double _debts = 0.0;

  @override
  void initState() {
    super.initState();
    _loadAccounts(context);
  }

  void _loadAccounts(BuildContext context) {
    BlocProvider.of<AccountBloc>(context).add(
      LoadAccounts(),
    );
  }

  void _calculateOverviewValues(List<Account> accounts) {
    _assets = 0.0;
    _debts = 0.0;
    for (int i = 0; i < accounts.length; i++) {
      if (accounts[i].type == AccountType.credit || accounts[i].amount < 0.0) {
        _debts += accounts[i].amount.abs();
      } else {
        _assets += accounts[i].amount;
      }
    }
  }

  void _calculateAccountTypeAmounts(List<Account> accounts) {
    _accountTypeAmounts.clear();
    for (int i = 0; i < accounts.length; i++) {
      if (_accountTypeAmounts.containsKey(accounts[i].type) == false) {
        _accountTypeAmounts[accounts[i].type] = 0.0;
      }
      double? currentAccountTypeAmount = _accountTypeAmounts[accounts[i].type];
      _accountTypeAmounts[accounts[i].type] = currentAccountTypeAmount! + accounts[i].amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is Loaded) {
            if (state.accounts.isEmpty) {
              return Column(
                children: [
                  OverviewCards(
                    accounts: state.accounts,
                    assets: 0,
                    debts: 0,
                  ),
                  CreateRow(
                    title: AppLocalizations.of(context).translate('konten'),
                    buttonText: AppLocalizations.of(context).translate('konto_erstellen'),
                    createRoute: createAccountRoute,
                    leftPadding: 10.0,
                  ),
                  Expanded(
                    child: EmptyList(
                      text: AppLocalizations.of(context).translate('noch_keine_konten_vorhanden'),
                      icon: Icons.account_balance_outlined,
                    ),
                  ),
                ],
              );
            } else {
              _calculateOverviewValues(state.accounts);
              _calculateAccountTypeAmounts(state.accounts);
              return Column(
                children: [
                  OverviewCards(
                    accounts: state.accounts,
                    assets: _assets,
                    debts: _debts,
                  ),
                  CreateRow(
                    title: AppLocalizations.of(context).translate('konten'),
                    buttonText: AppLocalizations.of(context).translate('konto_erstellen'),
                    createRoute: createAccountRoute,
                    leftPadding: 10.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.accounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0 || state.accounts[index - 1].type != state.accounts[index].type) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: Duration(milliseconds: staggeredListDurationInMs),
                            child: SlideAnimation(
                              verticalOffset: 30.0,
                              curve: Curves.easeOutCubic,
                              child: FadeInAnimation(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 29.0, 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(AppLocalizations.of(context).translate(state.accounts[index].type.pluralName),
                                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                          Text(formatToMoneyAmount(_accountTypeAmounts[state.accounts[index].type].toString()),
                                              style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    AccountCard(account: state.accounts[index]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return AccountCard(account: state.accounts[index]);
                        }
                      },
                    ),
                  ),
                ],
              );
            }
            // Wenn der Benutzer auf der Kontoliste eine Buchung erstellen möchte und
            // in der Buchung erstellen Seite ein Konto auswählt und dann die Buchung
            // erstellen abbricht ist der neue Status FilteredLoaded und nicht mehr
            // Loaded beim AccountBloc.
            // TODO sollte besser implementiert werden z.B.: Wenn der Benutzer die Buchung
            // TODO erstellen abbrechen möchte Dialog anzeigen und dann dort Loaded Status
            // TODO setzen über LoadAccounts Event?
          } else if (state is FilteredLoaded) {
            if (state.filteredAccounts.isEmpty) {
              return Column(
                children: [
                  OverviewCards(
                    accounts: state.filteredAccounts,
                    assets: 0,
                    debts: 0,
                  ),
                  CreateRow(
                    title: AppLocalizations.of(context).translate('konten'),
                    buttonText: AppLocalizations.of(context).translate('konto_erstellen'),
                    createRoute: createAccountRoute,
                    leftPadding: 10.0,
                  ),
                  Expanded(
                    child: EmptyList(
                      text: AppLocalizations.of(context).translate('noch_keine_konten_vorhanden'),
                      icon: Icons.account_balance_outlined,
                    ),
                  ),
                ],
              );
            } else {
              _calculateOverviewValues(state.filteredAccounts);
              _calculateAccountTypeAmounts(state.filteredAccounts);
              return Column(
                children: [
                  OverviewCards(
                    accounts: state.filteredAccounts,
                    assets: _assets,
                    debts: _debts,
                  ),
                  CreateRow(
                    title: AppLocalizations.of(context).translate('konten'),
                    buttonText: AppLocalizations.of(context).translate('konto_erstellen'),
                    createRoute: createAccountRoute,
                    leftPadding: 10.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.filteredAccounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0 || state.filteredAccounts[index - 1].type != state.filteredAccounts[index].type) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: Duration(milliseconds: staggeredListDurationInMs),
                            child: SlideAnimation(
                              verticalOffset: 30.0,
                              curve: Curves.easeOutCubic,
                              child: FadeInAnimation(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 29.0, 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(AppLocalizations.of(context).translate(state.filteredAccounts[index].type.pluralName),
                                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                          Text(formatToMoneyAmount(_accountTypeAmounts[state.filteredAccounts[index].type].toString()),
                                              style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    AccountCard(account: state.filteredAccounts[index]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return AccountCard(account: state.filteredAccounts[index]);
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }
}
