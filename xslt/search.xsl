<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes" />

    <xsl:import href="partials/html_navbar.xsl" />
    <xsl:import href="partials/html_head.xsl" />
    <xsl:import href="partials/html_footer.xsl" />
    <!--<xsl:import href="partials/tabulator_dl_buttons.xsl" />
    <xsl:import href="partials/tabulator_js.xsl" />-->


    <xsl:template match="/">
    <html lang="de">
        <xsl:variable name="doc_title" select="'Volltextsuche'" />
        <head>
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
            </xsl:call-template>
            <link src="css/style.css" rel="stylesheet" type="text/css"></link>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@algolia/autocomplete-theme-classic" />
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
            </style>
            <!--            <script type="module" src="https://cdn.jsdelivr.net/npm/typesense@1.8.2/lib/Typesense.js"></script>-->
            <script src="https://cdn.jsdelivr.net/npm/typesense-instantsearch-adapter@2/dist/typesense-instantsearch-adapter.min.js" />
            <script src="https://cdn.jsdelivr.net/npm/algoliasearch@4.5.1/dist/algoliasearch-lite.umd.js" integrity="sha256-EXPXz4W6pQgfYY3yTpnDa3OH8/EPn16ciVsPQ/ypsjk=" crossorigin="anonymous" />
            <script src="https://cdn.jsdelivr.net/npm/instantsearch.js@4.74.1/dist/instantsearch.production.min.js" crossorigin="anonymous" />
        </head>
        <body class="d-flex flex-column h-100 relative content">
            <div class="container mt-3 mb-3 content">
                <xsl:call-template name="nav_bar" />

                <div class="row">
                    <main class="d-flex h-100 flew-grow-1">
                        <div class="container">
                            <div class="mt-2" id="searchbox"/>

                            <div id="hits"/>
                            <br/>
                            <div id="pagination"/>
                            <h3>Treffer pro Seite</h3>
                            <div id="hits-per-page" class="mb-2"/>
                        </div>
                        <aside class="sidebar">
                            <h3>Fraktionen</h3>
                            <div id="party-list"/>
                            <hr/>
                            <h3>Wahlperioden</h3>
                            <div id="period-list"/>
                            <hr/>
                            <h3>Personen</h3>
                            <div id="person-list"/>
                            <hr/>
                            <div id="clear-refinements"/>
                            <hr/>
                            <h3>Sortierung</h3>
                            <div id="sort-by"/>
                            <br/>
                        </aside>
                    </main>
                </div>
                <xsl:call-template name="html_footer" />

                <script src="./js/search.js"></script>
            </div>
        </body>
    </html>
</xsl:template>
</xsl:stylesheet>
