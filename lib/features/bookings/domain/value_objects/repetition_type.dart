enum RepetitionType {
  noRepetition,
  weekly,
  twoWeeks,
  monthly,
  monthlyBeginning,
  monthlyEnding,
  threeMonths,
  sixMonths,
  yearly;

  static RepetitionType fromString(String s) => switch (s) {
        'Keine Wiederholung' => RepetitionType.noRepetition,
        'Jede Woche' => RepetitionType.weekly,
        'Alle zwei Wochen' => RepetitionType.twoWeeks,
        'Jeden Monat' => RepetitionType.monthly,
        'Am Monatsanfang' => RepetitionType.monthlyBeginning,
        'Am Monatsende' => RepetitionType.monthlyEnding,
        'Alle drei Monate' => RepetitionType.threeMonths,
        'Alle sechs Monate' => RepetitionType.sixMonths,
        'Jedes Jahr' => RepetitionType.yearly,
        _ => RepetitionType.noRepetition
      };
}

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
