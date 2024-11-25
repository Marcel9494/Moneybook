class BottomNavBarArguments {
  final int tabIndex;
  final DateTime selectedDate;

  BottomNavBarArguments({
    required this.tabIndex,
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();
}
