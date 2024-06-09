import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../core/consts/route_consts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../injection_container.dart';
import '../../../../shared/presentation/widgets/buttons/save_button.dart';
import '../../../../shared/presentation/widgets/input_fields/amount_text_field.dart';
import '../../../../shared/presentation/widgets/input_fields/title_text_field.dart';
import '../../domain/entities/booking.dart';
import '../../domain/value_objects/booking_type.dart';
import '../../domain/value_objects/repetition_type.dart';
import '../bloc/booking_bloc.dart';
import '../widgets/buttons/type_segmented_button.dart';
import '../widgets/input_fields/account_input_field.dart';
import '../widgets/input_fields/categorie_input_field.dart';
import '../widgets/input_fields/date_and_repeat_input_field.dart';

class EditBookingPage extends StatefulWidget {
  final Booking booking;

  const EditBookingPage({
    super.key,
    required this.booking,
  });

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final GlobalKey<FormState> _bookingFormKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final RoundedLoadingButtonController _createBookingBtnController = RoundedLoadingButtonController();
  late RepetitionType _repetitionType;
  late BookingType _bookingType;

  @override
  void initState() {
    super.initState();
    _initializeBooking();
  }

  void _initializeBooking() {
    _dateController.text = dateFormatterDDMMYYYYEE.format(widget.booking.date);
    _titleController.text = widget.booking.title;
    _amountController.text = formatToMoneyAmount(widget.booking.amount.toString());
    _accountController.text = widget.booking.account;
    _categorieController.text = widget.booking.categorie;
    _repetitionType = widget.booking.repetition;
    _bookingType = widget.booking.type;
  }

  void _editBooking(BuildContext context) {}

  void _changeBookingType(Set<BookingType> newBookingType) {
    setState(() {
      _bookingType = newBookingType.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buchung bearbeiten'),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => sl<BookingBloc>(),
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (BuildContext context, BookingState state) {
            if (state is Finished) {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, bottomNavBarRoute);
            }
          },
          builder: (BuildContext context, state) {
            if (state is Initial) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Card(
                    child: Form(
                      key: _bookingFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TypeSegmentedButton(
                            bookingType: _bookingType,
                            onSelectionChanged: (bookingType) => _changeBookingType(bookingType),
                          ),
                          DateAndRepeatInputField(
                            dateController: _dateController,
                            repetitionType: _repetitionType.name,
                          ),
                          TitleTextField(hintText: 'Titel...', titleController: _titleController),
                          AmountTextField(amountController: _amountController),
                          AccountInputField(
                            accountController: _accountController,
                            hintText: _bookingType.name == BookingType.expense.name ? 'Abbuchungskonto...' : 'Konto...',
                          ),
                          CategorieInputField(categorieController: _categorieController),
                          SaveButton(saveBtnController: _createBookingBtnController, onPressed: () => _editBooking(context)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
