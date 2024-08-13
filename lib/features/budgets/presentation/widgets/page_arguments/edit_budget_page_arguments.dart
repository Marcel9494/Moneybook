import '../../../../../shared/domain/value_objects/edit_mode_type.dart';
import '../../../domain/entities/budget.dart';

class EditBudgetPageArguments {
  final Budget budget;
  final EditModeType editMode;

  EditBudgetPageArguments(
    this.budget,
    this.editMode,
  );
}
