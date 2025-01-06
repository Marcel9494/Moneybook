import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
import '../../../../accounts/presentation/bloc/account_bloc.dart';
import '../buttons/grid_view_button.dart';

void loadAccountsWithFilter(BuildContext context, List<String> accountNameFilter) {
  BlocProvider.of<AccountBloc>(context).add(
    LoadAccountsWithFilter(accountNameFilter),
  );
}

openAccountBottomSheet({
  required BuildContext context,
  required String title,
  required TextEditingController controller,
  List<String> accountNameFilter = const [],
}) {
  loadAccountsWithFilter(context, accountNameFilter);
  showCupertinoModalBottomSheet<void>(
    context: context,
    backgroundColor: Color(0xFF1c1b20),
    builder: (BuildContext context) {
      return BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is FilteredLoaded) {
            return Material(
              color: Color(0xFF1c1b20),
              child: Wrap(
                children: [
                  Column(
                    children: [
                      BottomSheetHeader(title: title),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: GridView.count(
                            primary: false,
                            padding: const EdgeInsets.all(24.0),
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            childAspectRatio: 1.6,
                            children: state.filteredAccounts.map((account) {
                              return GridViewButton(
                                onPressed: () => _setAccount(context, account.name, controller),
                                text: account.name,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      );
    },
  );
}

void _setAccount(BuildContext context, String text, TextEditingController controller) {
  controller.text = text;
  Navigator.pop(context);
}
