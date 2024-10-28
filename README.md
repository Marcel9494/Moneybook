# Moneybook
Haushaltsbuch zum Verwalten deiner Finanzen.

# App UI

TODO

# Design Entscheidungen

Es wurde sich für das Clean Architektur Pattern entschieden, weil diese Software Architektur wartbar, testbar, flexibel und erweiterbar ist.
Dies ist für diese Software wichtig, weil die App auch nach dem ersten Release stetig weiter entwickelt werden soll und es neue Funktionalitäten geben wird.

![clean_architecture_uncle_bob](https://github.com/Marcel9494/Moneybook/assets/93829086/dd384c3b-dea6-4c58-9546-b8ecf9c1b728)

## Praktische Umsetzung der Clean Architektur in Flutter (mit Bloc)

![clean_architecture](https://github.com/Marcel9494/Moneybook/assets/93829086/06136010-4228-4092-b341-37451b5d76a2)

Bei der Haushaltsbuch App gibt es aktuell folgende features die jeweils der oben gezeigten Software Architektur folgen:
- Buchungen (bookings)
- Konten (accounts)
- Kategorien (categories)
- Budgets (budgets)
- Statistiken (statistics)
- Benutzer (user)
- Einstellungen (settings)

Die Models im Data Layer wird vorerst nicht so umgesetzt, weil es anfangs nur eine (lokale) Datenquelle gibt und daher die entities im 
Domain Layer reichen. Später wenn eine weitere Datenquelle hinzukommt werden wahrscheinlich die Models mitintegriert in die aktuelle Software Architektur.

# Context View (Level 0)

Aktuelle Context View der Moneybook App mit einer lokalen Sqflite Datenbank Anbindung.

![ContextViewMoneybook](https://github.com/user-attachments/assets/21276d2b-f90f-4028-89b3-bd1e6c31cfbf)

# Lokale Datenbank Entscheidungen

Für lokale Datenspeicherungen wird sqflite (https://pub.dev/packages/sqflite) verwendet werden, weil hier Relationen zwischen verschiedenen Datenbanktabellen realisiert werden können
und diese gut wartbar ist. Durch SQL können die Daten verwaltet und manipuliert werden. Außerdem ist sqflite ein beliebtes Flutter Package mit vielen Likes, Pub Points und hoher Popularität.

# Online Datenbank Entscheidungen

Bisherige Auswahlmöglichkeiten:

1.) Cockroach: https://www.cockroachlabs.com/lp/start-free-database-mc/?utm_source=google&utm_medium=cpc&utm_campaign=g-search-emea-eu-bofu-dev-serv-lp&utm_term=p-free%20database-c&utm_content=lp698001815911&utm_network=g&_bt=698001815911&_bk=free%20database&_bm=p&_bn=g&gad_source=1&gclid=CjwKCAjwgdayBhBQEiwAXhMxttBTbWCEOXgFfWjjxgmpx8aczigHLjJxulRiWyHWuIWqMACkqHa2pxoCJ8sQAvD_BwE

2.) Supabase: https://pub.dev/packages/supabase_flutter
