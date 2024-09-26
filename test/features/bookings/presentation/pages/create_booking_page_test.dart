import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneybook/features/bookings/domain/entities/booking.dart';
import 'package:moneybook/features/bookings/domain/repositories/booking_repository.dart';
import 'package:moneybook/features/bookings/domain/usecases/check_for_new_bookings.dart';
import 'package:moneybook/features/bookings/domain/usecases/create.dart';
import 'package:moneybook/features/bookings/domain/usecases/delete.dart';
import 'package:moneybook/features/bookings/domain/usecases/edit.dart';
import 'package:moneybook/features/bookings/domain/usecases/load_categorie_bookings.dart';
import 'package:moneybook/features/bookings/domain/usecases/load_new_bookings.dart';
import 'package:moneybook/features/bookings/domain/usecases/load_sorted_monthly_bookings.dart';
import 'package:moneybook/features/bookings/domain/usecases/update_all_bookings_with_account.dart';
import 'package:moneybook/features/bookings/domain/usecases/update_all_bookings_with_categorie.dart';
import 'package:moneybook/features/bookings/domain/value_objects/booking_type.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';
import 'package:moneybook/features/bookings/presentation/bloc/booking_bloc.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

Future<void> main() async {
  group('BookingBloc', () {
    late BookingBloc bookingBloc;
    late Create createUsecase;
    late Edit editUsecase;
    late Delete deleteUsecase;
    late LoadSortedMonthly loadSortedMonthlyUsecase;
    late LoadAllCategorieBookings loadCategorieBookingsUseCase;
    late LoadNewBookings loadNewBookingsUseCase;
    late UpdateAllBookingsWithCategorie updateAllBookingsWithCategorieUseCase;
    late UpdateAllBookingsWithAccount updateAllBookingsWithAccountUseCase;
    late CheckForNewBookings checkNewBookingsUseCase;
    late MockBookingRepository mockBookingRepository;

    setUp(() {
      mockBookingRepository = MockBookingRepository();
      createUsecase = Create(mockBookingRepository);
      editUsecase = Edit(mockBookingRepository);
      deleteUsecase = Delete(mockBookingRepository);
      loadSortedMonthlyUsecase = LoadSortedMonthly(mockBookingRepository);
      loadCategorieBookingsUseCase = LoadAllCategorieBookings(mockBookingRepository);
      loadNewBookingsUseCase = LoadNewBookings(mockBookingRepository);
      updateAllBookingsWithCategorieUseCase = UpdateAllBookingsWithCategorie(mockBookingRepository);
      updateAllBookingsWithAccountUseCase = UpdateAllBookingsWithAccount(mockBookingRepository);
      checkNewBookingsUseCase = CheckForNewBookings(mockBookingRepository);
      bookingBloc = BookingBloc(
        createUsecase,
        editUsecase,
        deleteUsecase,
        loadSortedMonthlyUsecase,
        loadCategorieBookingsUseCase,
        updateAllBookingsWithCategorieUseCase,
        updateAllBookingsWithAccountUseCase,
        checkNewBookingsUseCase,
        loadNewBookingsUseCase,
      );
    });

    Booking tBooking = Booking(
      id: 0,
      type: BookingType.expense,
      title: 'Edeka einkaufen',
      date: DateTime.now(),
      repetition: RepetitionType.noRepetition,
      amount: 29.95,
      currency: '€',
      fromAccount: 'Geldbeutel',
      toAccount: '',
      categorie: 'Lebensmittel',
      isBooked: true,
    );

    // TODO hier weitermachen ist es überhaupt nützlich auf dieser Ebene Tests einzubauen?
    /*blocTest(
      'emits when booking is created',
      build: () => bookingBloc,
      act: (bloc) => bloc.add(CreateBooking(tBooking)),
      expect: () => [],
    );*/
  });
}
