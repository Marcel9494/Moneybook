import 'package:flutter/material.dart';
import 'package:moneybook/core/consts/route_consts.dart';
import 'package:moneybook/features/accounts/presentation/pages/account_list_page.dart';
import 'package:moneybook/features/bookings/presentation/pages/booking_list_page.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.tabIndex;
    _tabController = TabController(length: 2, vsync: this);
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

  Future<void> _launchInstagramAppIfInstalled({required String url}) async {
    try {
      // Launch the app if installed!
      bool launched = await launchUrl(Uri.parse(url));
      if (launched == false) {
        launchUrl(Uri.parse(url)); // Launch web view if app is not installed!
      }
    } catch (e) {
      launchUrl(Uri.parse(url)); // Launch web view if app is not installed!
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
          _tabIndex == 1
              ? IconButton(
                  onPressed: () => Navigator.pushNamed(context, createAccountRoute),
                  icon: const Icon(Icons.add_rounded),
                )
              : const SizedBox(),
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
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: _tabIndex == 0 ? Colors.cyan.shade400 : Colors.white,
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
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: _tabIndex == 1 ? Colors.cyan.shade400 : Colors.white,
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
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: _tabIndex == 2 ? Colors.cyan.shade400 : Colors.white,
              ),
              selected: _tabIndex == 2,
              onTap: () {
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, categorieListRoute);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.share_rounded,
                color: _tabIndex == 3 ? Colors.cyan.shade400 : Colors.white,
              ),
              title: Text(
                'Folge Moneybook',
                style: TextStyle(color: _tabIndex == 3 ? Colors.cyan.shade400 : Colors.white),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: _tabIndex == 3 ? Colors.cyan.shade400 : Colors.white,
              ),
              selected: _tabIndex == 3,
              onTap: () {
                // TODO richtige URL einfügen, wenn Instagram Seite live ist
                _launchInstagramAppIfInstalled(url: 'https://www.instagram.com/TODO/');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline_rounded,
                color: _tabIndex == 4 ? Colors.cyan.shade400 : Colors.white,
              ),
              title: Text(
                'Über die App',
                style: TextStyle(color: _tabIndex == 4 ? Colors.cyan.shade400 : Colors.white),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: _tabIndex == 4 ? Colors.cyan.shade400 : Colors.white,
              ),
              selected: _tabIndex == 4,
              onTap: () {
                // TODO
              },
            ),
            ListTile(
              leading: Icon(
                Icons.security_rounded,
                color: _tabIndex == 5 ? Colors.cyan.shade400 : Colors.white,
              ),
              title: Text(
                'Impressum',
                style: TextStyle(color: _tabIndex == 5 ? Colors.cyan.shade400 : Colors.white),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: _tabIndex == 5 ? Colors.cyan.shade400 : Colors.white,
              ),
              selected: _tabIndex == 5,
              onTap: () {
                // TODO
              },
            ),
            ListTile(
              leading: Icon(
                Icons.gpp_good_outlined,
                color: _tabIndex == 6 ? Colors.cyan.shade400 : Colors.white,
              ),
              title: Text(
                'Datenschutzerklärung',
                style: TextStyle(color: _tabIndex == 6 ? Colors.cyan.shade400 : Colors.white),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: _tabIndex == 6 ? Colors.cyan.shade400 : Colors.white,
              ),
              selected: _tabIndex == 6,
              onTap: () {
                // TODO
              },
            ),
          ],
        ),
      ),
    );
  }
}
