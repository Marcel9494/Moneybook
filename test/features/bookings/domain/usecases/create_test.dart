import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';
import 'package:moneybook/features/bookings/domain/usecases/create.dart';

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
    title: 'Edeka einkaufen',
    date: DateTime.now(),
    amount: 29.95,
    account: 'Geldbeutel',
    categorie: 'Lebensmittel',
  );

  test(
    'should create a booking',
    () async {
      when(() => mockBookingRepository.create(tBooking)).thenAnswer((_) async => Right(tBooking));
      final result = await usecase.execute(booking: tBooking);
      expect(result, Right(tBooking));
      verify(() => mockBookingRepository.create(tBooking));
      verifyNoMoreInteractions(mockBookingRepository);
    },
  );
}
