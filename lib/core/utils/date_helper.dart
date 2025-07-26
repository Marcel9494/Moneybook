class DateHelper {
  static String formatPeriodOfTime(DateTime start, DateTime end) {
    Duration diff = end.difference(start);
    int totalDays = diff.inDays;

    int years = totalDays ~/ 365;
    int remainingDays = totalDays % 365;

    int months = remainingDays ~/ 30;
    remainingDays %= 30;

    int weeks = remainingDays ~/ 7;
    int days = remainingDays % 7;

    List<String> parts = [];

    if (years > 0) parts.add('$years ${years == 1 ? "Jahr" : "Jahre"}');
    if (months > 0) parts.add('$months ${months == 1 ? "Monat" : "Monate"}');
    if (weeks > 0) parts.add('$weeks ${weeks == 1 ? "Woche" : "Wochen"}');
    if (days > 0) parts.add('$days ${days == 1 ? "Tag" : "Tage"}');

    String formattedPeriodOfTime = parts.join(', ');

    return '$formattedPeriodOfTime\n(${totalDays} Tage)';
  }
}
