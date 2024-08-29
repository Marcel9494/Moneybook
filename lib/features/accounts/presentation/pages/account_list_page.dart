import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/core/utils/number_formatter.dart';
import 'package:moneybook/features/accounts/presentation/widgets/cards/overview_cards.dart';

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

  void loadAccounts(BuildContext context) {
    BlocProvider.of<AccountBloc>(context).add(
      const LoadAllAccounts(),
    );
  }

  void _calculateOverviewValues(List<Account> accounts) {
    _assets = 0.0;
    _debts = 0.0;
    for (int i = 0; i < accounts.length; i++) {
      if (accounts[i].type == AccountType.credit) {
        _debts += accounts[i].amount;
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
          loadAccounts(context);
          if (state is Loaded) {
            if (state.accounts.isEmpty) {
              return const SizedBox(
                width: double.infinity,
                child: EmptyList(
                  text: 'Noch keine Konten vorhanden',
                  icon: Icons.account_balance_outlined,
                ),
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.accounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0 || state.accounts[index - 1].type != state.accounts[index].type) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 29.0, 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(state.accounts[index].type.name, style: const TextStyle(fontSize: 16.0)),
                                    Text(formatToMoneyAmount(_accountTypeAmounts[state.accounts[index].type].toString()),
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              AccountCard(account: state.accounts[index]),
                            ],
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
          }
          return const SizedBox();
        },
      ),
    );
  }
}
