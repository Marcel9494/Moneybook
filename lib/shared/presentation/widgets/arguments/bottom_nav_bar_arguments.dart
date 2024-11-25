class BottomNavBarArguments {
  final int tabIndex;
  final int selectedMonth;
  final int selectedYear;

  BottomNavBarArguments({
    required this.tabIndex,
    int? selectedMonth,
    int? selectedYear,
  })  : selectedMonth = selectedMonth ?? DateTime.now().month,
        selectedYear = selectedYear ?? DateTime.now().year; // Assign default if null
}
