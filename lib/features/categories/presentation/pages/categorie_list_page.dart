import 'package:flutter/material.dart';
import 'package:moneybook/shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';

import '../../../../core/consts/route_consts.dart';

class CategorieListPage extends StatefulWidget {
  const CategorieListPage({super.key});

  @override
  State<CategorieListPage> createState() => _CategorieListPageState();
}

class _CategorieListPageState extends State<CategorieListPage> with TickerProviderStateMixin {
  final int _tabIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategorien'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, createCategorieRoute),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: const Text('Kategorien'),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Moneybook'),
            ),
            ListTile(
              leading: Icon(
                Icons.auto_stories_rounded,
                color: _tabIndex == 0 ? Colors.cyan.shade400 : Colors.white,
              ),
              title: Text(
                'Buchungen',
                style: TextStyle(color: _tabIndex == 0 ? Colors.cyan.shade400 : Colors.white),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: _tabIndex == 0 ? Colors.cyan.shade400 : Colors.white,
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(0));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet_rounded,
                color: _tabIndex == 1 ? Colors.cyan.shade400 : Colors.white,
              ),
              title: Text(
                'Konten',
                style: TextStyle(color: _tabIndex == 1 ? Colors.cyan.shade400 : Colors.white),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: _tabIndex == 1 ? Colors.cyan.shade400 : Colors.white,
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarArguments(1));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.donut_small,
                color: _tabIndex == 2 ? Colors.cyan.shade400 : Colors.white,
              ),
              title: Text(
                'Kategorien',
                style: TextStyle(color: _tabIndex == 2 ? Colors.cyan.shade400 : Colors.white),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: _tabIndex == 2 ? Colors.cyan.shade400 : Colors.white,
              ),
              selected: true,
              onTap: () {
                Navigator.popAndPushNamed(context, categorieListRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
