<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:include href="./params.xsl" />
    <xsl:template match="/" name="html_head">
        <xsl:param name="html_title" select="$project_short_title"></xsl:param>
        <meta
            http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta
            http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport"
            content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta
            name="mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-capable"
            content="yes" />
        <meta name="apple-mobile-web-app-title" content="{$html_title}" />
        <meta
            name="msapplication-TileColor" content="#ffffff" />
        <meta name="msapplication-TileImage"
            content="{$project_logo}" />
        <meta property="og:title" content="Fraktionsprotokolle"/>
        <meta property="og:type" content="website"/>
        <meta property="og:url" content="https://www.fraktionsprotokolle.de/"/>
        <meta property="og:image" content="images/KGParl_titel.png"/>
        <meta property="og:description" content="Online-Edition der Protokolle der Fraktionen des Deutschen Bundestags"/>
        <!-- favicon -->
        <!-- <link rel="None" type="image/ico" href="images/favicons/favicon.ico" />
        <link rel="icon" type="image/png" href="images/favicons/favicon-16x16.png" />
        <link rel="icon" type="image/png" href="images/favicons/favicon-32x32.png" />
        <link rel="icon" type="image/png" href="images/favicons/favicon-64x64.png" />
        <link rel="icon" type="image/png" href="images/favicons/favicon-96x96.png" />
        <link rel="icon" type="image/png" href="images/favicons/favicon-180x180.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-57x57.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-60x60.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-72x72.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-76x76.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-114x114.png"
        />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-120x120.png"
        />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-144x144.png"
        />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-152x152.png"
        />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-167x167.png"
        />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-180x180.png"
        />
        <link rel="None" type="image/png" href="images/favicons/mstile-70x70.png" />
        <link rel="None" type="image/png" href="images/favicons/mstile-270x270.png" />
        <link rel="None" type="image/png" href="images/favicons/mstile-310x310.png" />
        <link rel="None" type="image/png" href="images/favicons/mstile-310x150.png" />
        <link rel="shortcut icon" type="image/png" href="images/favicons/favicon-196x196.png" /> -->
        <!-- favicon end -->
        <link rel="icon" type="image/svg+xml" href="{$project_logo}"
            sizes="any" />
        <link rel="profile" href="http://gmpg.org/xfn/11"></link>
        <title>
            <xsl:value-of select="$html_title" />
        </title>
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.css"
            rel="stylesheet"
            crossorigin="anonymous" />
        <link rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" />
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/@fontsource/oswald@5.1.0/index.min.css" />
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/roboto-font@0.1.0/css/fonts.min.css" />
        <link
            rel="stylesheet" href="css/kgparl.css" type="text/css"></link>
        <!--<link
        rel="stylesheet" href="fonts/font.css" type="text/css"></link>-->
        <script src="https://code.jquery.com/jquery-3.6.3.min.js"
            integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin=" anonymous"></script>

        <script
            src="https://cdn.jsdelivr.net/npm/i18next@21.6.10/i18next.min.js"></script>
        <script
            src="https://cdn.jsdelivr.net/npm/jquery-i18next@1.2.1/jquery-i18next.min.js"></script>
        <script
            src="https://cdn.jsdelivr.net/npm/i18next-browser-languagedetector@6.1.3/i18nextBrowserLanguageDetector.min.js"></script>
        <script
            src="https://cdn.jsdelivr.net/npm/i18next-http-backend@1.3.2/i18nextHttpBackend.min.js"></script>

        <script src="js/config.js"></script>
        <style>
            .navBarNavDropdown ul li:nth-child(2) {
                display: none !important;
            }

            .highlight {
                background-color: rgb(246, 166, 35);
            }

            body {
                overflow: hidden;
                overflow-y: scroll;
            }

            .content {
                font-family: "Georgia", sans-serif;
                font-style: normal;
                font-size: 1.6rem;
            }

            .claim {
                font-family: "Garamond", sans-serif;
                font-style: italic;
            }

            .container {
                padding-left: 0;
            }

            ul {
                margin-left: 0;
            }
        </style>
        <script type="module" src="js/popupinfo.js"></script>
        <script type="module" src="js/customcheckbox.js"></script>
        <script src="js/print-helper.js"></script>
    </xsl:template>
    <xsl:template name="html_head_styleless">
        <xsl:param name="html_title" select="$project_short_title"></xsl:param>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-title" content="{$html_title}" />
        <meta name="msapplication-TileColor" content="#ffffff" />
        <meta name="msapplication-TileImage" content="{$project_logo}" />
        <!-- favicon -->
        <!-- <link rel="None" type="image/ico" href="images/favicons/favicon.ico" />
        <link rel="icon" type="image/png" href="images/favicons/favicon-16x16.png" />
        <link rel="icon" type="image/png" href="images/favicons/favicon-32x32.png" />
        <link rel="icon" type="image/png" href="images/favicons/favicon-64x64.png" />
        <link rel="icon" type="image/png" href="images/favicons/favicon-96x96.png" />
        <link rel="icon" type="image/png" href="images/favicons/favicon-180x180.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-57x57.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-60x60.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-72x72.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-76x76.png" />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-114x114.png"
        />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-120x120.png"
        />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-144x144.png"
        />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-152x152.png"
        />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-167x167.png"
        />
        <link rel="apple-touch-icon" type="image/png" href="images/favicons/apple-touch-icon-180x180.png"
        />
        <link rel="None" type="image/png" href="images/favicons/mstile-70x70.png" />
        <link rel="None" type="image/png" href="images/favicons/mstile-270x270.png" />
        <link rel="None" type="image/png" href="images/favicons/mstile-310x310.png" />
        <link rel="None" type="image/png" href="images/favicons/mstile-310x150.png" />
        <link rel="shortcut icon" type="image/png" href="images/favicons/favicon-196x196.png" /> -->
        <!-- favicon end -->
        <link rel="icon" type="image/svg+xml" href="{$project_logo}" sizes="any" />
        <link rel="profile" href="http://gmpg.org/xfn/11"></link>
        <title>
            <xsl:value-of select="$html_title" />
        </title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
            crossorigin="anonymous" />
        <link rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" />
        <link rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/@fontsource/oswald@5.1.0/index.min.css" />
        <link rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/roboto-font@0.1.0/css/fonts.min.css" />
        <!--        <link rel="stylesheet" href="css/style.css" type="text/css"></link>-->
   
        <!--<link
        rel="stylesheet" href="fonts/font.css" type="text/css"></link>-->
        <script src="https://cdn.jsdelivr.net/npm/i18next@21.6.10/i18next.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jquery-i18next@1.2.1/jquery-i18next.min.js"></script>
        <script
            src="https://cdn.jsdelivr.net/npm/i18next-browser-languagedetector@6.1.3/i18nextBrowserLanguageDetector.min.js"></script>
        <script
            src="https://cdn.jsdelivr.net/npm/i18next-http-backend@1.3.2/i18nextHttpBackend.min.js"></script>
    </xsl:template>
</xsl:stylesheet>
