import '../../domain/entities/booking.dart';

abstract class BookingRemoteDataSource {
  Future<void> create(Booking booking);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  BookingRemoteDataSourceImpl();

  @override
  Future<void> create(Booking booking) async {
    throw UnimplementedError();
  }
}
