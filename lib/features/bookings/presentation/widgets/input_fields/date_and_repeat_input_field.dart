import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';

import '../../../../../core/utils/app_localizations.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
import '../buttons/list_view_button.dart';

class DateAndRepeatInputField extends StatefulWidget {
  final TextEditingController dateController;
  String repetitionType;
  Function onSelectionChanged;
  bool activateRepetition;
  bool activateDatePicker;

  DateAndRepeatInputField({
    super.key,
    required this.dateController,
    required this.repetitionType,
    required this.onSelectionChanged,
    this.activateRepetition = true,
    this.activateDatePicker = true,
  });

  @override
  State<DateAndRepeatInputField> createState() => _DateAndRepeatInputFieldState();
}

class _DateAndRepeatInputFieldState extends State<DateAndRepeatInputField> {
  openRepeatBottomSheet({required BuildContext context, required String repetitionType}) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      backgroundColor: Color(0xFF1c1b20),
      builder: (BuildContext context) {
        return Material(
          color: Color(0xFF1c1b20),
          child: Wrap(
            children: [
              Column(
                children: [
                  BottomSheetHeader(title: AppLocalizations.of(context).translate('wiederholung_auswählen') + ':'),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.7,
                    child: SingleChildScrollView(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        children: <Widget>[
                          ListViewButton(
                            onPressed: () => widget.onSelectionChanged(RepetitionType.noRepetition),
                            text: RepetitionType.noRepetition.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => widget.onSelectionChanged(RepetitionType.weekly),
                            text: RepetitionType.weekly.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => widget.onSelectionChanged(RepetitionType.twoWeeks),
                            text: RepetitionType.twoWeeks.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => widget.onSelectionChanged(RepetitionType.monthly),
                            text: RepetitionType.monthly.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => widget.onSelectionChanged(RepetitionType.monthlyBeginning),
                            text: RepetitionType.monthlyBeginning.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => widget.onSelectionChanged(RepetitionType.monthlyEnding),
                            text: RepetitionType.monthlyEnding.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => widget.onSelectionChanged(RepetitionType.threeMonths),
                            text: RepetitionType.threeMonths.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => widget.onSelectionChanged(RepetitionType.sixMonths),
                            text: RepetitionType.sixMonths.name,
                            selectedValue: repetitionType,
                          ),
                          ListViewButton(
                            onPressed: () => widget.onSelectionChanged(RepetitionType.yearly),
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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateController,
      showCursor: false,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        color: widget.activateDatePicker ? Colors.white : Colors.grey,
      ),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).translate('datum') + '...',
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.activateDatePicker ? Colors.cyanAccent : Colors.grey),
        ),
        prefixIcon: const IconTheme(
          data: IconThemeData(color: Colors.grey),
          child: Icon(Icons.calendar_month_rounded),
        ),
        suffixIcon: Column(
          children: [
            IconButton(
              icon: Icon(Icons.event_repeat_rounded, color: widget.activateRepetition ? Colors.grey.shade300 : Colors.grey),
              onPressed: widget.activateRepetition
                  ? () => openRepeatBottomSheet(
                        context: context,
                        repetitionType: widget.repetitionType,
                      )
                  : () => {},
              padding: const EdgeInsets.only(top: 6.0),
              constraints: widget.repetitionType == RepetitionType.noRepetition.name ? null : const BoxConstraints(),
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              splashColor: widget.activateRepetition ? Colors.grey.shade800 : Colors.transparent,
              highlightColor: widget.activateRepetition ? Colors.grey.shade800 : Colors.transparent,
            ),
            widget.repetitionType == RepetitionType.noRepetition.name
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 4.0, right: 6.0),
                    child: Text(
                      AppLocalizations.of(context).translate(widget.repetitionType),
                      style: TextStyle(fontSize: 10.0, color: widget.activateRepetition ? Colors.grey.shade300 : Colors.grey),
                    ),
                  ),
          ],
        ),
      ),
      onTap: widget.activateDatePicker
          ? () async {
              final DateTime? parsedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(2014),
                lastDate: DateTime(DateTime.now().year + 100),
              );
              if (parsedDate != null) {
                setState(() {
                  widget.dateController.text =
                      DateFormatter.dateFormatDDMMYYYYEEDateTime(parsedDate, context); // dateFormatterDDMMYYYYEE.format(parsedDate);
                });
              }
            }
          : () => {},
    );
  }
}
