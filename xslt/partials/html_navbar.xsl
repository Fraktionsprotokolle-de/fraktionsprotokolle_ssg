<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
   <!ENTITY copy "&#169;">
   <!ENTITY nbsp "&#160;">
   <!ENTITY ndash "&#8211;">
]>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
   <xsl:template match="/" name="nav_bar">
      <div class="container-fluid">
         <header class="text-black">
            <div class="ps-0">
               <div class="row mx-0">
                  <div class="col-6 text-start ps-0 lh-1">
                     <div>
                        <p class="fw-bold fs-2 mb-0 "> Editionsprogramm: Fraktionen im<wbr />
                           Deutschen Bundestag 1949–2005 </p>
                        <p class="claim h3"> Historisch-digitale Quellenedition der Protokolle von
                           Fraktionen<wbr /> und Gruppen im Deutschen Bundestag </p>
                     </div>
                  </div>
                  <div class="col-6 text-end">
                     <div>
                        <a type="button" class="btn" title="Startseite" href="index.html">
                           <img class="logo" height="80"
                              src="./images/KGParl_titel.png" alt="logo" />
                        </a>
                     </div>
                  </div>
               </div>
            </div>
         </header>

         <div class="row mx-0">
            <nav class="navbar navbar-expand-xxl navbar-light bg-light">
               <div>
                  <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                     data-bs-target="#navbarNav"
                     aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                     <span
                        class="navbar-toggler-icon"></span>
                  </button>
                  <div class="collapse navbar-collapse" id="navbarNav">
                     <ul class="navbar-nav mx-auto">
                        <li class="nav-item px-3">
                           <a class="nav-link" href="/">Startseite</a>
                        </li>
                        <li class="nav-item px-3">
                           <a class="nav-link" href="/liste.html">Protokolle</a>
                        </li>
                        <li class="nav-item px-3">
                           <a class="nav-link" href="/kalender.html">Kalender</a>
                        </li>
                        <li class="nav-item dropdown px-3">
                           <a class="nav-link dropdown-toggle" href="#"
                              id="verzeichnisseDropdown" role="button" data-bs-toggle="dropdown"
                              aria-expanded="false">Verzeichnisse</a>
                           <ul class="dropdown-menu" aria-labelledby="verzeichnisseDropdown">
                              <li>
                                 <a class="dropdown-item" href="personenregister.html">
                                    Personenregister</a>
                              </li>
                              <li>
                                 <a class="dropdown-item" href="literaturverzeichnis.html">
                                    Literaturverzeichnis</a>
                              </li>
                           </ul>
                        </li>
                        <li class="nav-item px-3">
                           <a class="nav-link" href="/einleitungen.html">Einleitungen</a>
                        </li>
                        <li class="nav-item dropdown px-3">
                           <a class="nav-link dropdown-toggle" href="#"
                              id="projektDropdown" role="button" data-bs-toggle="dropdown"
                              aria-expanded="false">Zur Edition, Daten &amp; Code</a>
                           <ul class="dropdown-menu" aria-labelledby="projektDropdown">
                              <li>
                                 <a class="dropdown-item" href="projekt.html">Projekt</a>
                              </li>
                              <li>
                                 <a class="dropdown-item" href="aktuelles.html">Aktuelles</a>
                              </li>
                              <li>
                                 <a class="dropdown-item" href="#">Editionshinweise</a>
                              </li>
                              <li>
                                 <a class="dropdown-item" href="forschung.html">
                                    Forschungsrelevanz</a>
                              </li>
                              <li>
                                 <a class="dropdown-item" href="mitarbeiter.html">Mitarbeiterinnen
                                    und Mitarbeiter</a>
                              </li>
                              <li>
                                 <a class="dropdown-item" href="editionsbeirat.html">
                                    Editionsbeirat</a>
                              </li>
                              <li>
                                 <a class="dropdown-item"
                                    href="https://github.com/Fraktionsprotokolle-de/fraktionsprotokolle_web"
                                    target="_blank"
                                    aria-label="GitHub">GitHub Repositorium</a>
                              </li>
                           </ul>
                        </li>
                        <li class="nav-item px-3">
                           <a class="nav-link" href="#">Hilfe</a>
                        </li>
                     </ul>
                     <div class="navbar-nav language-switcher d-none">
                        <button type="button" class="nav-link" href="#"> deutsch <svg
                              xmlns="http://www.w3.org/2000/svg" width="24" height="16"
                              viewBox="0 0 24 16">
                              <rect width="24" height="5.33" fill="#000000" />
                              <rect width="24" height="5.33" y="5.33" fill="#FF0000" />
                              <rect width="24" height="5.33" y="10.67" fill="#FFD700" />
                           </svg></button>
                        <button type="button" class="nav-link" href="#"> english <svg
                              xmlns="http://www.w3.org/2000/svg" width="24" height="16"
                              viewBox="0 0 60 40">
                              <rect width="60" height="40" fill="#00247d" />
                              <rect x="26" width="8" height="40" fill="#cf142b" />
                              <rect y="16" width="60" height="8" fill="#cf142b" />
                              <rect x="24" width="4" height="40" fill="#fff" />
                              <rect x="32" width="4" height="40" fill="#fff" />
                              <rect y="14" width="60" height="4" fill="#fff" />
                              <rect y="22" width="60" height="4" fill="#fff" />
                              <polygon points="0,0 4,0 30,18 30,22 0,40 0,36 24,20 0,4"
                                 fill="#cf142b" />
                              <polygon points="60,0 56,0 30,18 30,22 60,40 60,36 36,20 60,4"
                                 fill="#cf142b" />
                              <polygon points="0,0 2,0 30,17 30,23 0,40 0,38 27,20 0,2" fill="#fff" />
                              <polygon points="60,0 58,0 30,17 30,23 60,40 60,38 33,20 60,2"
                                 fill="#fff" />
                           </svg></button>
                     </div>
                  </div>
               </div>
            </nav>
         </div>
      </div>
   </xsl:template>
</xsl:stylesheet>
