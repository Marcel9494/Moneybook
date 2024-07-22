part of 'categorie_stats_bloc.dart';

sealed class CategorieStatsState extends Equatable {
  const CategorieStatsState();
}

final class CalculatedCategorieStats extends CategorieStatsState {
  final List<CategorieStats> categorieStats;

  const CalculatedCategorieStats({required this.categorieStats});

  @override
  List<Object> get props => [categorieStats];
}
