import '../../../../../shared/domain/value_objects/serie_mode_type.dart';
import '../../../domain/entities/budget.dart';

class EditBudgetPageArguments {
  final Budget budget;
  final SerieModeType serieMode;

  EditBudgetPageArguments(
    this.budget,
    this.serieMode,
  );
}
