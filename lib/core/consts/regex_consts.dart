// Regex prüft auf 2 Nachkommastellen z.B.: 12,98 €
// Negative Beträge sind ebenfalls erlaubt z.B. -8,50 €,
// dabei ist das Minus nur an der ersten Position erlaubt.
final moneyRegex = RegExp(r'^-?$|^-?\d+(,\d{0,2})?$');

// Regex gibt String mit nur Zahlen, Kommas und Punkten zurück z.B.: Von 8,65 € auf 8.65
final numberRegex = RegExp(r'[^0-9.,]');
