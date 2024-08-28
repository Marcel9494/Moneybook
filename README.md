# Moneybook
Haushaltsbuch zum Verwalten deiner Finanzen.

# Ziele

- Flutter, Dart, SQL, Datenbanken, Clean Architektur, Design Pattern, Git/Github(-Actions), CI/CD & UI/UX Design Fähigkeiten lernen und verbessern => für späteren Job
- Agile Vorgehensweise verbessern und DDD (Domain Driven Design) und TDD (Test-Driven-Development) lernen => für Job
- Software Projekt für eigenes Portfolio zum Vorzeigen => für mich und späteren Job
- Eigenes Projekt und Side Hustle aufbauen => für mich und späteren Job
- Weiteres Nebeneinkommen generieren => für mich
- Eigene Haushaltsbuch App benutzen die beliebig erweitert werden kann => für andere und mich
- Erste eigene App entwickeln => für später folgende App Projekte

# Vision

Eine Haushaltsbuch App entwickeln die den Benutzern das Verwalten ihrer Finanzen erleichtert und ihnen eine gute Übersicht über ihre Finanzen bietet. Außerdem sollen weitere Features / Lösungen rund um persönliche Finanzen angeboten werden.

# Werte / Prinzipien

- Qualität vor Quantität
- Immer wieder 1% besser
- Keep it simple and stupid (KISS)
- Funktionierender und sehr guter wartbarer, erweiterbarer Code ist das Wichtigste
- Exzellente, moderne UI/UX ist ein Muss
- Schnelle Release-Zyklen realisieren
- Kunden- und eigener Nutzen stehen im Fokus

# Erweiterungen

Folgende Erweiterungen/Features die in späteren Meilensteinen hinzukommen werden müssen bei jedem Issue beachtet werden:

- Die App wird mehrsprachig, beliebig viele Sprachen können hinzukommen
- Unterschiedliche Währungen werden hinzukommen
- Datenbanken / Datenquellen müssen austauschbar sein
- Die App wird responsiv für Smartphones, Tablets und Desktop (Web)
- In der App sollen Interaktionen zwischen Benutzern stattfinden können

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
- Einstellungen (settings)

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

# Datenbank Schema / Aufbau:

Aktuelles Datenbank Schema / Aufbau. Ist noch in der Design & Implementierungsphase wird wahrscheinlich noch erweitert:

Draw.io PNG Datei:

![DatenbankSchemaMoneybook](https://github.com/user-attachments/assets/ac3acca0-25a3-481d-8646-17ab853f4a30)

Vorteile von Fremdschlüsseln bei oben gezeigten Datenbank Schema:
- Wenn Kategorie oder Konto bearbeitet wird, werden die enstsprechenden Daten an einer zentralen Stelle (Categorie oder Account Tabelle) aktualisiert und von den restlichen Tabellen referenziert.
- Bessere Wartbarkeit, wenn später neue Tabellen zum Datenbank Schema hinzukommen, weil dann nicht jede Tabelle aktualisiert werden muss, sondern nur eine.

Nachteile von Fremdschlüsseln bei iben gezeigten Datenbank Schema:
- Daten müssen von mehreren Datenbanktabellen zusammengesucht werden => etwas komplexere SQL-Abfragen.

=> Entscheidung: Fremdschlüssel verwenden, weil das System langfristig so besser wartbar und erweiterbar ist.

=> Entscheidungsänderung: Fremdschlüssel werden vorerst nicht verwendet, weil es zu deutlich komplexeren und unstabileren Code führt.
Erweiterbarkeit und Wartbarkeit ist weiterhin gegeben, weil es lange nicht so viele Datenbanktabellen geben wird.
Weniger einzelne Datenbanktabellen abfragen. Kann später noch umgebaut werden.

# Animationen

Animationen von Lottie: https://lottiefiles.com/de/ benutzen. Premium Abo für einen Monat abschließen, davor Animationen heraussuchen.

Stichworte: finance, money
