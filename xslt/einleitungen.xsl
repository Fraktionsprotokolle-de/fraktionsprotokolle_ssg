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
            <xsl:value-of select='"KGParl Protokolle - Einleitungen"' />
        </xsl:variable>
        <html class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <script src="https://code.jquery.com/jquery-3.6.3.min.js"
                    integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU="
                    crossorigin="anonymous"></script>
                <script
                    src="https://cdn.jsdelivr.net/npm/typesense-instantsearch-adapter@2/dist/typesense-instantsearch-adapter.min.js" />
                <script
                    src="https://cdn.jsdelivr.net/npm/algoliasearch@4.5.1/dist/algoliasearch-lite.umd.js"
                    integrity="sha256-EXPXz4W6pQgfYY3yTpnDa3OH8/EPn16ciVsPQ/ypsjk="
                    crossorigin="anonymous" />
                <script
                    src="https://cdn.jsdelivr.net/npm/instantsearch.js@4.74.1/dist/instantsearch.production.min.js"
                    crossorigin="anonymous" />
                <link src="css/kgparl.css" rel="stylesheet" type="text/css"></link>

                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/instantsearch.css@7/themes/algolia-min.css" />
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

            </head>
            <body class="d-flex flex-column h-100 relative content">
                <div class="container mt-3 mb-3 content">

                    <xsl:call-template name="nav_bar" />

                    <div class="row">
                        <main class="d-flex h-100 flew-grow-1">
                            <div class="container padding-container">
                                <!--<div
                                id="current-refinements"></div>-->
                                <div class="mt-2" id="searchbox"></div>
                                <div id="year-menu"></div>
                                <div id="hits"></div>
                                <br />
                                <div id="pagination"></div>
                                <br />
                            </div>
                            <aside class="sidebar">
                                <h3>Personen</h3>
                                <div id="person-list"></div>
                                <hr />
                                <div id="clear-refinements"></div>
                                <!--
                                <h3>Sortierung</h3>
                                <div id="sort-by"></div>-->
                                <br />
                            </aside>
                        </main>
                    </div>
                    <!-- <xsl:call-template name="html_footer" />
                  <xsl:call-template name="tabulator_js" /> -->
                    <script src="js/einleitungen.js" type="text/javascript"></script>
                    <xsl:call-template name="html_footer" />
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
