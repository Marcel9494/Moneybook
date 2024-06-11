import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';
import 'package:moneybook/features/bookings/domain/usecases/create.dart';
import 'package:moneybook/features/bookings/domain/usecases/delete.dart';
import 'package:moneybook/features/bookings/domain/usecases/loadSortedMonthlyBookings.dart';
import 'package:moneybook/features/bookings/domain/value_objects/booking_type.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

Future<void> main() async {
  group('BookingBloc', () {
    late BookingBloc bookingBloc;
    late Create createUsecase;
    late Create editUsecase;
    late Delete deleteUsecase;
    late LoadSortedMonthly loadSortedMonthlyUsecase;
    late MockBookingRepository mockBookingRepository;

    setUp(() {
      mockBookingRepository = MockBookingRepository();
      createUsecase = Create(mockBookingRepository);
      editUsecase = Create(mockBookingRepository);
      deleteUsecase = Delete(mockBookingRepository);
      loadSortedMonthlyUsecase = LoadSortedMonthly(mockBookingRepository);
      bookingBloc = BookingBloc(createUsecase, editUsecase, deleteUsecase, loadSortedMonthlyUsecase);
    });

    Booking tBooking = Booking(
      id: 0,
      type: BookingType.expense,
      title: 'Edeka einkaufen',
      date: DateTime.now(),
      repetition: RepetitionType.noRepetition,
      amount: 29.95,
      currency: '€',
      account: 'Geldbeutel',
      categorie: 'Lebensmittel',
    );

    // TODO hier weitermachen und Tests implementieren
    blocTest(
      'emits when booking is created',
      build: () => bookingBloc,
      act: (bloc) => bloc.add(CreateBooking(tBooking)),
      expect: () => [null],
    );
  });
}
