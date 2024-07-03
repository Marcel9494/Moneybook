import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/presentation/widgets/deco/empty_list.dart';
import '../../domain/value_objects/account_type.dart';
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
    // TODO eigenes Event für jeden Kontotyp den zusammengefassten Kontostand berechnen und implementieren
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
              return Expanded(
                child: ListView.builder(
                  itemCount: state.accounts.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0 || state.accounts[index - 1].type != state.accounts[index].type) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            child: Text(state.accounts[index].type.name, style: const TextStyle(fontSize: 16.0)),
                          ),
                          AccountCard(account: state.accounts[index]),
                        ],
                      );
                    } else {
                      return AccountCard(account: state.accounts[index]);
                    }
                  },
                ),
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }
}
