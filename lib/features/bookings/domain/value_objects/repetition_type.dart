enum RepetitionType { noRepetition, weekly, twoWeeks, monthly, monthlyBeginning, monthlyEnding, threeMonths, sixMonths, yearly }

extension RepetitionTypeExtension on RepetitionType {
  String get name {
    switch (this) {
      case RepetitionType.noRepetition:
        return 'Keine Wiederholung';
      case RepetitionType.weekly:
        return 'Jede Woche';
      case RepetitionType.twoWeeks:
        return 'Alle zwei Wochen';
      case RepetitionType.monthly:
        return 'Jeden Monat';
      case RepetitionType.monthlyBeginning:
        return 'Am Monatsanfang';
      case RepetitionType.monthlyEnding:
        return 'Am Monatsende';
      case RepetitionType.threeMonths:
        return 'Alle drei Monate';
      case RepetitionType.sixMonths:
        return 'Alle sechs Monate';
      case RepetitionType.yearly:
        return 'Jedes Jahr';
      default:
        throw Exception('$name is not a valid Repetition type.');
    }
  }
}
