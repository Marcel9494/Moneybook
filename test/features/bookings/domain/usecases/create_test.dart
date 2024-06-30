import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';
import 'package:moneybook/features/bookings/domain/usecases/create.dart';
import 'package:moneybook/features/bookings/domain/value_objects/booking_type.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late Create usecase;
  late MockBookingRepository mockBookingRepository;

  setUp(() {
    mockBookingRepository = MockBookingRepository();
    usecase = Create(mockBookingRepository);
  });

  final tId = 0;
  final tBooking = Booking(
    id: 0,
    type: BookingType.expense,
    title: 'Edeka einkaufen',
    date: DateTime.now(),
    repetition: RepetitionType.noRepetition,
    amount: 25.0,
    currency: '€',
    fromAccount: 'Geldbeutel',
    toAccount: '',
    categorie: 'Lebensmittel',
  );

  test(
    'should create a booking',
    () async {
      when(() => mockBookingRepository.create(tBooking)).thenAnswer((_) async => Right(tBooking));
      // usecase calls the call method in create.dart
      final result = await usecase(Params(booking: tBooking));
      expect(result, Right(tBooking));
      verify(() => mockBookingRepository.create(tBooking));
      verifyNoMoreInteractions(mockBookingRepository);
    },
  );
}
