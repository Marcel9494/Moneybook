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
        return 'keine_wiederholung';
      case RepetitionType.weekly:
        return 'jede_woche';
      case RepetitionType.twoWeeks:
        return 'alle_zwei_wochen';
      case RepetitionType.monthly:
        return 'jeden_monat';
      case RepetitionType.monthlyBeginning:
        return 'am_monatsanfang';
      case RepetitionType.monthlyEnding:
        return 'am_monatsende';
      case RepetitionType.threeMonths:
        return 'alle_drei_monate';
      case RepetitionType.sixMonths:
        return 'alle_sechs_monate';
      case RepetitionType.yearly:
        return 'jedes_jahr';
    }
  }
}
