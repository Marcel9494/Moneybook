// Regex prüft auf 2 Nachkommastellen z.B.: 12,98 €
// Negative Beträge sind ebenfalls erlaubt z.B. -8,50 €,
// dabei ist das Minus nur an der ersten Position erlaubt.
final moneyRegex = RegExp(r'^-?$|^-?\d+(,\d{0,2})?$');
