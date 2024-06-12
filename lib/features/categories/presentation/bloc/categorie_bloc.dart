import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'categorie_event.dart';
part 'categorie_state.dart';

class CategorieBloc extends Bloc<CategorieEvent, CategorieState> {
  CategorieBloc() : super(Initial()) {
    on<CategorieEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
