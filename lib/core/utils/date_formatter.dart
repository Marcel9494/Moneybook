import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Hilfsklasse um Datumsformate zu definieren und diese auf verschiedene
/// Sprachen anzuzeigen, über die global gesetzte App Sprache in main.dart (locale).
class DateFormatter {
  /// Format: 01.03.2025 (Sa) oder 01/03/2025 (Sat)
  static String dateFormatDDMMYYYYEEDateTime(DateTime date, BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    String datePattern = '';
    switch (currentLocale) {
      case 'de':
        datePattern = 'dd.MM.yyyy (EE)';
        break;
      case 'en':
        datePattern = 'MM/dd/yyyy (EE)';
        break;
      default:
        datePattern = 'MM/dd/yyyy (EE)';
    }
    return DateFormat(datePattern, currentLocale).format(date);
  }

  static DateTime dateFormatDDMMYYYYEEString(String date, BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    String datePattern = '';
    switch (currentLocale) {
      case 'de':
        datePattern = 'dd.MM.yyyy (EE)';
        break;
      case 'en':
        datePattern = 'MM/dd/yyyy (EE)';
        break;
      default:
        datePattern = 'MM/dd/yyyy (EE)';
    }
    return DateFormat(datePattern, currentLocale).parse(date);
  }

  /// Format: Sa 01.
  static String dateFormatEEDD(DateTime date, BuildContext context) {
    final currentLocale = Localizations.localeOf(context).toString();
    return DateFormat('EE dd.', currentLocale).format(date);
  }

  /// Format: 03.2025
  static String dateFormatMMYYYY(DateTime date, BuildContext context) {
    final currentLocale = Localizations.localeOf(context).toString();
    return DateFormat('MM.yyyy', currentLocale).format(date);
  }

  /// Format: März 2025
  static String dateFormatMMMYYYY(DateTime date, BuildContext context) {
    final currentLocale = Localizations.localeOf(context).toString();
    return DateFormat('MMM yyyy', currentLocale).format(date);
  }

  /// Format: Mär (abgekürzter Monat)
  static String dateFormatMMM(DateTime date, BuildContext context) {
    final currentLocale = Localizations.localeOf(context).toString();
    return DateFormat('MMM', currentLocale).format(date);
  }

  /// Format: März (vollständig ausgeschriebener Monat)
  static String dateFormatMMMM(DateTime date, BuildContext context) {
    final currentLocale = Localizations.localeOf(context).toString();
    return DateFormat('MMMM', currentLocale).format(date);
  }

  /// Format: 25 März (vollständig ausgeschriebener Monat)
  static String dateFormatYMMMM(DateTime date, BuildContext context) {
    final currentLocale = Localizations.localeOf(context).toString();
    return DateFormat('y MMMM', currentLocale).format(date);
  }

  /// Format: März 2025 (vollständig ausgeschriebener Monat)
  static String dateFormatMMMMYYYY(DateTime date, BuildContext context) {
    final currentLocale = Localizations.localeOf(context).toString();
    return DateFormat('MMMM yyyy', currentLocale).format(date);
  }
}

final DateFormat dateFormatterYYYYMMDD = DateFormat('yyyy-MM-dd'); // Datumsformat für Datenbank Abspeicherung
