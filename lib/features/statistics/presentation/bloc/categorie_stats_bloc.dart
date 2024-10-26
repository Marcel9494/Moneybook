import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../bookings/domain/entities/booking.dart';
import '../../../bookings/domain/value_objects/amount_type.dart';
import '../../../bookings/domain/value_objects/booking_type.dart';
import '../../domain/entities/categorie_stats.dart';

part 'categorie_stats_event.dart';
part 'categorie_stats_state.dart';

class CategorieStatsBloc extends Bloc<CategorieStatsEvent, CategorieStatsState> {
  CategorieStatsBloc() : super(const CalculatedCategorieStats(categorieStats: [])) {
    on<CategorieStatsEvent>((event, emit) {
      if (event is CalculateCategorieStats) {
        bool categorieFound = false;
        double overallAmount = 0.0;
        List<CategorieStats> categorieStats = [];
        for (int i = 0; i < event.bookings.length; i++) {
          if (event.bookingType == BookingType.investment && event.bookings[i].amountType.name == event.amountType.name) {
            categorieFound = false;
            overallAmount += event.bookings[i].amount;
            for (int j = 0; j < categorieStats.length; j++) {
              if (categorieStats[j].categorie.contains(event.bookings[i].categorie)) {
                categorieStats[j].amount += event.bookings[i].amount;
                categorieFound = true;
                break;
              }
            }
            if (categorieFound == false) {
              CategorieStats newCategorieStat = CategorieStats(
                categorie: event.bookings[i].categorie,
                amount: event.bookings[i].amount,
                percentage: 0.0,
              );
              categorieStats.add(newCategorieStat);
            }
          } else if (event.bookingType == BookingType.expense || event.bookingType == BookingType.income) {
            if (event.bookings[i].type == event.bookingType) {
              categorieFound = false;
              overallAmount += event.bookings[i].amount;
              for (int j = 0; j < categorieStats.length; j++) {
                if (categorieStats[j].categorie.contains(event.bookings[i].categorie)) {
                  categorieStats[j].amount += event.bookings[i].amount;
                  categorieFound = true;
                  break;
                }
              }
              if (categorieFound == false) {
                CategorieStats newCategorieStat = CategorieStats(
                  categorie: event.bookings[i].categorie,
                  amount: event.bookings[i].amount,
                  percentage: 0.0,
                );
                categorieStats.add(newCategorieStat);
              }
            }
          }
          // Für jede Kategorie Prozentwert berechnen
          for (int i = 0; i < categorieStats.length; i++) {
            categorieStats[i].percentage = (categorieStats[i].amount / overallAmount) * 100;
          }
        }
        categorieStats.sort((first, second) => second.percentage.compareTo(first.percentage));
        emit(CalculatedCategorieStats(categorieStats: categorieStats));
      }
    });
  }
}
