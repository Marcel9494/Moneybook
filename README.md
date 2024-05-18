# Moneybook
Haushaltsbuch zum Verwalten deiner Finanzen.

# Ziele

- Flutter, Dart, Clean Architektur, Design Pattern, Git/Github(-Actions), CI/CD & UI/UX Design Fähigkeiten lernen und verbessern.
- Agile Vorgehensweise verbessern und TDD (Test-Driven-Development) lernen.
- Software Projekt für eigenes Portfolio zum Vorzeigen.
- Eigenes kleines Projekt und Side Hustle aufbauen.
- Weiteres Nebeneinkommen generieren.
- Eigene Haushaltsbuch App benutzen die beliebig erweitert werden kann.

# Werte / Prinzipien

- Qualität vor Quantität
- Immer wieder 1% besser
- Keep it simple and stupid (KISS)
- Funktionierender und sehr gut wartbarer, erweiterbarer Code ist das Wichtigste
- Exzellente, moderne UI/UX ist ein Muss
- Schnelle Release-Zyklen realisieren

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
- Einstellungen (settings)
