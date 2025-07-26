enum GoalType {
  none,
  spendingGoal,
  savingsGoal;

  static GoalType fromString(String s) => switch (s) {
        '' => GoalType.none,
        'Ausgabe' || 'ausgabe' => GoalType.spendingGoal,
        'Einnahme' || 'einnahme' => GoalType.savingsGoal,
        _ => GoalType.savingsGoal
      };
}

extension GoalTypeExtension on GoalType {
  String get name {
    switch (this) {
      case GoalType.none:
        return '';
      case GoalType.spendingGoal:
        return 'Ausgabenziel';
      case GoalType.savingsGoal:
        return 'Sparziel';
    }
  }
}
