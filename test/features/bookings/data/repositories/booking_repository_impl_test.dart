import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneybook/core/platform/network_info.dart';
import 'package:moneybook/features/bookings/data/datasources/booking_local_data_source.dart';
import 'package:moneybook/features/bookings/data/datasources/booking_remote_data_source.dart';
import 'package:moneybook/features/bookings/data/models/booking_model.dart';
import 'package:moneybook/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:moneybook/features/bookings/domain/value_objects/booking_type.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';

class MockRemoteDataSource extends Mock implements BookingRemoteDataSource {}

class MockLocalDataSource extends Mock implements BookingLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

// TODO hier weitermachen und erste sinnvolle Teste implementieren zuerst schauen wo anfangen
void main() {
  late BookingRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = BookingRepositoryImpl(
      bookingRemoteDataSource: mockRemoteDataSource,
      bookingLocalDataSource: mockLocalDataSource,
      //networkInfo: mockNetworkInfo,
    );
  });

  group('create Booking', () {
    final BookingModel tBookingModel = BookingModel(
      id: 0,
      type: BookingType.expense,
      title: 'Edeka einkaufen',
      date: DateTime.now(),
      repetition: RepetitionType.noRepetition,
      amount: 25.0,
      currency: '€',
      account: 'Geldbeutel',
      categorie: 'Lebensmittel',
    );
    final tBooking = tBookingModel;

    // TODO Test implementieren
    /*test('should check if booking was created', () async {
      when(mockNetworkInfo.isRemoteApproved).thenAnswer((_) async => true);
      repository.create(tBooking);
      verify(mockNetworkInfo.isRemoteApproved);
    });*/
  });
}
