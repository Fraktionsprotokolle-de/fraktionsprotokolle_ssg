<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
    <!ENTITY copy "&#169;">
    <!ENTITY nbsp "&#160;">
    <!ENTITY ndash "&#8211;">
]>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes" />

    <xsl:import href="./partials/html_navbar.xsl" />
    <xsl:import href="./partials/html_head.xsl" />
    <xsl:import href="./partials/html_footer.xsl" />
    <xsl:import href="./fraktionsprotokolle.xslt" />
    <xsl:import href="./partials/person.xsl" />

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()" />
        </xsl:variable>
        <xsl:variable name="col" select="collection('../data/editions/?select=*.xml;recurse=no')" />
        <xsl:variable name="heute" select="current-date()" />
        <xsl:variable name="countPersonenAll" select="count(.//tei:person)" />
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
                    .ais-SearchBox-form {
                    display: flex;
                    }

                </style>
            </head>


            <body class="d-flex flex-column h-100 relative content">
                <div class="container mt-3 mb-3 content">
                    <xsl:call-template name="nav_bar" />

                    <main class="container mb-3 mt-3">
                        <h1>Personenregister</h1>
                        <div class="row">
                            <div class="col-md-12 no-wrap w-100">
                                <div class="input-group display-block" id="searchbox"></div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <span id="allFound" />
                                    <xsl:value-of
                                        select="$countPersonenAll" /> Personen im Personenregister </div>
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
                    </main>
                </div>
                <xsl:call-template name="html_footer" />
                <script src="js/personenregister.js"></script>
            </body>
        </html>


        <xsl:for-each select=".//tei:person">
            <xsl:variable name="person_id" select="data(@xml:id)" />
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')" />
            <xsl:variable name="anzeigename">
                <xsl:if test="./tei:addName[@type='preaefix']">
                    <xsl:value-of select="./tei:addName[@type='preaefix']" />
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:value-of select="./tei:persName[1]/tei:surname/text()" />
                <xsl:text>, </xsl:text>
                <xsl:value-of select="./tei:persName[1]/tei:forename/text()" />
            </xsl:variable>
            <xsl:variable name="name"
                select="normalize-space(string-join(./tei:persName[1]/tei:reg/text()))"></xsl:variable>
            <xsl:variable name="hashedid" select="concat('#', $person_id)" />
            <xsl:variable name="hits" select="$col//tei:name[@type='Person' and @ref=$hashedid]" />
            <xsl:variable name="distinct" select="distinct-values($hits/base-uri(.))" />
            <xsl:variable name="birth">
                <xsl:if test=".//tei:birth/tei:date/@when">
                    <xsl:choose>
                        <xsl:when test="string-length(.//tei:birth/tei:date/@when) = 10">
                            <xsl:value-of
                                select="format-date(xs:date(.//tei:birth/tei:date/@when), '[D01].[M01].[Y]')" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select=".//tei:birth/tei:date/@when" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="death">
                <xsl:if test=".//tei:death/tei:date/@when">
                    <xsl:choose>
                        <xsl:when test="string-length(.//tei:death/tei:date/@when) = 10">
                            <xsl:value-of
                                select="format-date(xs:date(.//tei:death/tei:date/@when), '[D01].[M01].[Y]')" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select=".//tei:death/tei:date/@when" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="birthplace">
                <xsl:if test=".//tei:birth/tei:placeName">
                    <xsl:value-of select="./tei:birth/tei:placeName" />
                </xsl:if>
                <xsl:if test="string-length(.//tei:birth/tei:country[1])">
                    <xsl:value-of select="concat('(', .//tei:birth/tei:country[1]), ')'" />
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="deathplace">
                <xsl:if test=".//tei:death/tei:placeName">
                    <xsl:value-of select=".//tei:death/tei:placeName" />
                </xsl:if>
                <xsl:if test="string-length(.//tei:death/tei:country[1]) > 0">
                    <xsl:value-of select="concat('(', .//tei:death/tei:country[1], ')')" />
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="birthstring">
                <xsl:if test="$birth">
                    <xsl:value-of select="$birth" />
                </xsl:if>
                <xsl:if test="string-length($birthplace) != 0">
                    <xsl:text> in </xsl:text>
                    <xsl:value-of select="$birthplace" />
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="deathstring">
                <xsl:if test="$death">
                    <xsl:value-of select="$death" />
                </xsl:if>
                <xsl:if test="string-length($deathplace) != 0">
                    <xsl:text> in </xsl:text>
                    <xsl:value-of select="$deathplace" />
                </xsl:if>
            </xsl:variable>

            <xsl:variable name="occupation">
                <xsl:if test=".//tei:affiliation[@type='Erwerbsarbeit']">
                    <xsl:value-of select=".//tei:affiliation[@type='Erwerbsarbeit']" />
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="periods">
                <xsl:if test=".//tei:affiliation[@type='Wahlperioden']">
                    <xsl:copy-of select=".//tei:affiliation[@type='Wahlperioden']" />
                </xsl:if>
            </xsl:variable>

            <xsl:variable name="idnos">
                <xsl:if test=".//tei:idno">
                    <xsl:copy-of select=".//tei:idno" />
                </xsl:if>
            </xsl:variable>

            <xsl:variable name="mdb" select="./ancestor-or-self::tei:listPerson[@type='MdB']" />

            <xsl:variable name="count">
                <xsl:value-of
                    select="count($distinct)"
                />
            </xsl:variable>
            <xsl:result-document href="{$filename}">
                <html class="h-100">
                    <head>

                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
                        <link
                            rel="stylesheet"
                            href="https://cdn.datatables.net/1.12.1/css/jquery.dataTables.css"
                        />
                        <link rel="stylesheet" href="css/kgparl.css" />
                        <script
                            src="https://code.jquery.com/jquery-3.7.1.min.js"
                            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
                            crossorigin="anonymous"
                        ></script>
                        <script src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.js"></script>
                        <script
                            src="//cdn.datatables.net/plug-ins/1.12.1/pagination/ellipses.js"></script>
                        <!--<script
                    src="https://cdn.datatables.net/plug-ins/2.1.8/sorting/datetime-moment.js"></script>-->
                        <style>
                            .kgparl-link {
                            background-color: var(--color-primary);
                            }

                            tr {
                            cursor: pointer;
                            }
                        </style>
                    </head>

                    <body class="d-flex flex-column h-100 relative content">
                        <div class="container mt-3 mb-3 content">
                            <xsl:call-template name="nav_bar" />

                            <main class="container mb-3 mt-3">
                                <!-- Template einfügen -->
                                <div class="row ">
                                    <h1 class="display-4 col-md-4 mb-4">
                                        <xsl:value-of select="$name" />
                                        <xsl:if test="$mdb">
                                            <xsl:text> (MdB)</xsl:text>
                                        </xsl:if>
                                    </h1>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <h4 class="mb-3">Persönliche Informationen</h4>
                                        <div class="card mb-3 bg-alt">
                                            <div class="card-body">
                                                <ul class="list-unstyled">
                                                    <b>
                                                        <xsl:value-of select="$anzeigename" />
                                                    </b>
                                                    <xsl:if
                                                        test="string-length(.//tei:persName[@n = '1']/tei:addName[@type='Ort']) > 0">

                                                        <xsl:value-of
                                                            select=".//tei:persName[@n = '1']/tei:addName[@type='Ort']" />

                                                    </xsl:if>
                                                    <br />
                                                    [Anzeigename in der Edition: <xsl:value-of
                                                        select="$name" />] <xsl:if
                                                        test=".//tei:persName[@n = '2']">
                                                        <br />
                                                        <i>Namensvarianten:</i>
                                                        <ul>
                                                            <xsl:for-each
                                                                select=".//tei:persName[@n != '1']">

                                                                <li>
                                                                    <xsl:if
                                                                        test="./tei:addName[@type='preaefix']">
                                                                        <xsl:value-of
                                                                            select="./tei:addName[@type='preaefix']" />
                                                                        <xsl:text> </xsl:text>
                                                                    </xsl:if>
                                                                    <xsl:value-of
                                                                        select=".//tei:surname/text()" />
                                                                    <xsl:text>, </xsl:text>
                                                                    <xsl:value-of
                                                                        select=".//tei:forename/text()" />
                                                                    <xsl:if
                                                                        test="string-length(./tei:addName[@type='Ort']) > 0">

                                                                        <xsl:value-of
                                                                            select="./tei:addName[@type='Ort']" />

                                                                    </xsl:if>
                                                                </li>
                                                            </xsl:for-each>
                                                        </ul>
                                                        <br />
                                                    </xsl:if>

                                                    <xsl:if
                                                        test="$birthstring">
                                                        <li> Geboren: <xsl:value-of
                                                                select="$birthstring" />
                                                        </li>
                                                    </xsl:if>
                                                    <xsl:if
                                                        test="$deathstring">
                                                        <li> Gestorben: <xsl:value-of
                                                                select="$deathstring" />
                                                        </li>
                                                    </xsl:if>
                                                    <xsl:if
                                                        test="$occupation">
                                                        <li>
                                                            <i class="bi bi-briefcase"></i> Beruf: <xsl:value-of
                                                                select="$occupation" />
                                                        </li>
                                                    </xsl:if>
                                                    <xsl:if
                                                        test="$idnos">
                                                        <li>
                                                            <i class="bi bi-share"></i> Normdaten:  <br/><xsl:for-each
                                                                select="$idnos//*[text() != '']">
                                                                <xsl:if
                                                                    test="@type='MDB_Stammdaten'">
                                                                   
                                                                    <xsl:text>MdB-Stammdatennummer</xsl:text>
                                                                    <xsl:text>: </xsl:text>
                                                                    <xsl:value-of select=".//text()" />
                                                                </xsl:if>

                                                                <xsl:if
                                                                    test="not(@type='MDB_Stammdaten')">
                                                                    <a
                                                                        target="_blank"
                                                                        class="
                                                                     item">
                                                                        <xsl:attribute name="href">
                                                                            <xsl:choose>
                                                                                <xsl:when
                                                                                    test="@type='GND'">
                                                                                    <xsl:value-of
                                                                                        select=".//text()" />
                                                                                </xsl:when>
                                                                                <xsl:when
                                                                                    test="@type='NDB'">
                                                    https://www.deutsche-biographie.de/sfz001_00073_1.html?sfz001_00073_1=<xsl:value-of
                                                                                        select=".//text()" /></xsl:when>
                                                                                <xsl:when
                                                                                    test="@type='Wikipedia'">
                                                    https://de.wikipedia.org/wiki/<xsl:value-of
                                                                                        select=".//text()" /></xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:value-of
                                                                                        select=".//text()" />
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:attribute>
                                                                        <xsl:value-of select="@type" />
                                                                        <xsl:text>: </xsl:text>
                                                                        <xsl:value-of
                                                                            select=".//text()" />
                                                                    </a>
                                                                </xsl:if>
                                                                <br />
                                                            </xsl:for-each>
                                                        </li>
                                                    </xsl:if>
                                                </ul>
                                            </div>
                                        </div>
                                        <br />
                                        <h4 class="mb-3">Vernetze Angebote</h4>
                                        <div class="card mb-3 bg-alt">
                                            <div class="card-body">
                                                <i>Derzeit in Arbeit...</i>
                                            </div>
                                        </div>
                                    </div>

                                    <xsl:if test="count($periods/*) > 0">
                                        <div class="col-md-4 ">
                                            <h2 class="h4 mb-3">Mitgliedschaft im Bundestag</h2>
                                            <div class="timeline ">
                                                <xsl:for-each
                                                    select="$periods//tei:affiliation[@type='Wahlperiode']">
                                                    <xsl:variable name="wp">
                                                        <xsl:value-of
                                                            select="replace(@period, '#wp', '')" />
                                                    </xsl:variable>
                                                    <xsl:variable name="datefrom">
                                                        <xsl:value-of
                                                            select="format-date(xs:date(.//tei:affiliation[@type='Fraktionszugehoerigkeiten']/@from), '[D01].[M01].[Y]')" />
                                                    </xsl:variable>
                                                    <xsl:variable name="dateto">
                                                        <xsl:value-of
                                                            select="format-date(xs:date(.//tei:affiliation[@type='Fraktionszugehoerigkeiten']/@to), '[D01].[M01].[Y]')" />
                                                    </xsl:variable>
                                                    <xsl:variable name="party">
                                                        <xsl:value-of
                                                            select=".//tei:affiliation[@type='Fraktionszugehoerigkeiten']/tei:affiliation[@type='Fraktionszugehoerigkeit']" />
                                                    </xsl:variable>
                                            
                                                    <div class="card mb-3 bg-alt">
                                                        <div class="card-body">
                                                            <h5 class="card-title"><xsl:value-of
                                                                    select="$wp" />. Wahlperiode</h5>
                                                            <p class="card-text"><xsl:value-of
                                                                    select="$datefrom" /> - <xsl:value-of
                                                                    select="$dateto" /></p>
                                                            <p class="card-text">
                                                                <xsl:value-of select="$party" />
                                                            </p>
                                                        </div>
                                                    </div>
                                                </xsl:for-each>
                                            </div>
                                        </div>
                                    </xsl:if>


                                    <xsl:if test="count($periods/*) > 0">

                                        <div class="col-md-4">
                                            <h2 class="h4 mb-3">Fraktionsprotokolle</h2>
                                            <ul class="list-group">
                                                <xsl:for-each
                                                    select="$periods//tei:affiliation[@type='Wahlperiode']">
 
                                                  
                                                    <xsl:variable name="wp">
                                                        <xsl:value-of
                                                            select="replace(@period, '#wp', '')" />
                                                    </xsl:variable>
                                                    <xsl:variable name="hitswp"
                                                        select="$hits[//descendant-or-self::tei:creation//tei:idno[@type='wp'][contains(text(),$wp)]]" />
                                                  
                                                      <xsl:if test="count(distinct-values($hitswp/base-uri())) > 0">
                                                     <li
                                                        class="list-group-item w-100 d-flex justify-content-between align-items-center position-relative"
                                                    >
                                                        <details class="w-100 bg-alt">
                                                            <summary
                                                                class=" d-flex justify-content-between align-items-center"
                                                            >

                                                                <span
                                                                    class="text-decoration-none"><xsl:value-of
                                                                        select="$wp" />. Wahlperiode</span>
                                                                <span
                                                                    class="badge bg-kgparl rounded-pill">
                                                                    <xsl:value-of
                                                                        select="count(distinct-values($hitswp/base-uri()))" />
                                                                </span>
                                                            </summary>
                                                            <table id="protocol-table-{$wp}"
                                                                class="display table">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Fraktion</th>
                                                                        <th>Datum</th>
                                                                        <th>Titel</th>

                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <xsl:for-each-group
                                                                        select="$hitswp"
                                                                        group-by="base-uri(.)">
                                                                        <xsl:sort
                                                                            select="root(.)//tei:creation//tei:date[1]"
                                                                            order="descending" />
                                                                        <xsl:variable name="url">
                                                                            <xsl:value-of
                                                                                select="replace(tokenize(base-uri(.), '/')[last()], 'xml', 'html')" />
                                                                        </xsl:variable>
                                                                        <xsl:variable
                                                                            name="date">
                                                                            <xsl:call-template
                                                                                name="PureDate">
                                                                                <xsl:with-param
                                                                                    name="protocol"
                                                                                    select="root(.)" />
                                                                            </xsl:call-template>
                                                                        </xsl:variable>

                                                                        <tr>
                                                                            <xsl:attribute
                                                                                name="data-href">
                                                                                <xsl:value-of
                                                                                    select="$url" />
                                                                            </xsl:attribute>
                                                                            <td>
                                                                                <xsl:call-template
                                                                                    name="GetParty">
                                                                                    <xsl:with-param
                                                                                        name="protocol"
                                                                                        select="root(.)" />
                                                                                </xsl:call-template>
                                                                            </td>
                                                                            <td>
                                                                                <xsl:attribute
                                                                                    name="data-sort">
                                                                                    <xsl:value-of
                                                                                        select="$date" />
                                                                                </xsl:attribute>
                                                                                <xsl:call-template
                                                                                    name="GetDate">
                                                                                    <xsl:with-param
                                                                                        name="protocol"
                                                                                        select="root(.)" />
                                                                                </xsl:call-template>
                                                                            </td>
                                                                            <td>
                                                                                <xsl:value-of
                                                                                    select="root(.)//tei:titleStmt/tei:title[@level='a']" />
                                                                            </td>
                                                                            <td>


                                                                            </td>
                                                                        </tr>

                                                                    </xsl:for-each-group>
                                                                </tbody>
                                                            </table>
                                                        </details>
                                                    </li>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </ul>
                                        </div>
                                    </xsl:if>
                                </div>
                                <br />
                                <span class="h2"
                                >
                                    <i class="bi bi-box-arrow-up-right"></i>
                                    <a class="btn" type="button"
                                        href="liste.html?kgparl%5BrefinementList%5D%5Bpersons%5D%5B0%5D={$name}">In
                                        Personenfacette übernehmen</a>
                                </span>
                                <!-- Ende Template einfügen -->
                            </main>
                        </div>
                        <script>

                            $(document).ready(function () {
                            $("table.table").each(function () {
                            $(this).DataTable({
                            iShowPages: 3,
                            responsive: true,
                            order: [[1, "asc"]],
                            language: {
                            url: "js/de-DE.json",
                            },
                            });
                            });


                            });
                            // Add click event listeners to table rows

                            $("table.table tbody").children().each((index, row) =&gt; {
                            row.addEventListener("click", (e) =&gt; {
                            // Don't navigate if clicking on a link or other interactive element
                            if (e.target.tagName === "A" || e.target.closest("a")) {
                            return;
                            }
                            var href = row.getAttribute("data-href");

                            window.location.href = href;
                            });
                            });
                        </script>
                        <xsl:call-template name="html_footer" />

                        <script src="js/i18n.js"></script>

                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
