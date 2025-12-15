<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY copy "&#169;">
    <!ENTITY nbsp "&#160;">
    <!ENTITY ndash "&#8211;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes" />

    <xsl:import href="./partials/html_navbar.xsl" />
    <xsl:import href="./partials/html_head.xsl" />
    <xsl:import href="./partials/html_footer.xsl" />
    <xsl:import href="./fraktionsprotokolle.xslt" />

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:text>Literaturverzeichnis</xsl:text>
        </xsl:variable>
        <xsl:variable name="heute" select="current-date()" />
        <html class="h-100">

            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <script
                    src="https://cdn.jsdelivr.net/npm/typesense-instantsearch-adapter@2/dist/typesense-instantsearch-adapter.min.js" />
                <script
                    src="https://cdn.jsdelivr.net/npm/algoliasearch@4.5.1/dist/algoliasearch-lite.umd.js"
                    integrity="sha256-EXPXz4W6pQgfYY3yTpnDa3OH8/EPn16ciVsPQ/ypsjk="
                    crossorigin="anonymous" />
                <script
                    src="https://cdn.jsdelivr.net/npm/instantsearch.js@4.74.1/dist/instantsearch.production.min.js"
                    crossorigin="anonymous" />
                <style>
                    .ais-SearchBox {
                    width: 100%;
                    }
                    .footnotes {
                    display: block !important;
                    }
                </style>
            </head>

            <body class="d-flex flex-column h-100 relative content">
                <div class="container mt-3 mb-3 content">
                    <xsl:call-template name="nav_bar" />
                    <main class="container mb-3 mt-3">

                        <h1>Literatur</h1>
                        <div class="row">
                            <div class="col-md-12 no-wrap w-100">
                                <div class="input-group mb-3 w-100" id="searchbox"></div>
                            </div>
                            <div class="col-md-12 no-wrap">
                                <div class="row mb-3">
                                    <div class="col-md-6" id="clear"></div>
                                    <div class="col-md-6 text-end" id="sort-by"></div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <span id="allFound" /> (Stand: <xsl:value-of
                                            select="format-date($heute,'[D01].[M01].[Y0001]')" /> ) </div>
                                    <div class="col-md-6" id="hits-per-page"></div>
                                </div>
                                <div class="col-md-12 no-wrap">
                                    <div class="justify-content-center">
                                        <div class="row" id="letters" />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12" id="hits"></div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12" id="pagination"></div>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
                <xsl:call-template name="html_footer" />
                <script src="js/literaturregister.js"></script>
            </body>
        </html>


    </xsl:template>
</xsl:stylesheet>
