var db;

// Demo Modus für Datenbank
const bool demoMode = false;

// Datenbank Name in der alle Datenbank Tabellen enthalten sind
const String localDbName = demoMode == false ? 'local_db.db' : 'local_db_demo.db';
const String remoteDbName = demoMode == false ? 'remote_db.db' : 'remote_db_demo.db';

// Datenbank Tabellen Namen
const String bookingDbName = demoMode == false ? 'bookings' : 'bookings_demo';
const String accountDbName = demoMode == false ? 'accounts' : 'accounts_demo';
const String categorieDbName = demoMode == false ? 'categories' : 'categories_demo';
const String budgetDbName = demoMode == false ? 'budgets' : 'budgets_demo';

// Aktuelle Datenbank Tabellen Version
const int localDbVersion = demoMode == false ? 1 : 1;
