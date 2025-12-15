<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
   <!ENTITY copy "&#169;">
]>
<xsl:stylesheet
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="#all"
   version="2.0">
   <xsl:template match="/" name="html_footer">
      <footer class="footer mt-auto py-3 bg-dark text-white">
         <div class="container">
            <div class="row fs-4">
               <div class="col-md-6">
                  <p class="mb-0">© KGParl 2025</p>
               </div>
               <div class="col-md-6 text-md-end px-5">
                  <a href="#" class="text-white me-2">Impressum</a>
                  <a href="#"
                     class="text-white me-2">Datenschutz</a>
                  <a href="#" class="text-white me-2">Kontakt</a>
                  <a href="#"
                     class="text-white">Tracking</a>
               </div>
            </div>
         </div>
      </footer>
      <footer class="footer mt-auto koop">
         <strong>Kooperationspartner:</strong>
         <div class="koop">
            <a href="http://www.kas.de/wf/de/42.7/" target="_blank" data-toggle="tooltip"
               title="Archiv für Christlich-Demokratische Politik (ACDP)">
               <img class="adenauer"
                  src="//www.fraktionsprotokolle.de/exist/apps/Fraktionsprotokolle/resources/images/adenauer_Footer_activ.jpg"
                  alt="Adenauer logo" />
            </a>
            <a href="https://www.fes.de/archiv/adsd_neu/index.htm" target="_blank"
               data-toggle="tooltip" title="Archiv der sozialen Demokratie (AdsD)">
               <img class="ebert"
                  src="//www.fraktionsprotokolle.de/exist/apps/Fraktionsprotokolle/resources/images/ebert_Footer_activ.jpg"
                  alt="Ebert logo" />
            </a>
            <a href="https://www.freiheit.org/content/archiv-des-liberalismus" target="_blank"
               data-toggle="tooltip" title="Archiv des Liberalismus (AdL)">
               <img class="fnf"
                  src="//www.fraktionsprotokolle.de/exist/apps/Fraktionsprotokolle/resources/images/FNF_Logo_D.svg"
                  alt="FNF logo" />
            </a>
            <a href="             http:// www.boell.de/ de/ stiftung/ archiv-gruenes-gedaechtnis"
               target=" _blank" data-toggle=" tooltip" title=" Archiv Grünes Gedächtnis (AGG)">
               <img class=" hbs"
                  src="//www.fraktionsprotokolle.de/exist/apps/Fraktionsprotokolle/resources/images/boell_Footer_activ.jpg"
                  alt=" HBS logo" />
            </a>
            <a href=" https:// www.hss.de/ archiv/" target=" _blank" data-toggle=" tooltip"
               title=" Archiv für Christlich-Soziale Politik (ACSP)">
               <img class=" seidel"
                  src="//www.fraktionsprotokolle.de/exist/apps/Fraktionsprotokolle/resources/images/seidel_Footer_activ.jpg"
                  alt=" Seidel logo" />
            </a>
         </div>
      </footer>
      <script src="https://code.jquery.com/jquery-3.6.3.min.js"
         integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin=" anonymous"></script>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
         integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
         crossorigin=" anonymous"></script>
      <script src="js/editions.js"></script>
   </xsl:template>
   <xsl:template name=" html_footer_scriptless">
      <footer class="footer mt-auto py-3 bg-dark text-white">
         <div class="container">
            <div class="row fs-6">
               <div class="col-md-6">
                  <p class="mb-0">© KGParl 2025</p>
               </div>
               <div class="col-md-6 text-md-end px-5">
                  <a href="#" class="text-white me-2">Impressum</a>
                  <a href="#"
                     class="text-white me-2">Datenschutz</a>
                  <a href="#" class="text-white me-2">Kontakt</a>
                  <a href="#"
                     class="text-white">Tracking</a>
               </div>
            </div>
         </div>
      </footer>
      <footer class="footer mt-auto koop">
         <strong>Kooperationspartner:</strong>
         <div class="koop">
            <a href="http://www.kas.de/wf/de/42.7/" target="_blank" data-toggle="tooltip"
               title="Archiv für Christlich-Demokratische Politik (ACDP)">
               <img class="adenauer"
                  src="//www.fraktionsprotokolle.de/exist/apps/Fraktionsprotokolle/resources/images/adenauer_Footer_activ.jpg"
                  alt="Adenauer logo" />
            </a>
            <a href="https://www.fes.de/archiv/adsd_neu/index.htm" target="_blank"
               data-toggle="tooltip" title="Archiv der sozialen Demokratie (AdsD)">
               <img class="ebert"
                  src="//www.fraktionsprotokolle.de/exist/apps/Fraktionsprotokolle/resources/images/ebert_Footer_activ.jpg"
                  alt="Ebert logo" />
            </a>
            <a href="https://www.freiheit.org/content/archiv-des-liberalismus" target="_blank"
               data-toggle="tooltip" title="Archiv des Liberalismus (AdL)">
               <img class="fnf"
                  src="//www.fraktionsprotokolle.de/exist/apps/Fraktionsprotokolle/resources/images/FNF_Logo_D.svg"
                  alt="FNF logo" />
            </a>
            <a href="             http:// www.boell.de/ de/ stiftung/ archiv-gruenes-gedaechtnis"
               target=" _blank" data-toggle=" tooltip" title=" Archiv Grünes Gedächtnis (AGG)">
               <img class=" hbs"
                  src="//www.fraktionsprotokolle.de/exist/apps/Fraktionsprotokolle/resources/images/boell_Footer_activ.jpg"
                  alt=" HBS logo" />
            </a>
            <a href=" https:// www.hss.de/ archiv/" target=" _blank" data-toggle=" tooltip"
               title=" Archiv für Christlich-Soziale Politik (ACSP)">
               <img class=" seidel"
                  src="//www.fraktionsprotokolle.de/exist/apps/Fraktionsprotokolle/resources/images/seidel_Footer_activ.jpg"
                  alt=" Seidel logo" />
            </a>
         </div>
      </footer>
   </xsl:template>
</xsl:stylesheet>
