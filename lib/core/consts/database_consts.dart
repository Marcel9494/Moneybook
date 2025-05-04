var db;

// Demo Modus für Datenbank
bool demoMode = false;

// Datenbank Name in der alle Datenbank Tabellen enthalten sind
String localDbName = demoMode == false ? 'local_db.db' : 'local_db_demo.db';
String remoteDbName = demoMode == false ? 'remote_db.db' : 'remote_db_demo.db';

// Datenbank Tabellen Namen
String bookingDbName = demoMode == false ? 'bookings' : 'bookings_demo';
String accountDbName = demoMode == false ? 'accounts' : 'accounts_demo';
String categorieDbName = demoMode == false ? 'categories' : 'categories_demo';
String budgetDbName = demoMode == false ? 'budgets' : 'budgets_demo';
String userDbName = demoMode == false ? 'user' : 'user_demo';

// Aktuelle Datenbank Tabellen Version
int localDbVersion = demoMode == false ? 7 : 7;

void switchDemoMode(bool demoMode) {
  localDbName = demoMode == false ? 'local_db.db' : 'local_db_demo.db';
  remoteDbName = demoMode == false ? 'remote_db.db' : 'remote_db_demo.db';

  // Datenbank Tabellen
  bookingDbName = demoMode == false ? 'bookings' : 'bookings_demo';
  accountDbName = demoMode == false ? 'accounts' : 'accounts_demo';
  categorieDbName = demoMode == false ? 'categories' : 'categories_demo';
  budgetDbName = demoMode == false ? 'budgets' : 'budgets_demo';
  userDbName = demoMode == false ? 'user' : 'user_demo';

  localDbVersion = demoMode == false ? 7 : 7;
}
