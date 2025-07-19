import '../../domain/entities/goal.dart';

abstract class GoalLocalDataSource {
  Future<void> create(Goal goal);
  Future<void> update(Goal goal);
  Future<void> delete(int id);
  Future<Goal> load(int id);
  Future<List<Goal>> loadAll();
}
