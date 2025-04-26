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

  static RepetitionType fromString(String s) => switch (s.toLowerCase()) {
        'keine_wiederholung' || 'keine wiederholung' => RepetitionType.noRepetition,
        'jede_woche' || 'jede woche' => RepetitionType.weekly,
        'alle_zwei_wochen' || 'alle zwei wochen' => RepetitionType.twoWeeks,
        'jeden_monat' || 'jeden monat' => RepetitionType.monthly,
        'am_monatsanfang' || 'am monatsanfang' => RepetitionType.monthlyBeginning,
        'am_monatsende' || 'am monatsende' => RepetitionType.monthlyEnding,
        'alle_drei_monate' || 'alle drei monate' => RepetitionType.threeMonths,
        'alle_sechs_monate' || 'alle sechs monate' => RepetitionType.sixMonths,
        'jedes_jahr' || 'jedes jahr' => RepetitionType.yearly,
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
