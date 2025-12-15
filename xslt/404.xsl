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
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes" />

    <xsl:import href="./partials/html_head.xsl" />
    <xsl:import href="./partials/html_navbar.xsl" />
    <xsl:import href="./partials/html_footer.xsl" />
    <xsl:import href="./partials/one_time_alert.xsl" />


    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select='"KGParl Protokolle - 404 Not Found"' />
        </xsl:variable>
        <html class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <link src="css/kgparl.css" rel="stylesheet" type="text/css"></link>

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
                    <main class="container mb-3 mt-3">
                        <div class="row mb-3" id="search-facets">
                            <div class="col r-0" style="padding: 0px;" id="error-404">
                                <div class="index-card mb-4">
                                    <div class="index-card-header">
                                        <h1>404 - Seite nicht gefunden</h1>
                                    </div>
                                    <div class="card-body">
                                        Die gesuchte Seite konnte nicht gefunden werden. Bitte überprüfen Sie die URL oder versuchen Sie es erneut.
                                    </div>
                                </div>
                            </div>
                            </div>
                        </main>
                        <xsl:call-template name="html_footer" />

                        <!--<script src="./js/index.js"></script>-->
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
