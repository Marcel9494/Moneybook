import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/route_consts.dart';
import 'package:moneybook/features/accounts/presentation/pages/account_list_page.dart';
import 'package:moneybook/features/bookings/presentation/pages/booking_list_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation!.addListener(_tabListener);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabIndex == 0 ? 'Buchungen' : 'Konten'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        actions: [
          _tabIndex == 1
              ? IconButton(
                  onPressed: () => Navigator.pushNamed(context, createAccountRoute),
                  icon: const Icon(Icons.add_rounded),
                )
              : const SizedBox(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: TabBarView(
        controller: _tabController,
        children: const [
          BookingListPage(),
          AccountListPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        height: 60.0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () => _onTabChange(0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.auto_stories_rounded,
                        size: _tabIndex == 0 ? 26.0 : 24.0,
                        color: _tabIndex == 0 ? Colors.cyan.shade400 : Colors.white,
                      ),
                      Text(
                        'Buchungen',
                        style: TextStyle(color: _tabIndex == 0 ? Colors.cyan.shade400 : Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _onTabChange(1),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.account_balance_wallet_rounded,
                      size: _tabIndex == 1 ? 26.0 : 24.0,
                      color: _tabIndex == 1 ? Colors.cyan.shade400 : Colors.white,
                    ), // icon
                    Text(
                      'Konten',
                      style: TextStyle(color: _tabIndex == 1 ? Colors.cyan.shade400 : Colors.white),
                    ), // text
                  ],
                ),
              ),
            ],
          ),
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
              selected: _tabIndex == 0,
              onTap: () {
                _onTabChange(0);
                Navigator.pop(context);
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
              selected: _tabIndex == 1,
              onTap: () {
                _onTabChange(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
