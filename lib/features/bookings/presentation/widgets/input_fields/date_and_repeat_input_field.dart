import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';

import '../../../../../core/utils/date_formatter.dart';
import '../buttons/list_view_button.dart';
import '../deco/bottom_sheet_header.dart';

class DateAndRepeatInputField extends StatefulWidget {
  final TextEditingController dateController;
  String repetitionType;

  DateAndRepeatInputField({
    super.key,
    required this.dateController,
    required this.repetitionType,
  });

  @override
  State<DateAndRepeatInputField> createState() => _DateAndRepeatInputFieldState();
}

class _DateAndRepeatInputFieldState extends State<DateAndRepeatInputField> {
  openRepeatBottomSheet({required BuildContext context, required String repetitionType}) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: Wrap(
            children: [
              Column(
                children: [
                  const BottomSheetHeader(title: 'Wiederholung auswählen:'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.7,
                    child: SingleChildScrollView(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          ListViewButton(
                            onPressed: () => _setRepetition(context, RepetitionType.noRepetition.name),
                            text: RepetitionType.noRepetition.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => _setRepetition(context, RepetitionType.weekly.name),
                            text: RepetitionType.weekly.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => _setRepetition(context, RepetitionType.twoWeeks.name),
                            text: RepetitionType.twoWeeks.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => _setRepetition(context, RepetitionType.monthly.name),
                            text: RepetitionType.monthly.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => _setRepetition(context, RepetitionType.monthlyBeginning.name),
                            text: RepetitionType.monthlyBeginning.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => _setRepetition(context, RepetitionType.monthlyEnding.name),
                            text: RepetitionType.monthlyEnding.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => _setRepetition(context, RepetitionType.threeMonths.name),
                            text: RepetitionType.threeMonths.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => _setRepetition(context, RepetitionType.sixMonths.name),
                            text: RepetitionType.sixMonths.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => _setRepetition(context, RepetitionType.yearly.name),
                            text: RepetitionType.yearly.name,
                            selectedValue: repetitionType,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _setRepetition(BuildContext context, String newRepetition) {
    setState(() {
      widget.repetitionType = newRepetition;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateController,
      showCursor: false,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: 'Datum',
        counterText: '',
        prefixIcon: const IconTheme(
          data: IconThemeData(color: Colors.grey),
          child: Icon(Icons.calendar_month_rounded),
        ),
        suffixIcon: Column(
          children: [
            IconButton(
              icon: const Icon(Icons.event_repeat_rounded),
              onPressed: () => openRepeatBottomSheet(
                context: context,
                repetitionType: widget.repetitionType,
              ),
              padding: const EdgeInsets.only(top: 6.0),
              constraints: widget.repetitionType == RepetitionType.noRepetition.name ? null : const BoxConstraints(),
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            widget.repetitionType == RepetitionType.noRepetition.name
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 4.0, right: 6.0),
                    child: Text(
                      widget.repetitionType,
                      style: const TextStyle(fontSize: 10.0),
                    ),
                  ),
          ],
        ),
      ),
      onTap: () async {
        final DateTime? parsedDate = await showDatePicker(
          context: context,
          locale: const Locale('de', 'DE'),
          firstDate: DateTime(DateTime.now().year - 10),
          lastDate: DateTime(DateTime.now().year + 100),
        );
        if (parsedDate != null) {
          setState(() {
            widget.dateController.text = dateFormatterDDMMYYYYEE.format(parsedDate);
          });
        }
      },
    );
  }
}