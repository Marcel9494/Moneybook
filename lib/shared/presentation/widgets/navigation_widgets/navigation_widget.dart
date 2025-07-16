import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneybook/features/accounts/presentation/pages/account_list_page.dart';
import 'package:moneybook/features/bookings/presentation/pages/booking_list_page.dart';
import 'package:moneybook/features/bookings/presentation/pages/create_booking_page.dart';
import 'package:moneybook/features/budgets/presentation/pages/budget_list_page.dart';
import 'package:moneybook/features/statistics/presentation/pages/statistic_page.dart';
import 'package:moneybook/shared/presentation/widgets/navigation_widgets/side_menu_drawer_widget.dart';

import '../../../../core/utils/app_localizations.dart';
import '../../../../features/bookings/domain/value_objects/amount_type.dart';
import '../../../../features/bookings/domain/value_objects/booking_type.dart';
import '../../../../features/bookings/presentation/bloc/booking_bloc.dart';
import '../../../../features/bookings/presentation/widgets/buttons/month_picker_buttons.dart';

class BottomNavBar extends StatefulWidget {
  final int tabIndex;
  final DateTime selectedDate;
  final BookingType bookingType;
  final AmountType amountType;

  BottomNavBar({
    super.key,
    required this.tabIndex,
    DateTime? selectedDate,
    BookingType? bookingType,
    AmountType? amountType,
  })  : selectedDate = selectedDate ?? DateTime.now(),
        bookingType = bookingType ?? BookingType.expense,
        amountType = amountType ?? AmountType.overallExpense;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin, WidgetsBindingObserver {
  late int _tabIndex;
  late TabController _tabController;
  late DateTime _selectedDate;
  bool _fabAnimationIsFinished = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _tabIndex = widget.tabIndex;
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animation!.addListener(_tabListener);
    _tabController.index = widget.tabIndex;
    WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    super.dispose();
  }

  void _onAppResumed() {
    BlocProvider.of<BookingBloc>(context).add(const HandleAndUpdateNewBookings());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
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
        return AppLocalizations.of(context).translate('buchungen');
      case 1:
        return AppLocalizations.of(context).translate('kontoübersicht');
      case 2:
        return AppLocalizations.of(context).translate('statistiken');
      case 3:
        return AppLocalizations.of(context).translate('budgets');
      case 4:
        return AppLocalizations.of(context).translate('kategorien');
      default:
        return '';
    }
  }

  void _handleOpen(BuildContext context, VoidCallback openContainer) {
    setState(() {
      _fabAnimationIsFinished = false;
    });
    Future.microtask(openContainer);
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
              icon: const Icon(Icons.notes_rounded),
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
        ],
      ),
      floatingActionButton: _tabIndex <= 3
          ? OpenContainer(
              transitionDuration: Duration(milliseconds: 400),
              closedShape: CircleBorder(),
              closedColor: Colors.cyanAccent,
              onClosed: (_) {
                setState(() => _fabAnimationIsFinished = true);
              },
              openBuilder: (context, _) => CreateBookingPage(),
              closedBuilder: (context, openContainer) => FloatingActionButton(
                onPressed: () => _handleOpen(context, openContainer),
                child: AnimatedOpacity(
                  opacity: _fabAnimationIsFinished ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 1300),
                  child: Icon(Icons.add),
                ),
              ),
            )
          : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: TabBarView(
        controller: _tabController,
        children: [
          BookingListPage(selectedDate: _selectedDate),
          const AccountListPage(),
          StatisticPage(
            selectedDate: _selectedDate,
            bookingType: widget.bookingType,
            amountType: widget.amountType,
          ),
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
                            AppLocalizations.of(context).translate('buchungen'),
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
                            AppLocalizations.of(context).translate('konten'),
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
                            AppLocalizations.of(context).translate('statistiken'),
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
                            AppLocalizations.of(context).translate('budgets'),
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
