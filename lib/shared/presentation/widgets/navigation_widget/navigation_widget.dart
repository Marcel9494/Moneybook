import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/route_consts.dart';
import 'package:moneybook/features/accounts/presentation/pages/account_list_page.dart';
import 'package:moneybook/features/bookings/presentation/pages/booking_list_page.dart';
import 'package:moneybook/features/categories/presentation/pages/categorie_list_page.dart';

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
    _tabController = TabController(length: 3, vsync: this);
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

  String _setTitle() {
    switch (_tabIndex) {
      case 0:
        return 'Buchungen';
      case 1:
        return 'Konten';
      case 2:
        return 'Kategorien';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_setTitle()),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        actions: [
          if (_tabIndex == 1)
            IconButton(
              onPressed: () => Navigator.pushNamed(context, createAccountRoute),
              icon: const Icon(Icons.add_rounded),
            )
          else if (_tabIndex == 2)
            IconButton(
              onPressed: () => Navigator.pushNamed(context, createCategorieRoute),
              icon: const Icon(Icons.add_rounded),
            )
          else
            const SizedBox(),
        ],
      ),
      floatingActionButton: _tabIndex == 0 || _tabIndex == 1
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
        children: const [
          BookingListPage(),
          AccountListPage(),
          CategorieListPage(),
        ],
      ),
      bottomNavigationBar: _tabIndex == 0 || _tabIndex == 1
          ? BottomAppBar(
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
            )
          : const SizedBox(),
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
            ListTile(
              leading: Icon(
                Icons.donut_small,
                color: _tabIndex == 2 ? Colors.cyan.shade400 : Colors.white,
              ),
              title: Text(
                'Kategorien',
                style: TextStyle(color: _tabIndex == 2 ? Colors.cyan.shade400 : Colors.white),
              ),
              selected: _tabIndex == 2,
              onTap: () {
                _onTabChange(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
