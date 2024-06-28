import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/account_bloc.dart';
import '../widgets/cards/account_card.dart';

class AccountListPage extends StatefulWidget {
  const AccountListPage({super.key});

  @override
  State<AccountListPage> createState() => _AccountListPageState();
}

class _AccountListPageState extends State<AccountListPage> {
  void loadAccounts(BuildContext context) {
    BlocProvider.of<AccountBloc>(context).add(
      const LoadAllAccounts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          loadAccounts(context);
          if (state is Loaded) {
            return ListView.builder(
              itemCount: state.accounts.length,
              itemBuilder: (BuildContext context, int index) {
                return AccountCard(account: state.accounts[index]);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
