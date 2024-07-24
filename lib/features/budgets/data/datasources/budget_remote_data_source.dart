import '../../domain/entities/budget.dart';

abstract class BudgetRemoteDataSource {
  Future<void> create(Budget budget);
}

class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  BudgetRemoteDataSourceImpl();

  @override
  Future<void> create(Budget budget) async {
    throw UnimplementedError();
  }
}
