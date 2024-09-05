import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/route_consts.dart';
import 'package:moneybook/features/accounts/presentation/pages/account_list_page.dart';
import 'package:moneybook/features/bookings/presentation/pages/booking_list_page.dart';
import 'package:moneybook/features/budgets/presentation/pages/budget_list_page.dart';
import 'package:moneybook/features/statistics/presentation/pages/statistic_page.dart';
import 'package:moneybook/shared/presentation/widgets/navigation_widgets/side_menu_drawer_widget.dart';

import '../../../../features/bookings/presentation/widgets/buttons/month_picker_buttons.dart';

class BottomNavBar extends StatefulWidget {
  final int tabIndex;

  const BottomNavBar({
    super.key,
    required this.tabIndex,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {
  late int _tabIndex;
  late TabController _tabController;
  late DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.tabIndex;
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animation!.addListener(_tabListener);
    _tabController.index = widget.tabIndex;
  }

  void _tabListener() {
    if (_tabIndex != _tabController.animation!.value.round()) {
      setState(() {
        _tabIndex = _tabController.animation!.value.round();
      });
    }
  }

  void _onTabChange(int index) {
    setState(() {
      _tabIndex = index;
      _tabController.animateTo(index);
    });
    Navigator.pop(context);
  }

  String _setTitle() {
    switch (_tabIndex) {
      case 0:
        return 'Buchungen';
      case 1:
        return 'Konten';
      case 2:
        return 'Statistiken';
      case 3:
        return 'Budgets';
      case 4:
        return 'Kategorien';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _setTitle(),
          style: const TextStyle(fontSize: 18.0),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        actions: [
          _tabIndex != 1
              ? MonthPickerButtons(
                  selectedDate: _selectedDate,
                  selectedDateCallback: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                )
              : const SizedBox(),
          if (_tabIndex == 1)
            IconButton(
              onPressed: () => Navigator.pushNamed(context, createAccountRoute),
              icon: const Icon(Icons.add_rounded),
            )
          else if (_tabIndex == 3)
            IconButton(
              onPressed: () => Navigator.pushNamed(context, createBudgetRoute),
              icon: const Icon(Icons.add_rounded),
            )
          else
            const SizedBox(),
        ],
      ),
      floatingActionButton: _tabIndex <= 3
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, createBookingRoute),
              shape: const CircleBorder(),
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.cyanAccent, Colors.cyan.shade600],
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            )
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: TabBarView(
        controller: _tabController,
        children: [
          BookingListPage(selectedDate: _selectedDate),
          const AccountListPage(),
          StatisticPage(selectedDate: _selectedDate),
          BudgetListPage(selectedDate: _selectedDate),
        ],
      ),
      bottomNavigationBar: _tabIndex <= 3
          ? BottomAppBar(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 60.0,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _onTabChange(0),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.auto_stories_rounded,
                            size: 24.0,
                            color: _tabIndex == 0 ? Colors.cyan.shade400 : Colors.white70,
                          ),
                          Text(
                            'Buchungen',
                            style: TextStyle(color: _tabIndex == 0 ? Colors.cyan.shade400 : Colors.white70, fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onTabChange(1),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 24.0,
                            color: _tabIndex == 1 ? Colors.cyan.shade400 : Colors.white70,
                          ),
                          Text(
                            'Konten',
                            style: TextStyle(color: _tabIndex == 1 ? Colors.cyan.shade400 : Colors.white70, fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(),
                    const SizedBox(),
                    GestureDetector(
                      onTap: () => _onTabChange(2),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.insights_rounded,
                            size: 24.0,
                            color: _tabIndex == 2 ? Colors.cyan.shade400 : Colors.white70,
                          ), // icon
                          Text(
                            'Statistiken',
                            style: TextStyle(color: _tabIndex == 2 ? Colors.cyan.shade400 : Colors.white70, fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _onTabChange(3),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.savings_rounded,
                            size: 24.0,
                            color: _tabIndex == 3 ? Colors.cyan.shade400 : Colors.white70,
                          ),
                          Text(
                            'Budgets',
                            style: TextStyle(color: _tabIndex == 3 ? Colors.cyan.shade400 : Colors.white70, fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(),
      drawer: SideMenuDrawer(
        tabIndex: _tabIndex,
        onTabChange: (tabIndex) => _onTabChange(tabIndex),
      ),
    );
  }
}
