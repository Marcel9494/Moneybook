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
          SizedBox(
            height: 86.0,
            child: DrawerHeader(
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/moneybook_app_icon.png',
                      width: 46.0,
                      height: 46.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  const Text(
                    'Moneybook',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
            ),
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
            onTap: () => {
              Navigator.pop(context),
              widget.onTabChange(0),
            },
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
            onTap: () => {
              Navigator.pop(context),
              widget.onTabChange(1),
            },
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
            onTap: () => {
              Navigator.pop(context),
              widget.onTabChange(2),
            },
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
            onTap: () => {
              Navigator.pop(context),
              widget.onTabChange(3),
            },
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
              //Navigator.pop(context);
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
