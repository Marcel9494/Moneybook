import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneybook/core/platform/network_info.dart';
import 'package:moneybook/features/bookings/data/datasources/booking_local_data_source.dart';
import 'package:moneybook/features/bookings/data/datasources/booking_remote_data_source.dart';
import 'package:moneybook/features/bookings/data/models/booking_model.dart';
import 'package:moneybook/features/bookings/data/repositories/booking_repository_impl.dart';

class MockRemoteDataSource extends Mock implements BookingRemoteDataSource {}

class MockLocalDataSource extends Mock implements BookingLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

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
      title: 'Edeka einkaufen',
      date: DateTime.now(),
      amount: 20.0,
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
