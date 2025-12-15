<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
  <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes" />

  <xsl:import href="../partials/html_head.xsl" />
  <xsl:import href="../partials/html_navbar.xsl" />
  <xsl:import href="../partials/html_footer.xsl" />
  <xsl:import href="../partials/one_time_alert.xsl" />
  <xsl:variable name="statics" as="element()*">
    <xsl:element name="static">
      <xsl:attribute name="url">
        <xsl:value-of select="'https://raw.githubusercontent.com/Fraktionsprotokolle-de/fraktionsprotokolle_web/refs/heads/main/md-seitentexte/aktuelles.md'" />
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:text>Aktuelles</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="filename">
        <xsl:text>aktuelles.html</xsl:text>
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="static">
      <xsl:attribute name="url">
        <xsl:value-of select="'https://raw.githubusercontent.com/Fraktionsprotokolle-de/fraktionsprotokolle_web/refs/heads/main/md-seitentexte/editionsbeirat.md'" />
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:text>Editionsbeirat</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="filename">
        <xsl:text>editionsbeirat.html</xsl:text>
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="static">
      <xsl:attribute name="url">
        <xsl:value-of select="'https://raw.githubusercontent.com/Fraktionsprotokolle-de/fraktionsprotokolle_web/refs/heads/main/md-seitentexte/forschung.md'" />
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:text>Forschung</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="filename">
        <xsl:text>forschung.html</xsl:text>
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="static">
      <xsl:attribute name="url">
        <xsl:value-of select="'https://raw.githubusercontent.com/Fraktionsprotokolle-de/fraktionsprotokolle_web/refs/heads/main/md-seitentexte/mitarbeiter.md'" />
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:text>Mitarbeiter:Innen</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="filename">
        <xsl:text>mitarbeiter.html</xsl:text>
      </xsl:attribute>
    </xsl:element>
    <xsl:element name="static">
      <xsl:attribute name="url">
        <xsl:value-of select="'https://raw.githubusercontent.com/Fraktionsprotokolle-de/fraktionsprotokolle_web/refs/heads/main/md-seitentexte/projekt.md'" />
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:text>Projekt</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="filename">
        <xsl:text>projekt.html</xsl:text>
      </xsl:attribute>
    </xsl:element>    <!--
    <xsl:element name="static">
      <xsl:attribute name="url">
        <xsl:value-of select="'https://raw.githubusercontent.com/Fraktionsprotokolle-de/fraktionsprotokolle_web/refs/heads/main/md-seitentexte/einleitungen.md'" />
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:text>Einleitungen</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="filename">
        <xsl:text>einleitungen.html</xsl:text>
      </xsl:attribute>
    </xsl:element>-->
  </xsl:variable>

  <xsl:template match="/">
    <xsl:for-each select="$statics">
      <xsl:result-document href="{@filename}">
        <xsl:variable name="doc_title">
          <xsl:value-of select='@name' />
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
                <div id="text">
                  <p>Lade Inhalt...</p>
                </div>
              </main>
                <xsl:call-template name="html_footer" />
            </div>
          
            <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
            <script src="https://unpkg.com/showdown/dist/showdown.min.js"></script>

            <script> function getMakedown() { $.ajax({ type: "GET", url: "<xsl:value-of select="@url" />", async: false, success: function (text) { var converter = new showdown.Converter(); var html = converter.makeHtml(text); $("div#text").html(html);}, error: function() { $("div#text").html('Fehler beim Laden der Markdown-Datei. Bitte versuchen Sie es später noch einmal.'); } }); } // check for local storage. If it exists, use it. Otherwise, use the default.
              var localStorageAvailable = typeof(Storage) !== "undefined"; 
              if (localStorageAvailable) { var text = localStorage.getItem("md#<xsl:value-of select="@name" />"); if (text) { $("div#text").html(text); } else { getMakedown();
              localStorage.setItem("md#<xsl:value-of select="@name" />", $("div#text").html()); } }
              else { getMakedown(); } </script>
      </body>
    </html>
  </xsl:result-document>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
