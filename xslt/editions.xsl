<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes" />

    <xsl:import href="./partials/shared.xsl" />
    <xsl:import href="./partials/html_navbar.xsl" />
    <xsl:import href="./partials/html_head.xsl" />
    <xsl:import href="./partials/html_footer.xsl" />
    <xsl:import href="./partials/aot-options.xsl" />
    <xsl:import href="./fraktionsprotokolle.xslt" />
    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')" />
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')" />
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)" />
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')" />
    </xsl:variable>
    <xsl:variable name="party">
        <xsl:value-of select=".//tei:profileDesc//tei:idno[@type='Fraktion-Landesgruppe']" />
    </xsl:variable>
    <xsl:variable name="period">
        <xsl:value-of select=".//tei:profileDesc//tei:idno[@type='wp']" />
    </xsl:variable>
    <xsl:variable name="date-formatted">
        <xsl:call-template name="GetDate">
            <xsl:with-param name="protocol" select=".//tei:TEI" />
        </xsl:call-template>
    </xsl:variable>
    <!-- format date from yyyy-mm-dd to dd.mm.yyyy -->
    <!--    <xsl:variable name="date-formatted">
        <xsl:call-template name="MakeDate">
            <xsl:with-param name="date" select="$date" />
        </xsl:call-template>
    </xsl:variable>-->
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()" />
    </xsl:variable>

    <xsl:variable name="isEINL" select="boolean(//tei:teiHeader//tei:category[@xml:id='EINL'])" />
    <xsl:template match="/">
        <html class="h-100" data-date="{current-date()}">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <style>
                    .navBarNavDropdown ul li:nth-child(2) {
                    display: none !important;
                    }
                    .highlight {
                    background-color: rgb(246, 166, 35);
                    }
                    body {
                    overflow:hidden;
                    overflow-y:scroll;
                    }
                    main {
                    text-align: justify;
                    }
                    /* Details/Summary styling - keep marker and text on same line */
                    details summary {
                    display: flex;
                    align-items: center;
                    list-style: none;
                    }

                    details summary::marker,
                    details summary::-webkit-details-marker {
                    display: none;
                    }

                    details summary::before {
                    content: '▶';
                    display: inline-block;
                    margin-right: 0.5em;
                    transition: transform 0.2s;
                    }

                    details[open] summary::before {
                    transform: rotate(90deg);
                    }
                </style>
                <style>
                /* Hamburger Button */
        .menu-toggle {
            position: fixed;
            left: 20px;
            top: 20px;
            z-index: 1001;
            background-color: #white;
            border: none;
            padding: 10px;
            cursor: pointer;
            border-radius: 5px;
            width: 45px;
            height: 45px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }

        .menu-toggle:hover {
            background-color: #888;
        }

        .menu-toggle span {
            display: block;
            width: 25px;
            height: 3px;
            background-color: black;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        /* Hamburger Animation wenn offen */
        .menu-toggle.active span:nth-child(1) {
            transform: rotate(45deg) translate(7px, 7px);
        }

        .menu-toggle.active span:nth-child(2) {
            opacity: 0;
        }

        .menu-toggle.active span:nth-child(3) {
            transform: rotate(-45deg) translate(7px, -7px);
        }

        /* Overlay */
        .menu-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        .menu-overlay.active {
            opacity: 1;
            visibility: visible;
        }

        /* Sidebar Menu */
        .sidebar-menu {
            position: fixed;
            left: -320px;
            top: 0;
            width: 300px;
            height: 100vh;
            overflow-y: auto;
            background-color: #f5f5f5;
            padding: 80px 20px 20px 20px;
            border-right: 1px solid #ddd;
            z-index: 1000;
            transition: left 0.3s ease;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        }

        .sidebar-menu.active {
            left: 0;
        }

        /* Menu Items */
        .menu-item {
            margin: 5px 0;
        }

        .menu-item a {
            display: block;
            padding: 8px 12px;
            text-decoration: none;
            color: #333;
            border-radius: 4px;
            transition: all 0.2s ease;
            font-size: 14px;
            line-height: 1.4;
        }

        .menu-item a:hover {
            background-color: #e0e0e0;
            color: #0066cc;
            transform: translateX(5px);
        }

        /* Einrückung für verschachtelte Elemente */
        .menu-item[style*="margin-left"] a {
            border-left: 2px solid #ddd;
        }

        /* Content Bereich */
        .content {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Scrollbar Styling */
        .sidebar-menu::-webkit-scrollbar {
            width: 8px;
        }

        .sidebar-menu::-webkit-scrollbar-track {
            background: #f1f1f1;
        }

        .sidebar-menu::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 4px;
        }

        .sidebar-menu::-webkit-scrollbar-thumb:hover {
            background: #555;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar-menu {
                width: 280px;
                left: -300px;
            }

            .content {
                padding: 15px;
            }
        }
        </style>
                <script type="module" src="js/popupinfo.js"></script>
                <script type="module" src="js/customcheckbox.js"></script>
            </head>
            <body class="d-flex flex-column h-100 relative content">
                <div class="container mt-3 mb-3 content">
                    <xsl:call-template name="nav_bar" />

                    <div class="breadcrumbs mt-2">
                        <xsl:if test="not($isEINL)">
                            <!--fraktion-->
                            <xsl:variable name="partyurl">
                                <xsl:text>liste.html?kgparl[refinementList][party][0]=</xsl:text>
                                <xsl:value-of select="$party" />
                            </xsl:variable>
                            <xsl:variable name="periodurl">
                                <xsl:text>&amp;kgparl[refinementList][period][0]=</xsl:text>
                                <xsl:value-of select="$period" />
                            </xsl:variable>
                            <a href="{$partyurl}" class="kgparl-link" target="_self"
                                title="Zurück zur Startseite">
                                <xsl:value-of select="$party" />
                            </a>
                            <xsl:text> &gt; </xsl:text>
                            <!-- Wahlperiode -->
                            <a href="{$partyurl}{$periodurl}" class="kgparl-link" target="_self"
                                title="Zurück zur Startseite">
                                <xsl:value-of select="$period" />
                            </a>
                            <xsl:text> &gt; </xsl:text>
                            <!-- Sitzungsdatum -->
                            <xsl:value-of select="$date-formatted" />
                            <xsl:text> : </xsl:text>
                        </xsl:if>
                        
                        <!-- Titel -->
                        <xsl:value-of select="data(.//tei:titleStmt/tei:title[1])" />
                        <!-- Download Link and Divider with a pipe -->
                        <xsl:text> | </xsl:text>

                        <a class="btn btn-download"
                            href="./downloads/{$teiSource}.xml" target="_blank">
                            <!-- --> Download XML </a>
                    </div>
                    <hr />


                    <div id="sitzungs-info" class="mb-4">
                        <xsl:if test="not($isEINL)">
                            <h2><xsl:value-of select="$party" /> (<xsl:value-of select="$period" />.
                                WP)</h2>
                            <details>
                                <summary>
                                    <span class="fs-2 fw-normal"><xsl:value-of
                                            select="$date-formatted" />: <xsl:value-of
                                            select="$doc_title" /><sup
                                            title="Informationen und Zitierempfehlungen ein-/ausklappen">
                                        </sup></span>
                                </summary>
                                <xsl:call-template name="MakeCitation">
                                    <xsl:with-param name="entry" select="." />
                                    <xsl:with-param name="party" select="$party" />
                                    <xsl:with-param name="period" select="$period" />
                                    <xsl:with-param name="doc_title" select="$doc_title" />
                                </xsl:call-template>
                            </details>
                            <details id="sitzungsverlauf">
                                <summary>
                                    <span class="fs-2 fw-normal"> Sitzungsverlauf:<sup
                                            title="Sitzungsverlauf ein-/ausklappen">
                                        </sup></span>
                                </summary>
                                <xsl:call-template name="MakeList">
                                    <xsl:with-param name="entry" select="." />
                                </xsl:call-template>
                            </details>
                            <div id="hamburger-menu" class="hidden">
                                <div class="hamburger-icon">
                                    <span></span>
                                    <span></span>
                                    <span></span>
                                </div>
                                <nav id="menu-items" class="menu-items">
                                </nav>
                            </div>
                        </xsl:if>
                        <xsl:if test="$isEINL">
                            <details>
                                <summary>
                                    <span class="fs-2 fw-normal">
                                    Hinweis zum Gebrauch der digitalen Einleitung
                                    </span>
                                </summary>
                                <div class="d-block overflow-hidden px-2 info d-inline " style="background-color: var(  --color-background-light);">
                                    <xsl:apply-templates select=".//tei:front"/>
                                </div>
                            </details>
                        </xsl:if>
                    </div>
                    <br />
                    <nav id="sidebar-menu" class="sidebar-menu"></nav>
                    <main class="flex-shrink-0 position-relative">
    
                        <div class="lh-lg content" id="content-container">
                            <xsl:apply-templates select=".//tei:body"></xsl:apply-templates>
                            <div class="container" >
                        <p style="text-align:center;">
                            <hr id="footnotes-divider" />
                            <div id="footnotes-container">

                                <xsl:for-each select=".//tei:body//tei:note">
                                    <div class="footnotes d-flex" id="{local:makeId(.)}">
                                        <xsl:variable name="fn_id">
                                            <xsl:value-of select="@xml:id" />
                                        </xsl:variable>
                                        <xsl:element name="a">
                                            <xsl:attribute name="name">
                                                <xsl:text>fn</xsl:text>
                                                <xsl:number level="any" format="1"
                                                    count="tei:body//tei:note" />
                                            </xsl:attribute>

                                            <xsl:attribute name="href">
                                                <xsl:text>#fna_</xsl:text>
                                                <xsl:number level="any" format="1"
                                                    count="tei:body//tei:note" />
                                            </xsl:attribute>
                                            <span
                                                class="fn">
                                                <xsl:number level="any" format="1"
                                                    count="tei:body//tei:note" />
                                            </span>

                                        </xsl:element>
                                        <xsl:apply-templates />
                                        <a class="fn-back kgparl-link"
                                            href="#fnref_{$fn_id}">↑</a>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </p>

                    </div>
                        </div>
                        <div class="facets d-block w-25">
                            <aside>
                                <xsl:if test="//tei:body//tei:name[@type='Person']">
                                    <h2> Personen </h2>
                                    <xsl:call-template
                                        name="facets">
                                        <xsl:with-param name="entry" select="//tei:text" />
                                    </xsl:call-template>
                                </xsl:if>
                            </aside>
                        </div>
                        <xsl:for-each select="//tei:back">
                            <div class="tei-back">
                                <xsl:apply-templates />
                            </div>
                        </xsl:for-each>
                    </main>
                    
                    <xsl:call-template name="html_footer" />
                    <script src="js/editions.js"></script>

                    <!--                <script type="text/javascript" src="js/run.js"></script>-->
                </div>
            </body>
             <script>
                <xsl:if test="$isEINL">    
              <xsl:text disable-output-escaping="yes"><![CDATA[
    function initMenu() {
            // Erstelle Hamburger Button
            const toggleButton = document.createElement('button');
            toggleButton.className = 'menu-toggle';
            toggleButton.setAttribute('aria-label', 'Menü öffnen/schließen');
            toggleButton.innerHTML = '<span></span><span></span><span></span>';
            document.body.insertBefore(toggleButton, document.body.firstChild);

            // Erstelle Overlay
            const overlay = document.createElement('div');
            overlay.className = 'menu-overlay';
            document.body.insertBefore(overlay, document.body.firstChild);

            const menuContainer = document.getElementById('sidebar-menu');
            if (!menuContainer) return;

            // Toggle Funktion
            function toggleMenu() {
                toggleButton.classList.toggle('active');
                menuContainer.classList.toggle('active');
                overlay.classList.toggle('active');
                
                // Body Scroll verhindern wenn Menü offen
                if (menuContainer.classList.contains('active')) {
                    document.body.style.overflow = 'hidden';
                } else {
                    document.body.style.overflow = '';
                }
            }

            // Event Listeners
            toggleButton.addEventListener('click', toggleMenu);
            overlay.addEventListener('click', toggleMenu);

            // Generiere Menü-Inhalt
            generateMenu();

            // Schließe Menü bei Klick auf Link
            menuContainer.addEventListener('click', function(e) {
                if (e.target.tagName === 'A') {
                    toggleMenu();
                }
            });

            // ESC-Taste zum Schließen
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && menuContainer.classList.contains('active')) {
                    toggleMenu();
                }
            });
        }

        function generateMenu() {
            const menuContainer = document.getElementById('sidebar-menu');
            if (!menuContainer) return;
            
            menuContainer.innerHTML = '';
            
            const allDivs = document.querySelectorAll('div');
            const divsWithHeadings = Array.from(allDivs).filter(div => {
                const h1 = div.querySelector(':scope > h1[id]');
                return h1 !== null;
            });
            
            function createMenuItem(div, depth) {
                const h1 = div.querySelector(':scope > h1[id]');
                if (!h1) return null;
                
                const menuItem = document.createElement('div');
                menuItem.className = 'menu-item';
                menuItem.style.marginLeft = (depth * 20) + 'px';
                
                const link = document.createElement('a');
                link.href = '#' + h1.getAttribute('id');
                link.textContent = h1.textContent.trim();
                
                menuItem.appendChild(link);
                return menuItem;
            }
            
            function processDiv(parentDiv, depth, menuParent) {
                const childDivs = Array.from(parentDiv.children).filter(child => 
                    child.tagName === 'DIV' && child.querySelector(':scope > h1[id]')
                );
                
                childDivs.forEach(div => {
                    const menuItem = createMenuItem(div, depth);
                    if (menuItem) {
                        menuParent.appendChild(menuItem);
                        processDiv(div, depth + 1, menuParent);
                    }
                });
            }
            
            const topLevelDivs = divsWithHeadings.filter(div => {
                let parent = div.parentElement;
                while (parent && parent.tagName !== 'BODY') {
                    if (parent.tagName === 'DIV' && parent.querySelector(':scope > h1[id]')) {
                        return false;
                    }
                    parent = parent.parentElement;
                }
                return true;
            });
            
            topLevelDivs.forEach(div => {
                const menuItem = createMenuItem(div, 0);
                if (menuItem) {
                    menuContainer.appendChild(menuItem);
                    processDiv(div, 1, menuContainer);
                }
            });
        }
        
        // Smooth Scrolling
        document.addEventListener('click', function(e) {
            if (e.target.tagName === 'A' && e.target.hash) {
                e.preventDefault();
                const targetId = e.target.hash.substring(1);
                const targetElement = document.getElementById(targetId);
                if (targetElement) {
                    targetElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            }
        });

        // Initialisiere alles
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initMenu);
        } else {
            initMenu();
        }
        ]]>
                
    </xsl:text>
    </xsl:if>
    </script>
        </html>
    </xsl:template>
</xsl:stylesheet>
