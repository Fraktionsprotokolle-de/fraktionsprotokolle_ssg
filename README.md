# Fraktionsprotokolle - Statische Webseite

Statische Webseite für die digitale Edition »Fraktionen im Deutschen Bundestag 1949-2005« (KGParl).

## Übersicht

Dieses Projekt generiert eine statische HTML-Webseite aus TEI-XML-Quellen der parlamentarischen Fraktionsprotokolle. Die Edition wird veröffentlicht auf [fraktionsprotokolle.de](https://www.fraktionsprotokolle.de).

## Datenquelle

Die XML-Quellen werden aus dem öffentlichen GitHub-Repository bezogen:
- **Repository**: [Fraktionsprotokolle-de/fraktionsprotokolle_web](https://github.com/Fraktionsprotokolle-de/fraktionsprotokolle_web)
- Die XML-Dateien befinden sich im Verzeichnis `xml_quellen/`

### Aktuelle Abdeckung

Die Edition umfasst derzeit Protokolle von:
- **CDU/CSU-Fraktion**: 1.–7. Wahlperiode (1949–1976)
- **SPD-Fraktion**: 1.–8. Wahlperiode (1949–1980)
- **FDP-Fraktion**: 1.–9. Wahlperiode (1949–1983)
- **CSU-Landesgruppe**: 1.–9. Wahlperiode (1949–1983)
- **GRÜNE-Fraktion**: 10.–11. Wahlperiode (1983–1990)

## Projektstruktur

### Hauptverzeichnisse

```
.
├── data/                    # XML-Quelldaten (generiert)
│   ├── editions/           # Fraktionsprotokolle (TEI-XML)
│   ├── indices/            # Normdaten (Personen, Organisationen)
│   └── einleitungen/       # Einleitungstexte
├── html/                   # Generierte HTML-Ausgabe
│   ├── css/               # Stylesheets
│   ├── js/                # JavaScript-Dateien
│   └── js-data/           # Generierte JSON-Daten
├── xslt/                   # XSLT-Transformationen
│   ├── partials/          # XSLT-Teilvorlagen
│   └── statics/           # Statische Seiten-Templates
├── golang/                 # Go-basierte Tools
├── saxon/                  # Saxon XSLT-Prozessor
├── bin/                    # Build-Skripte
├── fetch_data.sh           # Daten-Download-Skript

```

**Wichtige Dateien:**
- **[`fetch_data.sh`](fetch_data.sh)** - Skript zum Herunterladen der XML-Quelldaten
- **[`.env`](.env)** - Konfigurationsdatei (nicht im Repository, muss lokal erstellt werden)

### CSS-Dateien

Die Stylesheets befinden sich im Verzeichnis **[`html/css/`](html/css/)**:

- **[`kgparl.css`](html/css/kgparl.css)** - Haupt-Stylesheet mit allen Projektstilen
- **[`variables.css`](html/css/variables.css)** - CSS-Variablen und Theming

Das Haupt-Stylesheet [`kgparl.css`](html/css/kgparl.css) enthält:
- Layout-Definitionen für Protokollseiten
- Tabellen-Styles (sortierbare Spalten, Hover-Effekte)
- Navigationsleisten und Menüs
- Typografie und Farbschema
- Responsive Breakpoints
- Such- und Filter-Komponenten (InstantSearch)
- Personenregister und Kalenderansichten

### JavaScript-Dateien

Die JavaScript-Dateien befinden sich im Verzeichnis **[`html/js/`](html/js/)**:

#### Hauptskripte

- **[`toc.js`](html/js/toc.js)** - Inhaltsverzeichnis und Protokollliste mit InstantSearch
- **[`einleitungen.js`](html/js/einleitungen.js)** - Einleitungsseiten-Funktionalität
- **[`editions.js`](html/js/editions.js)** - Protokoll-Einzelansicht
- **[`person.js`](html/js/person.js)** - Personendetailseiten
- **[`personenregister.js`](html/js/personenregister.js)** - Personenregister mit Suche
- **[`literaturregister.js`](html/js/literaturregister.js)** - Literaturverzeichnis
- **[`search.js`](html/js/search.js)** - Volltextsuche mit Typesense
- **[`calendar.js`](html/js/calendar.js)** - Kalenderansicht
- **[`index.js`](html/js/index.js)** - Startseite

#### Konfiguration und Hilfsskripte

- **[`config.js`](html/js/config.js)** - Globale Konfiguration und Typesense-Einstellungen
- **[`i18n.js`](html/js/i18n.js)** - Internationalisierung
- **[`ts_update_url.js`](html/js/ts_update_url.js)** - URL-Verwaltung für Suche

#### UI-Komponenten

- **[`popover.js`](html/js/popover.js)** - Popover-Komponenten für Annotationen
- **[`popupinfo.js`](html/js/popupinfo.js)** - Info-Dialoge
- **[`customcheckbox.js`](html/js/customcheckbox.js)** - Custom Checkbox-Komponenten
- **[`one_time_alert.js`](html/js/one_time_alert.js)** - Einmalige Benachrichtigungen

#### Viewer und Visualisierungen

- **[`osd.js`](html/js/osd.js)** - OpenSeadragon-Integration (Bildviewer)
- **[`osd_scroll.js`](html/js/osd_scroll.js)** - Scroll-Synchronisation für Bilder
- **[`osd_single.js`](html/js/osd_single.js)** - Einzelbild-Ansicht
- **[`make_map_and_table.js`](html/js/make_map_and_table.js)** - Karten und Tabellen
- **[`map_table_cfg.js`](html/js/map_table_cfg.js)** - Konfiguration für Karten/Tabellen

#### Sonstige

- **[`run.js`](html/js/run.js)** - Initialisierungsskript
- **[`listStopProp.js`](html/js/listStopProp.js)** - Event-Propagation-Management

#### Generierte Daten

**[`html/js-data/`](html/js-data/)** enthält:
- **[`calendarData.js`](html/js-data/calendarData.js)** - Kalenderdaten für die Kalenderansicht

### XSLT-Transformationen

Die XSLT-Templates befinden sich im Verzeichnis **[`xslt/`](xslt/)**:

#### Haupt-Transformationen

- **[`fraktionsprotokolle.xslt`](xslt/fraktionsprotokolle.xslt)** - Haupttransformationsdatei
- **[`editions.xsl`](xslt/editions.xsl)** - Protokoll-Einzelseiten
- **[`liste.xsl`](xslt/liste.xsl)** - Protokollliste/Inhaltsverzeichnis
- **[`einleitungen.xsl`](xslt/einleitungen.xsl)** - Einleitungsseiten
- **[`index.xsl`](xslt/index.xsl)** - Startseite
- **[`search.xsl`](xslt/search.xsl)** - Suchseite
- **[`kalender.xsl`](xslt/kalender.xsl)** - Kalenderansicht

#### Register und Verzeichnisse

- **[`listperson.xsl`](xslt/listperson.xsl)** - Personenregister
- **[`listliterature.xsl`](xslt/listliterature.xsl)** - Literaturverzeichnis
- **[`listplace.xsl`](xslt/listplace.xsl)** - Ortsregister
- **[`listorg.xsl`](xslt/listorg.xsl)** - Organisationsverzeichnis

#### Metadaten und statische Seiten

- **[`meta.xsl`](xslt/meta.xsl)** - Metadaten-Seiten
- **[`imprint.xsl`](xslt/imprint.xsl)** - Impressum
- **[`beacon.xsl`](xslt/beacon.xsl)** - BEACON-Dateien für Normdaten
- **[`404.xsl`](xslt/404.xsl)** - Fehlerseite
- **[`statics/markdown.xsl`](xslt/statics/markdown.xsl)** - Markdown-zu-HTML-Konverter

#### Teilvorlagen ([`xslt/partials/`](xslt/partials/))

- **[`html_head.xsl`](xslt/partials/html_head.xsl)** - HTML-Head-Bereich
- **[`html_navbar.xsl`](xslt/partials/html_navbar.xsl)** - Navigationsleiste
- **[`html_navbar_no_translations.xsl`](xslt/partials/html_navbar_no_translations.xsl)** - Navbar ohne Sprachauswahl
- **[`html_footer.xsl`](xslt/partials/html_footer.xsl)** - Footer-Bereich
- **[`shared.xsl`](xslt/partials/shared.xsl)** - Gemeinsame Templates und Funktionen
- **[`params.xsl`](xslt/partials/params.xsl)** - Globale Parameter

##### Entity-Templates

- **[`person.xsl`](xslt/partials/person.xsl)** - Personen-Markup
- **[`org.xsl`](xslt/partials/org.xsl)** - Organisations-Markup
- **[`place.xsl`](xslt/partials/place.xsl)** - Orts-Markup
- **[`bibl.xsl`](xslt/partials/bibl.xsl)** - Bibliografische Referenzen

##### UI-Komponenten

- **[`osd-container.xsl`](xslt/partials/osd-container.xsl)** - OpenSeadragon-Container
- **[`aot-options.xsl`](xslt/partials/aot-options.xsl)** - Annotierungs-Optionen
- **[`one_time_alert.xsl`](xslt/partials/one_time_alert.xsl)** - Alert-Komponenten
- **[`tabulator_js.xsl`](xslt/partials/tabulator_js.xsl)** - Tabulator-Integration
- **[`tabulator_dl_buttons.xsl`](xslt/partials/tabulator_dl_buttons.xsl)** - Download-Buttons für Tabellen

## Build-System

Das Projekt verwendet [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter) als Build-Framework mit Apache Ant als Build-Tool.

### Voraussetzungen

- **Java** (für Saxon XSLT-Prozessor und Apache Ant)
- **Python 3.12+** (für Indexierung und Datenverarbeitung)
- **Go** (für zusätzliche Build-Tools)
- **Node.js** (für JavaScript-Dependencies)

### Installation

1. **Repository klonen**
   ```bash
   git clone https://github.com/Fraktionsprotokolle-de/fraktionsprotokolle_web.git
   cd fraktionsprotokolle_web
   ```

2. **Umgebungsvariablen konfigurieren**

   Erstellen Sie eine `.env`-Datei mit folgenden Variablen:
   ```env
   # GitHub Repository (falls privates Repository verwendet wird)
   TOKEN=ihr_github_token
   REPO=Fraktionsprotokolle-de/fraktionsprotokolle_web
   GITHUB_API_ENDPOINT=https://api.github.com

   # Typesense-Konfiguration (Suchfunktion)
   TYPESENSE_API_KEY=ihr_api_key
   TYPESENSE_SEARCH_KEY=ihr_search_key
   TYPESENSE_HOST=ihre.typesense.domain
   TYPESENSE_PORT=8108
   TYPESENSE_PROTOCOL=https
   TYPESENSE_TIMEOUT=120

   # Deployment (optional)
   REMOTE_HOST=ihr.server.de
   REMOTE_USER=username
   REMOTE_PATH=/pfad/zur/installation
   LOCAL_PATH=./html
   ```

3. **Dependencies installieren**
   ```bash
   npm install
   pip install -r requirements.txt
   ```

## Build-Prozess

### 1. Daten herunterladen

```bash
./fetch_data.sh
```

Das Skript [`fetch_data.sh`](fetch_data.sh):
- Lädt die XML-Quelldaten aus dem GitHub-Repository
- Extrahiert Fraktionsprotokolle nach [`data/editions/`](data/editions/)
- Extrahiert Normdaten nach [`data/indices/`](data/indices/)
- Extrahiert Einleitungen nach [`data/einleitungen/`](data/einleitungen/)

**Hinweis:** Falls ein Authentifizierungsfehler (HTTP 401) auftritt, muss ein gültiger GitHub Personal Access Token in der [`.env`](.env)-Datei konfiguriert werden. Token können hier erstellt werden: https://github.com/settings/tokens

### 2. HTML generieren

```bash
ant
```

Das Ant-Build-Skript führt folgende Schritte aus:
- XSLT-Transformationen der XML-Dateien nach HTML
- Generierung von Registern und Verzeichnissen
- Erstellung der statischen Seiten
- Kopieren von Assets (CSS, JS, Bilder)

### 3. Suchindex erstellen

Der Suchindex für Typesense wird in mehreren Schritten erstellt:

```bash
# Go-Tool ausführen (optional, falls vorhanden)
go run ./golang/main.go

# Hauptindex erstellen
python3 ./make_ts_index.py

# Literaturindex erstellen
python3 ./make_ts_index_literature.py

# Kalenderdaten generieren
python3 ./make_calendar_date.py

# Personenindex erstellen
python3 ./person_index.py
```

**Verwendete Skripte:**
- **[`golang/main.go`](golang/main.go)** - Go-basierte Datenverarbeitung
- **[`make_ts_index.py`](make_ts_index.py)** - Hauptindex für Protokolle
- **[`make_ts_index_literature.py`](make_ts_index_literature.py)** - Literaturindex
- **[`make_calendar_date.py`](make_calendar_date.py)** - Kalenderdaten-Generator
- **[`person_index.py`](person_index.py)** - Personenindex

Diese Skripte erfordern gültige Typesense-Konfiguration in der [`.env`](.env)-Datei.

### 4. Zotero-Daten herunterladen (optional)

```bash
python3 ./download_zotero.py
```

Das Skript **[`download_zotero.py`](download_zotero.py)** lädt bibliografische Daten aus Zotero für das Literaturverzeichnis.

## Entwicklung

### CSS-Entwicklung

Das Haupt-Stylesheet [`html/css/kgparl.css`](html/css/kgparl.css) kann direkt bearbeitet werden. Für Produktionsbuilds kann die bereinigte Version mit [`purge-css.js`](purge-css.js) erstellt werden:

```bash
node purge-css.js
```

Dies erstellt [`kgparl.purged.css`](html/css/kgparl.purged.css) mit entfernten ungenutzten CSS-Regeln.

### XSLT-Entwicklung

XSLT-Templates befinden sich in [`xslt/`](xslt/). Nach Änderungen muss `ant` erneut ausgeführt werden, um die HTML-Dateien neu zu generieren.

### JavaScript-Entwicklung

JavaScript-Dateien in [`html/js/`](html/js/) werden direkt in die HTML-Seiten eingebunden. Änderungen sind nach Reload der Seite sichtbar.

## Deployment

Die generierten HTML-Dateien befinden sich im Verzeichnis [`html/`](html/) und können auf einen Webserver deployed werden. Für automatisiertes Deployment können die Variablen `REMOTE_HOST`, `REMOTE_USER` und `REMOTE_PATH` in [`.env`](.env) konfiguriert werden.

## Kontakt

- **Website**: https://www.fraktionsprotokolle.de
- **E-Mail**: info@fraktionsprotokolle.de
- **GitHub Issues**: https://github.com/Fraktionsprotokolle-de/fraktionsprotokolle_web/issues

## Technischer Stack

- **Build-System**: Apache Ant, DSE-Static-Cookiecutter
- **XSLT-Prozessor**: Saxon
- **Suchengine**: Typesense mit InstantSearch.js
- **Frontend-Frameworks**:
  - Bootstrap 5
  - InstantSearch.js
  - OpenSeadragon (Bildviewer)
  - Tabulator (Tabellen)
- **Backend-Sprachen**:
  - Python (Indexierung, Datenverarbeitung)
  - Go (Build-Tools)
  - Shell (Build-Skripte)

## Lizenz

Dieses Projekt basiert teilweise auf dse-static-cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter) des Austrian Centre for Digital Humanities and Cultural Heritage (ACDH-CH). Der entsprechende Code steht unter der MIT License. Details finden sich in der Datei `LICENSE`.

Bitte beachten Sie, dass diese Lizenz **nicht** für etwaige im Projekt enthaltene Drittsoftware gilt, insbesondere für Saxon sowie CSS- und JavaScript-Bibliotheken. Für diese Komponenten gelten die jeweiligen Lizenzbedingungen der ursprünglichen Anbieter.
