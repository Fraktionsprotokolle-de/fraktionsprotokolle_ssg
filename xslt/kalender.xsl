<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes" />

    <xsl:import href="partials/html_navbar.xsl" />
    <xsl:import href="partials/html_head.xsl" />
    <xsl:import href="partials/html_footer.xsl" />
    <!--<xsl:import
    href="partials/tabulator_dl_buttons.xsl" />
    <xsl:import href="partials/tabulator_js.xsl" />-->


    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Kalender'" />
        <html class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <script src="https://code.jquery.com/jquery-3.6.3.min.js"
                    integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
                    crossorigin="anonymous"></script>
                <link
                    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
                    rel="stylesheet"
                    integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
                    crossorigin="anonymous" />
                <link rel="stylesheet" type="text/css"
                    href="https://unpkg.com/js-year-calendar@latest/dist/js-year-calendar.min.css" />
                <script
                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
                    integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
                    crossorigin="anonymous"></script>
                <script src="https://unpkg.com/js-year-calendar@latest/dist/js-year-calendar.min.js"></script>
                <script
                    src="https://unpkg.com/js-year-calendar@latest/locales/js-year-calendar.de.js"></script>
            </head>
            <body class="d-flex flex-column h-100 relative content">
                <div class="container mt-3 mb-3 content">
                    <xsl:call-template name="nav_bar" />
                    <main class="container mb-3 mt-3">
                        <div class="container">
                            <div class="row mb-3">
                                <div class="col text-center">
                                    <h1 class="mb-0">Kalender</h1>
                                    <p class="lead">Kalenderansicht der Sitzungsprotokolle</p>
                                    <button type="button" class="btn btn-primary"
                                        data-bs-toggle="modal" data-bs-target="#calendarModal">
                                        Wie nutze ich den Kalender?
</button>

                                    <!-- Year Navigation Controls -->
                                    <div class="calendar-navigation d-flex justify-content-center align-items-center gap-3 mt-3 mb-3">
                                        <button class="btn btn-outline-secondary" id="decade-prev" title="10 Jahre zurück">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-double-left" viewBox="0 0 16 16">
                                                <path fill-rule="evenodd" d="M8.354 1.646a.5.5 0 0 1 0 .708L2.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
                                                <path fill-rule="evenodd" d="M12.354 1.646a.5.5 0 0 1 0 .708L6.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
                                            </svg>
                                        </button>

                                        <button class="btn btn-outline-secondary" id="year-prev" title="1 Jahr zurück">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-left" viewBox="0 0 16 16">
                                                <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
                                            </svg>
                                        </button>

                                        <select id="year-select" class="form-select" style="width: 150px;">
                                            <!-- Years will be populated by JavaScript -->
                                        </select>

                                        <button class="btn btn-outline-secondary" id="year-next" title="1 Jahr vor">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-right" viewBox="0 0 16 16">
                                                <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708z"/>
                                            </svg>
                                        </button>

                                        <button class="btn btn-outline-secondary" id="decade-next" title="10 Jahre vor">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-chevron-double-right" viewBox="0 0 16 16">
                                                <path fill-rule="evenodd" d="M3.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L9.293 8 3.646 2.354a.5.5 0 0 1 0-.708z"/>
                                                <path fill-rule="evenodd" d="M7.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L13.293 8 7.646 2.354a.5.5 0 0 1 0-.708z"/>
                                            </svg>
                                        </button>
                                    </div>
                                    <div class="modal fade" id="calendarModal" tabindex="-1"
                                        aria-labelledby="calendarLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h1 class="modal-title fs-5" id="calendarLabel">
                                                        Hinweis</h1>
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"
                                                        aria-label="Schließen"></button>
                                                </div>
                                                <div class="modal-body text-justify">

                                                    <p>Dieser Kalender listet alle verfügbaren <strong>Protokolle
                                                        der Fraktions- und Gruppensitzungen</strong>
                                                        im Deutschen Bundestag nach deren Tagesdaten
                                                        auf. Durch die Farbkodierung können Sie auf
                                                        einen Blick erkennen, welche Fraktionen und
                                                        Gruppen an einem bestimmten Tag
                                                        zusammenkamen.</p>
                                                    <p>Die Markierung eines Tages im Kalender mit
                                                        einer bestimmten Farbe zeigt an, welche
                                                        Fraktion oder Gruppe an diesem Datum eine
                                                        Sitzung abgehalten hat. Mehrere Sitzungen am
                                                        selben Tag werden durch <strong>mehrere
                                                        Farben</strong> am entsprechenden
                                                        Kalendertag visualisiert.</p>
                                                    <table>
                                                        <thead>
                                                            <tr>
                                                                <th>
                                                                    <strong>Farbe</strong>
                                                                </th>
                                                                <th>
                                                                    <strong>Fraktion/Gruppe</strong>
                                                                </th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr>
                                                                <td>
                                                                    <strong>🟥 Rot</strong>
                                                                </td>
                                                                <td>
                                                                    <strong>SPD-Fraktion</strong>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <strong>⬛ Schwarz</strong>
                                                                </td>
                                                                <td>
                                                                    <strong>CDU/CSU-Fraktion</strong>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <strong>🟦 Blau</strong>
                                                                </td>
                                                                <td>
                                                                    <strong>CSU-Landesgruppe</strong>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <strong>🟩 Grün</strong>
                                                                </td>
                                                                <td>
                                                                    <strong>Grüne (Bündnis 90/Die
                                                                        Grünen)</strong>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <strong>🟪 Rosa</strong>
                                                                </td>
                                                                <td>
                                                                    <strong>PDS/Die Linke</strong>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <strong>🟨 Gelb</strong>
                                                                </td>
                                                                <td>
                                                                    <strong>FDP-Fraktion</strong>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <br />
                                                    <p>Der Kalender ermöglicht Ihnen den direkten
                                                        Zugriff auf die
                                                        edierten Sitzungsprotokolle:</p>
                                                    <ol>
                                                        <li><strong>Sitzungsverlauf (Hover-Effekt):</strong>
                                                            Wenn Sie den <strong>Cursor über einen
                                                            farbig markierten Tag</strong> bewegen
                                                            (oder diesen auf mobilen Geräten
                                                            antippen), wird eine Liste der an diesem
                                                            Tag stattgefundenen Sitzungen mit ihren <strong>
                                                            Sitzungsverlaufspunkten</strong>
                                                            (Tagesordnung/Abschnitte) eingeblendet.</li>
                                                        <li><strong>Protokoll-Ansicht (Klick):</strong>
                                                            Durch <strong>Klicken
                                                                auf einen der gelisteten
                                                            Sitzungsverlaufspunkte</strong> gelangen
                                                            Sie direkt zur entsprechenden Ansicht
                                                            des edierten Protokolls.</li>
                                                    </ol>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Schließen</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <br class="pt-2" />
                                <div id="calendar" />
                            </div>
                        </div>
                    </main>
                    <xsl:call-template name="html_footer" />
                </div>
            </body>
            <!--
            <style>
                td.day:not([aria-describedby]) {
                pointer-events: none;
                cursor: default;
                background: 0 0;
                }
            </style>-->
            <script src="js-data/calendarData.js"></script>
            <script src="js/popover.js"></script>
            <script src="js/calendar.js"></script>
        </html>
    </xsl:template>
</xsl:stylesheet>
