import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF1c1b20),
  cardTheme: CardTheme(
    color: Color(0xBB27292f),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black54,
    elevation: 4.0,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.cyanAccent),
    ),
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.cyanAccent.withOpacity(0.14);
          }
          return Colors.transparent;
        },
      ),
      iconColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.cyanAccent;
        }
        return Colors.white70;
      }),
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
    confirmButtonStyle: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          return Colors.cyanAccent;
        },
      ),
    ),
    cancelButtonStyle: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          return Colors.grey;
        },
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.cyanAccent),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.cyanAccent),
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.cyanAccent,
    selectionHandleColor: Colors.cyanAccent,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.cyanAccent,
    foregroundColor: Colors.black87,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.cyanAccent,
    indicatorColor: Colors.cyanAccent,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.cyanAccent,
  ),
);
