var db;

// Demo Modus für Datenbank
bool demoMode = false;

// Datenbank Name in der alle Datenbank Tabellen enthalten sind
final String localDbName = demoMode == false ? 'local_db.db' : 'local_db_demo.db';
final String remoteDbName = demoMode == false ? 'remote_db.db' : 'remote_db_demo.db';

// Datenbank Tabellen Namen
final String bookingDbName = demoMode == false ? 'bookings' : 'bookings_demo';
final String accountDbName = demoMode == false ? 'accounts' : 'accounts_demo';
final String categorieDbName = demoMode == false ? 'categories' : 'categories_demo';
final String budgetDbName = demoMode == false ? 'budgets' : 'budgets_demo';
final String userDbName = demoMode == false ? 'user' : 'user_demo';

// Aktuelle Datenbank Tabellen Version
final int localDbVersion = demoMode == false ? 1 : 1;
