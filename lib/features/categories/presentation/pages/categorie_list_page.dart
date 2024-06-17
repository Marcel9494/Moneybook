import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/categories/presentation/widgets/categorie_list_view/categorie_list_view.dart';
import 'package:moneybook/shared/presentation/widgets/arguments/bottom_nav_bar_arguments.dart';

import '../../../../core/consts/route_consts.dart';
import '../../domain/value_objects/categorie_type.dart';
import '../bloc/categorie_bloc.dart';

class CategorieListPage extends StatefulWidget {
  const CategorieListPage({super.key});

  @override
  State<CategorieListPage> createState() => _CategorieListPageState();
}

class _CategorieListPageState extends State<CategorieListPage> with TickerProviderStateMixin {
  final int _tabIndex = 2;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: CategorieType.values.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        loadCategories(context, CategorieType.expense);
      } else if (_tabController.index == 1) {
        loadCategories(context, CategorieType.income);
      } else {
        loadCategories(context, CategorieType.investment);
      }
    });
    loadCategories(context, CategorieType.expense);
  }

  void loadCategories(BuildContext context, CategorieType categorieType) {
    BlocProvider.of<CategorieBloc>(context).add(
      LoadCategories(categorieType),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: CategorieType.values.length,
      child: Scaffold(
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
          bottom: TabBar(
            controller: _tabController,
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(text: CategorieType.expense.name),
              Tab(text: CategorieType.income.name),
              Tab(text: CategorieType.investment.name),
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.only(top: 6.0),
          child: TabBarView(
            children: [
              CategorieListView(),
              CategorieListView(),
              CategorieListView(),
            ],
          ),
        ),
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
      ),
    );
  }
}
