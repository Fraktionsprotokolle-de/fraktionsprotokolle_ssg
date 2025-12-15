<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY copy "&#169;">
    <!ENTITY nbsp "&#160;">
    <!ENTITY ndash "&#8211;">
]>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes" />

    <xsl:import href="./partials/html_head.xsl" />
    <xsl:import href="./partials/html_navbar.xsl" />
    <xsl:import href="./partials/html_footer.xsl" />
    <xsl:import href="./partials/one_time_alert.xsl" />


    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select='"KGParl Protokolle"' />
        </xsl:variable>
        <html class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <link src="css/style.css" rel="stylesheet" type="text/css"></link>
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/@algolia/autocomplete-theme-classic" />
                <style>
                    main {
                    flex: 1 0 auto;
                    background-repeat: no-repeat;
                    background-size: contain;
                    background-position: center;
                    background-color: rgba(255, 255, 255, 0.6);
                    background-blend-mode: lighten;
                    }

                    .ais-Stats {
                    align-content: center !important;
                    }
                    .icons {
                    font-size: 10rem;
                    }
                </style>
                <!--            <script type="module"
                src="https://cdn.jsdelivr.net/npm/typesense@1.8.2/lib/Typesense.js"></script>-->
                <script
                    src="https://cdn.jsdelivr.net/npm/typesense-instantsearch-adapter@2/dist/typesense-instantsearch-adapter.min.js" />
                <script
                    src="https://cdn.jsdelivr.net/npm/algoliasearch@4.5.1/dist/algoliasearch-lite.umd.js"
                    integrity="sha256-EXPXz4W6pQgfYY3yTpnDa3OH8/EPn16ciVsPQ/ypsjk="
                    crossorigin="anonymous" />
                <script
                    src="https://cdn.jsdelivr.net/npm/instantsearch.js@4.74.1/dist/instantsearch.production.min.js"
                    crossorigin="anonymous" />
            </head>
            <body class="d-flex flex-column h-100 relative content">
                <div class="container mt-3 mb-3 content">
                    <xsl:call-template name="nav_bar" />
                    <main class="container mb-3 mt-3">
                        <div class="row mb-3" id="search-facets">
                            <div class="col r-0" style="padding: 0px;" id="party">
                                <a href="liste.html" class="text-black" target="_self"
                                    alt="Link zur Listenansicht der Protokolle"
                                    title="Zur Listenansicht der Protokolle">
                                    <div class="index-card mb-4 text-center">
                                        <div class="index-card-header">
                                            <i class="bi bi-file-earmark-richtext-fill icons"></i>
                                            <h1>Protokolle</h1>
                                        </div>
                                        <div class="card-body text-justify">
                                            Alle Protokolle aus Fraktions- und Gruppensitzungen
                                            werden digitalisiert und mit Annotationen versehen, um
                                            sie für die wissenschaftliche Analyse der
                                            parlamentarischen Entscheidungsprozesse nutzbar zu
                                            machen.
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col r-0" id="periods">
                                <a href="personenregister.html" class="text-black" target="_self"
                                    alt="Link zur Listenansicht der Personen"
                                    title="Zur Listenansicht der Personen">
                                    <div class="index-card mb-4 text-center">
                                        <div class="index-card-header">
                                            <i class="bi bi-person icons"></i>
                                            <h1>Personenverzeichnis</h1>
                                        </div>
                                        <div class="card-body text-justify">
                                            Erfasst werden alle in den Protokollen genannten
                                            Fraktionsmitglieder und relevante Akteure, um ihre
                                            Rollen, Netzwerke und parlamentarischen Aktivitäten
                                            sichtbar zu machen.
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col r-0" style="padding: 0px;" id="documents">
                                <a href="einleitungen.html" class="text-black" target="_self"
                                    alt="Link zur Listenansicht der Einleitungen"
                                    title="Zur Listenansicht der Einleitungen">
                                    <div class="index-card mb-4 text-center">

                                        <div class="index-card-header">
                                            <i class="bi bi-file-earmark icons"></i>
                                            <h1>Einleitungen</h1>
                                        </div>
                                        <div class="card-body text-justify">
                                            Jeder Editionsband ist mit einer von den
                                            Bearbeiter:innen verfassten wissenschaftlichen
                                            Einführung versehen, die den historischen Kontext und
                                            Forschungsbezug erläutert.
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </div>

                        <div class="row" id="search-box">
                            <div class="index-card mb-4">
                                <div class="index-card-header">
                                    <h1>Volltextsuche über die gesamte Edition</h1>
                                </div>
                                <div class="card-body">
                                    <div class="col-md-12 p-0">
                                        <div class="input-group">
                                            <input class="form-control border-end-0 border card-body"
                                                type="search" placeholder="Volltextsuche" id="query" />
                                            <span class="input-group-append">
                                                <button
                                                    class="btn btn-primary border-bottom-0 border rounded-pill fs-3"
                                                    type="button" id="search">
                                                    Suchen
                                                </button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </main>
                    <xsl:call-template name="html_footer" />

                    <script src="./js/index.js"></script>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}">
            <xsl:apply-templates />
        </h2>
    </xsl:template>

    <xsl:template match="tei:p">
        <p id="{generate-id()}">
            <xsl:apply-templates />
        </p>
    </xsl:template>

    <xsl:template match="tei:list">
        <ul id="{generate-id()}">
            <xsl:apply-templates />
        </ul>
    </xsl:template>

    <xsl:template match="tei:item">
        <li id="{generate-id()}">
            <xsl:apply-templates />
        </li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target" />
                    </xsl:attribute>
                    <xsl:value-of select="." />
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
