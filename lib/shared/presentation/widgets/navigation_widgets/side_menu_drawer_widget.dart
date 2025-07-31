import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/app_localizations.dart';
import '../deco/new_label.dart';

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
  void initState() {
    super.initState();
    Posthog().capture(
      eventName: 'Seiten Menü geöffnet',
      properties: {
        'Aktion': 'Seiten Menü geöffnet',
      },
    );
  }

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
                  Text(
                    AppLocalizations.of(context).translate('moneybook'),
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
              AppLocalizations.of(context).translate('buchungen'),
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
              AppLocalizations.of(context).translate('konten'),
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
              AppLocalizations.of(context).translate('statistiken'),
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
              AppLocalizations.of(context).translate('budgets'),
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
              AppLocalizations.of(context).translate('kategorien'),
              style: TextStyle(color: widget.tabIndex == 4 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 4 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 4,
            onTap: () {
              Navigator.popAndPushNamed(context, categorieListRoute);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.rate_review_rounded,
              color: widget.tabIndex == 5 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Text(
              AppLocalizations.of(context).translate('feedback'),
              style: TextStyle(color: widget.tabIndex == 5 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 5 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 5,
            onTap: () {
              Navigator.popAndPushNamed(context, feedbackRoute);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bug_report_rounded,
              color: widget.tabIndex == 6 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Text(
              AppLocalizations.of(context).translate('fehler_melden'),
              style: TextStyle(color: widget.tabIndex == 6 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 6 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 6,
            onTap: () {
              Navigator.popAndPushNamed(context, bugReportRoute);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.settings_rounded,
              color: widget.tabIndex == 7 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Row(
              children: [
                Text(
                  AppLocalizations.of(context).translate('einstellungen'),
                  style: TextStyle(color: widget.tabIndex == 7 ? Colors.cyan.shade400 : Colors.white),
                ),
                NewLabel(),
              ],
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 7 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 7,
            onTap: () {
              Navigator.popAndPushNamed(context, settingsRoute);
            },
          ),
          /*ListTile(
            leading: Icon(
              Icons.calculate_rounded,
              color: widget.tabIndex == 8 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Text(
              AppLocalizations.of(context).translate('rechner'),
              style: TextStyle(color: widget.tabIndex == 8 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 8 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 8,
            onTap: () {
              Navigator.popAndPushNamed(context, calculatorOverviewRoute);
            },
          ),
          ListTile(
            leading: Icon(
              HugeIcons.strokeRoundedTarget02,
              color: widget.tabIndex == 9 ? Colors.cyan.shade400 : Colors.white,
            ),
            title: Text(
              AppLocalizations.of(context).translate('ziele'),
              style: TextStyle(color: widget.tabIndex == 9 ? Colors.cyan.shade400 : Colors.white),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: widget.tabIndex == 9 ? Colors.cyan.shade400 : Colors.white,
            ),
            selected: widget.tabIndex == 9,
            onTap: () {
              Navigator.popAndPushNamed(context, goalOverviewRoute);
            },
          ),*/
        ],
      ),
    );
  }
}
