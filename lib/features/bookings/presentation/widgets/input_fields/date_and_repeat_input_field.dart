import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:moneybook/features/bookings/domain/value_objects/repetition_type.dart';

import '../../../../../core/utils/date_formatter.dart';
import '../../../../../shared/presentation/widgets/deco/bottom_sheet_header.dart';
import '../buttons/list_view_button.dart';

class DateAndRepeatInputField extends StatefulWidget {
  final TextEditingController dateController;
  String repetitionType;
  Function onSelectionChanged;
  bool showRepetition;

  DateAndRepeatInputField({
    super.key,
    required this.dateController,
    required this.repetitionType,
    required this.onSelectionChanged,
    this.showRepetition = true,
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
      decoration: InputDecoration(
        hintText: 'Datum...',
        counterText: '',
        prefixIcon: const IconTheme(
          data: IconThemeData(color: Colors.grey),
          child: Icon(Icons.calendar_month_rounded),
        ),
        suffixIcon: widget.showRepetition
            ? Column(
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
              )
            : const SizedBox(),
      ),
      onTap: widget.showRepetition
          ? () async {
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
            }
          : () => {},
    );
  }
}
