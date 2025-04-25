const bool adminMode = false;
String locale = 'de-DE';
const String singleLocale = 'de';
const String currencyLocale = '€';

// Anmerkung: \ bei $ wird benötigt, weil $ ein spezieller Character in Dart ist und
// normalerweise für String interpolation (z.B.: "$variable") verwendet wird.
const List<String> currencySymbols = ['€', '\$'];

const int durationInMs = 800;
const int animationDurationInMs = 650;
const int budgetAnimationDurationInMs = 1600;
const int flushbarDurationInMs = 4500;
const int barChartDurationInMs = 500;

// Für wieviele Jahre soll eine Serienbuchung standardmäßig erstellt werden
const int serieYears = 3;
// Für wieviele Jahre soll ein Budget standardmäßig erstellt werden
const int budgetYears = 5;
