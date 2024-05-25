import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.cyanAccent),
    ),
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.cyanAccent.withOpacity(0.14);
          }
          return Colors.transparent;
        },
      ),
    ),
  ),
  datePickerTheme: DatePickerThemeData(
    todayForegroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.black87;
        }
        return Colors.cyanAccent;
      },
    ),
    todayBackgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.cyanAccent;
        }
        return Colors.transparent;
      },
    ),
    dayBackgroundColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.cyanAccent;
        }
        return Colors.transparent;
      },
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.cyanAccent),
    ),
  ),
);
