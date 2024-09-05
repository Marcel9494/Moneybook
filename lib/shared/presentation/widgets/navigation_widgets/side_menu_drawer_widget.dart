import 'package:flutter/material.dart';

import '../../../../core/consts/route_consts.dart';

class SideMenuDrawer extends StatefulWidget {
  final int tabIndex;
  final Function onTabChange;

  const SideMenuDrawer({
    super.key,
    required this.tabIndex,
    required this.onTabChange,
  });

  @override
  State<SideMenuDrawer> createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends State<SideMenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Moneybook'),
          ),
          ListTile(
            leading: Icon(
              Icons.auto_stories_rounded,
              color: widget.tabIndex == 0 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Text(
              'Buchungen',
              style: TextStyle(color: widget.tabIndex == 0 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 0 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 0,
            onTap: () => widget.onTabChange(0),
          ),
          ListTile(
            leading: Icon(
              Icons.account_balance_wallet_rounded,
              color: widget.tabIndex == 1 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Text(
              'Konten',
              style: TextStyle(color: widget.tabIndex == 1 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 1 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 1,
            onTap: () => widget.onTabChange(1),
          ),
          ListTile(
            leading: Icon(
              Icons.insights_rounded,
              color: widget.tabIndex == 2 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Text(
              'Statistiken',
              style: TextStyle(color: widget.tabIndex == 2 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 2 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 2,
            onTap: () => widget.onTabChange(2),
          ),
          ListTile(
            leading: Icon(
              Icons.savings_rounded,
              color: widget.tabIndex == 3 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Text(
              'Budgets',
              style: TextStyle(color: widget.tabIndex == 3 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 3 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 3,
            onTap: () => widget.onTabChange(3),
          ),
          ListTile(
            leading: Icon(
              Icons.donut_small,
              color: widget.tabIndex == 4 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Text(
              'Kategorien',
              style: TextStyle(color: widget.tabIndex == 4 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 4 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 4,
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, categorieListRoute);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.settings_rounded,
              color: widget.tabIndex == 5 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Text(
              'Einstellungen',
              style: TextStyle(color: widget.tabIndex == 5 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 5 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 5,
            onTap: () {
              Navigator.popAndPushNamed(context, settingsRoute);
            },
          ),
        ],
      ),
    );
  }
}
