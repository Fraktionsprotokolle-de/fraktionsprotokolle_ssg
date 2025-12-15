<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:local="http://dse-static.foo.bar"
>

  <xsl:output method="xml" indent="yes" />

  <xsl:function name="local:makeId" as="xs:string">
    <xsl:param name="currentNode" as="node()" />
    <xsl:variable name="nodeCurrNr">
      <xsl:value-of select="count($currentNode//preceding-sibling::*) + 1" />
    </xsl:variable>
    <xsl:value-of select="concat(name($currentNode), '__', $nodeCurrNr)" />
  </xsl:function>

  <!-- caching -->
  <xsl:key name="persons-by-id" match="tei:person" use="@xml:id" />
  <xsl:key name="org-by-id" match="tei:org" use="@xml:id" />
  <xsl:key name="category-by-id" match="tei:category" use="@xml:id" />

  <!-- prefetch register files -->
  <xsl:variable name="persons" select="document('../data/indices/Personen.xml')" />
  <xsl:variable name="orgs" select="document('../data/indices/Organisationen.xml')" />

  <xsl:template name="translate-category">
    <!-- Input parameters: key (category key), index (optional index value) -->
    <xsl:param name="key" />
    <xsl:param name="categories" />
    <!-- Retrieve the category name from the listcategory.xml file using the provided key -->

    <xsl:variable name="name"
      select="key('category-by-id', $key, $categories)/tei:catDesc" />
    <!-- Normalize the category name -->
    <xsl:value-of select="normalize-space($name)" />
  </xsl:template>

  <!-- Template for translating a person key into the corresponding name -->
  <xsl:template name="translate-person">
    <!-- Input parameters: key (person key), index (optional index value) -->
    <xsl:param name="key" />
    <!-- Retrieve the person name from the listperson.xml file using the provided key -->

    <xsl:variable name="name"
      select="key('persons-by-id', $key, $persons)/tei:persName[1]" />
    <!-- Concatenate the forename and surname, and normalize the resulting string -->
    <xsl:choose>
      <xsl:when test="$name//tei:persName[data(@n)='1']/tei:reg">
        <xsl:value-of select="normalize-space($name//tei:persName[data(@n)='1']/tei:reg/text())" />
      </xsl:when>
      <xsl:when test="$name//tei:reg">
        <xsl:value-of select="normalize-space($name//tei:reg/text())" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="normalize-space(concat($name/tei:forename, ' ', $name//tei:roleName[not(@type='honorific')], ' ', $name/tei:surname))" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Template for translating an organization key into the corresponding name -->
  <xsl:template name="translate-org">
    <!-- Input parameters: key (organization key), index (optional index value) -->
    <xsl:param name="key" />
    <!-- Retrieve the organization name from the listorg.xml file using the provided key -->
    <xsl:variable name="name"
      select="key('orgs-by-id', $key, $orgs)/tei:orgName[@type='full']" />
    <!-- Normalize the organization name -->
    <xsl:value-of select="normalize-space($name)" />
  </xsl:template>

  <!-- Identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:TEI">
    <xsl:apply-templates />
  </xsl:template>


  <xsl:template match="tei:div">
    <div>
      <xsl:apply-templates />
    </div>
  </xsl:template>


  <xsl:template match="tei:list">
    <ul>
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="tei:item">
    <li class="display-flex">
      <xsl:apply-templates />
    </li>
  </xsl:template>

  <xsl:template match="tei:ref">
 

      <xsl:if test="not(@type='internal') and @target">
        <tei:target>
          <xsl:value-of select="@target" />
        </tei:target>
      </xsl:if>

      <xsl:if test="@type='internal'">
        <xsl:variable name="id" select="replace(@target, '#', '')" />
        <xsl:variable name="tokens" select="tokenize($id, '_')" />
        <xsl:variable name="filename">
        <xsl:if test="count($tokens) gt 1">
          <xsl:value-of select="concat($tokens[1], '_', $tokens[2], '_', $tokens[3], '.html') " />
          </xsl:if>
          <xsl:if test="count($tokens) le 1">
            <xsl:value-of select="@target " />
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="leng" select="count($tokens)" />
        <xsl:variable name="target">
          <xsl:choose>
            <xsl:when test="$leng = 5">
              <xsl:value-of select="concat($filename, '#',$id )" />
            </xsl:when>
            <xsl:when test="$leng = 4">
              <xsl:if test="contains($id, 'FN')">
                <xsl:value-of select="concat($filename, '?fn=',$id )" />
              </xsl:if>
              <xsl:if test="not(contains($id, 'FN'))">
                <xsl:value-of select="concat($filename, '?div=', $id )" />
              </xsl:if>
            </xsl:when>
            <xsl:when test="$leng = 3">
              <xsl:value-of select="$filename" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat($filename, '#', $id )" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="url">
          <xsl:value-of select="$target" />
        </xsl:variable>
        <a href="{$url}" class="kgparl-link" target="_blank">
          <xsl:value-of select="." />
          </a>
      </xsl:if>

  </xsl:template>

  <xsl:template match="tei:hi">
    <tei:hi>
      <xsl:choose>
        <xsl:when test="@rend='bold'">
          <tei:bold />
        </xsl:when>
        <xsl:when test="@rend='italic'">
          <tei:italic />
        </xsl:when>
        <xsl:when test="@rend='underline'">
          <tei:underline />
        </xsl:when>
        <xsl:when test="@rendition='#smcap'">
          <span class="small-caps">
            <xsl:value-of select="." />
          </span>
        </xsl:when>
      </xsl:choose>
     
    </tei:hi>
  </xsl:template>


  <xsl:template match="tei:pb">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:lg">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:l">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:figure">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:graphic">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:table">
    <table class="table table-striped table-hover">
      <xsl:apply-templates />
    </table> 
  </xsl:template>

  <xsl:template match="tei:row">
    <tr>
    <xsl:apply-templates />
    </tr>
  </xsl:template>

  <xsl:template match="tei:cell">
    <td>
    <xsl:apply-templates />
    </td>
  </xsl:template>

  <xsl:template match="tei:bibl">

    <xsl:choose>

      <xsl:when test="@type='bgbl'">

        <xsl:variable name="parts" select="tokenize(./tei:ref[1]/@target, '/')" />
        <xsl:variable name="url"
          select="concat('https://offenegesetze.de/veroeffentlichung/bgbl', $parts[2], '/', $parts[1], '/', $parts[3])" />
        <a href="{$url}" class="kgparl-link" target="_new">
          <xsl:value-of select="@target" />
        </a>
      </xsl:when>
      <xsl:when test="@type='btp'">
        <xsl:variable name="parts" select="tokenize(./tei:ref[1]/@target, '/')" />
        <xsl:variable name="wp"
          select="if(string-length($parts[1]) = 1) then concat('0', $parts[1]) else $parts[1]" />
        <xsl:variable name="meeting"
          select="concat( substring('000', string-length($parts[2]) +1 ), $parts[2])" />
        <xsl:variable name="url"
          select="concat('https://dserver.bundestag.de/btp/' , $wp , '/', $wp,  $meeting ,'.pdf')" />
        <a href="{$url}" class="kgparl-link" target="_new">
          <xsl:value-of select="." />
        </a>
      </xsl:when>
      <xsl:when test="@type='btd'">
        <xsl:variable name="parts" select="tokenize(./tei:ref[1]/@target, '/')" />
        <xsl:variable name="meeting"
          select="concat( substring('00000', string-length($parts[2]) +1 ), $parts[2])" />
        <xsl:variable name="prefix"
          select="substring($meeting, 1, 3)" />
        <xsl:variable name="url"
          select="concat('https://dserver.bundestag.de/btd/' , $parts[1], '/', $prefix, '/', $parts[1], $meeting, '.pdf')" />
        <a href="{$url}" class="kgparl-link" target="_new">
          <xsl:value-of select="." />
        </a>
      </xsl:when>
      <xsl:when test="@type">
        <xsl:value-of select="." />
      </xsl:when>
      <xsl:otherwise>
        <ul>
          <xsl:apply-templates/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:note">
    <xsl:variable name="notecounter">
      <xsl:number level="any" format="1" count="tei:seg[@type='note']" />
    </xsl:variable>
    <xsl:variable name="fn">
      <xsl:number level="any" format="1" count="tei:note" />
    </xsl:variable>
    <xsl:variable name="fn_ref">
      <xsl:value-of select="concat('fnref_', ./@xml:id)" />
    </xsl:variable>
    <xsl:variable name="fn-id">
      <xsl:value-of select="concat('fn', $notecounter)" />
    </xsl:variable>
    <span class="text-decoration-none text-start seg-note fn" rel="footnote">

      <popup-info>
        <xsl:attribute name="data-html">false</xsl:attribute>

        <xsl:attribute name="data-title">
          <xsl:apply-templates />

        </xsl:attribute>

        <a href="#{$fn-id}" class="seg-note-link fn" rel="footnote" id="{$fn_ref}">
          <xsl:value-of select="$notecounter" />
        </a>
      </popup-info>

    </span>
  </xsl:template>
  <xsl:template match="tei:seg[@type='note']">
    <xsl:choose>
      <xsl:when test="normalize-space()">
        <span class="note-segment" onclick="">
          <xsl:apply-templates />
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:p[parent::tei:note]">
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="tei:p[parent::tei:item]">
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="tei:name[@type='Person'][@role='Erwaehnung']">
    <span class="fst-italic d-inline-block" aria-haspopup="true" id="{@ref}">
      <xsl:variable name="name">
        <xsl:call-template name="translate-person">
          <xsl:with-param name="key" select="replace(@ref, '#', '')" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="id">
        <xsl:value-of select="replace(@ref, '#', '')" />
      </xsl:variable>
      <xsl:call-template name="makePopover">
        <xsl:with-param name="title" select="$name" />
        <xsl:with-param name="content" select="$id" />
        <xsl:with-param name="html" select="true()" />
        <xsl:with-param name="text" select="." />
      </xsl:call-template>
    </span>
  </xsl:template>
  <xsl:template match="tei:name[@type='Person'][@role='Sprecher']">
    <span class="fw-bold" id="{@ref}" aria-haspopup="true">
      <span slot="content" />
      <xsl:variable name="name">
        <xsl:call-template name="translate-person">
          <xsl:with-param name="key" select="replace(@ref, '#', '')" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="id">
        <xsl:value-of select="replace(@ref, '#', '')" />
      </xsl:variable>
      <xsl:call-template name="makePopover">
        <xsl:with-param name="title" select="$name" />
        <xsl:with-param name="content" select="$id" />
        <xsl:with-param name="html" select="true()" />
        <xsl:with-param name="text" select="." />
      </xsl:call-template>
    </span>
  </xsl:template>
  <xsl:template match="tei:head">
    <xsl:choose>
      <xsl:when test="parent::tei:div[@type='SVP']">
        <xsl:variable name="corresp" select="parent::tei:div/@xml:id" />
        <h1 class="text-start fw-bold" id="{$corresp}">
          <xsl:apply-templates />
        </h1>
      </xsl:when>
      <xsl:when test="parent::div[@type='Anwesenheitsliste']">
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="corresp" select="parent::tei:div/@xml:id" />
        <h1 class="text-start fw-bold" id="{$corresp}">
          <xsl:apply-templates />
        </h1>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="makePopover">
    <xsl:param name="title" />
    <xsl:param name="content" />
    <xsl:param name="html" />
    <xsl:param name="text" />
    <popup-info>
      <xsl:attribute name="data-html">true</xsl:attribute>
      <xsl:attribute name="data-title">
        <xsl:value-of select="$title" />
      </xsl:attribute>
      <xsl:attribute name="data-content">
        <xsl:text disable-output-escaping="yes">&lt;a class='kgparl-link' href='</xsl:text>
        <xsl:value-of select="$content" />
        <xsl:text disable-output-escaping="yes">.html'&gt;</xsl:text>
        <xsl:text>Weitere Daten</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
      </xsl:attribute>

      <xsl:value-of select="$text" />
    </popup-info>
  </xsl:template>

  <xsl:template name="facets">
    <xsl:param name="entry" />
    <xsl:variable name="facet-list"
      select="$entry//tei:name[@type='Person']" />
    <ul>
      <xsl:for-each-group select="$facet-list" group-by="@ref">
        <xsl:sort select="current-grouping-key()" />
        <xsl:variable name="facet-key">
          <xsl:value-of select="replace(@ref, '#','')" />
        </xsl:variable>
        <xsl:variable name="facet-name"
          select="key('persons-by-id', $facet-key, $persons)/tei:persName[1]/tei:reg" />
        <li>
          <custom-checkbox>
            <xsl:attribute name="key">
              <xsl:value-of select="$facet-key" />
            </xsl:attribute>
            <xsl:attribute name="color">
              <xsl:text>rgb(4,130,99)</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="$facet-name" />
          </custom-checkbox>
        </li>
      </xsl:for-each-group>
    </ul>
  </xsl:template>

  <xsl:template name="MakeList">
    <xsl:param name="entry" />
    <div class="d-block overflow-hidden px-2 info d-inline"
      style="background-color:  var(  --color-background-light);">
      <ul id="svplist">
        <xsl:for-each select="$entry//tei:text//tei:list[@type='SVP']/tei:item">
          <li>
            <a href="#{replace(./@corresp, '#', '')}" class="kgparl-link">
              <xsl:value-of select="./text()" />
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>
  <xsl:template name="MakeCitation">
    <xsl:param name="entry" />
    <xsl:param name="party" />
    <xsl:param name="period" />
    <xsl:param name="doc_title" />
    <xsl:variable name="header" select="root($entry)//tei:teiHeader" />
    <xsl:variable name="categories"
      select="$header//tei:taxonomy[@xml:id='FP-Dokumenttyp']" />
    <xsl:variable name="session"
      select="$header/tei:profileDesc[1]/tei:creation[1]/tei:idno[1]/tei:idno[@type='sitzungsabfolge']">
    </xsl:variable>
    <xsl:variable name="title"
      select="data($header//tei:teiHeader//tei:fileDesc/tei:titleStmt/tei:title[@level='a'])" />
    <xsl:choose>
      <xsl:when test="(data($header//tei:teiHeader//tei:taxonomy/tei:category/@xml:id) = 'EINL')">
        <h2>
          <xsl:value-of select="$title" />
        </h2>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="type"
          select="data($header/tei:profileDesc[1]/tei:textClass[1]/tei:catRef[1]/@scheme)" />
        <xsl:variable name="amount"
          select="$header/descendant-or-self::tei:fileDesc[1]/tei:sourceDesc[1]/tei:listObject[1]/tei:object[1]/tei:physDesc[1]/tei:objectDesc[1]/tei:supportDesc/tei:extent" />
        <xsl:variable name="editor_count"
          select="count($header/descendant-or-self::tei:fileDesc[1]/tei:titleStmt[1]/tei:editor[1]/tei:name)" />
        <!-- calculated date -->
        <xsl:variable name="date">
          <xsl:choose>
            <xsl:when test="$header//tei:profileDesc[1]/tei:creation[1]/tei:date[1]/@when">
              <xsl:value-of select="$header/tei:profileDesc[1]/tei:creation[1]/tei:date[1]/@when" />
            </xsl:when>
            <xsl:when test="$header/tei:profileDesc[1]/tei:creation[1]/tei:date[1]/@from">
              <xsl:value-of select="$header/tei:profileDesc[1]/tei:creation[1]/tei:date[1]/@from" />
            </xsl:when>
            <xsl:otherwise />
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="date_array" select="tokenize($date, '-')" />
        <xsl:variable name="date_final">
          <xsl:if test="$date">
            <!-- if date is available, format date from yyyy-mm-dd to dd.mm.yyyy -->
            <xsl:variable name="formated_Date">
              <xsl:call-template name="MakeDate">
                <xsl:with-param name="date" select="$date" />
              </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="$formated_Date" />
          </xsl:if>
        </xsl:variable>
        <!-- Persons listed as csv -->
        <xsl:variable name="editor">
          <xsl:for-each
            select="$header//tei:fileDesc/tei:titleStmt/tei:editor/tei:name[@type='Person']">
            <xsl:choose>
              <xsl:when test="position() > 1">
                <xsl:text>, </xsl:text>
                <xsl:call-template name="translate-person">
                  <xsl:with-param name="key"
                    select="replace(@ref, '#', '')" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="translate-person">
                  <xsl:with-param name="key" select="replace(@ref, '#', '')" />
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>


          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="lead">
          <xsl:for-each
            select="$header//tei:profileDesc[1]/tei:creation[1]/tei:name[@type='Person']">
            <xsl:call-template name="translate-person">
              <xsl:with-param name="key"
                select="replace(@ref, '#', '')" />
            </xsl:call-template>
          </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="object"
          select="$header/tei:fileDesc[1]/tei:sourceDesc[1]/tei:listObject[1]/tei:object[1]/tei:objectIdentifier[1]/tei:objectName[1]/text()" />
        <xsl:variable name="isArticle"
          select="exists($header/tei:fileDesc[1]/tei:sourceDesc[1]/tei:listObject[1]/tei:object[1]/tei:objectIdentifier[1]/tei:altIdentifier[1]/tei:idno[1])" />
        <xsl:variable name="altOrigin">
          <xsl:if test="$isArticle">
            <xsl:value-of
              select="$header/tei:fileDesc[1]/tei:sourceDesc[1]/tei:listObject[1]/tei:object[1]/tei:objectIdentifier[1]/tei:altIdentifier[1]/tei:idno[1]/text()" />
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="origin">
          <xsl:choose>
            <xsl:when test="$isArticle">
              <xsl:value-of select="concat($object, ', ', $altOrigin)" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of
                select="$header/tei:fileDesc[1]/tei:sourceDesc[1]/tei:listObject[1]/tei:object[1]/tei:objectIdentifier[1]/tei:institution[1]/text()" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="origin_nr"
          select="$header/tei:fileDesc[1]/tei:sourceDesc[1]/tei:listObject[1]/tei:object[1]/tei:objectIdentifier[1]/tei:idno[1]/text()" />
        <xsl:variable name="template">
          <xsl:if test="not($isArticle)">
            <xsl:value-of
              select="concat($header/tei:fileDesc[1]/tei:sourceDesc[1]/tei:listObject[1]/tei:object[1]/tei:physDesc[1]/tei:objectDesc[1]/tei:supportDesc[1]/tei:support[1]/text(), '.')" />
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="duration"
          select="$header/tei:profileDesc[1]/tei:creation[1]/tei:date[1]/time[3]/@dur" />
        <xsl:variable name="location"
          select="$header/tei:profileDesc[1]/tei:creation[1]/tei:name[@type='Ort']/text()" />

        <!-- transformed date -->
        <xsl:variable name="from"
          select="substring($header/tei:profileDesc[1]/tei:creation[1]/tei:date[1]/tei:time[@type='start']/@when, 1, 5)" />
        <xsl:variable name="to"
          select="substring($header/tei:profileDesc[1]/tei:creation[1]/tei:date[1]/tei:time[@type='end']/@when, 1, 5)" />

        <!-- Make Protocol type cache -->

        <xsl:variable name="protocol_"
          select="replace($header//tei:profileDesc[1]//tei:textClass/tei:catRef/@target, '#', '')" />


        <xsl:variable name="protocol">
          <xsl:call-template name="translate-category">
            <xsl:with-param name="key" select="$protocol_" />
            <xsl:with-param name="categories" select="$categories" />
          </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="version_date">
          <xsl:call-template name="MakeDate">
            <xsl:with-param name="date"
              select="$header/tei:revisionDesc[1]/tei:change[1]/@when" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="version">
          <xsl:if test="$header/tei:revisionDesc[1]/tei:change[1]/text()">
            <xsl:value-of select="$header/tei:revisionDesc[1]/tei:change[1]/text()" />
          </xsl:if>
        </xsl:variable>

        <xsl:variable name="document" select="tokenize(base-uri($header), '/')" />
        <xsl:variable name="doc" select="$document[last()]" />

        <div class="d-block overflow-hidden px-2 info d-inline"
          style="background-color: rgb(250, 250, 250);">
          <b>Vorlage:</b><xsl:text> </xsl:text><xsl:value-of
            select="$origin" />, <xsl:value-of
            select="$origin_nr" />. <xsl:value-of select="$template" /><br /> <b>Titel der
            Archivalie:</b> »<xsl:value-of select="$object" />«. <xsl:if test="$amount">
            <b>Umfang:</b><xsl:text> </xsl:text><xsl:value-of
              select="$amount" />. </xsl:if>

  <xsl:if
            test="$duration">
            <b>Dauer:</b><xsl:text> </xsl:text><xsl:value-of select="$duration" />. </xsl:if><br />
  <xsl:if
            test="$from">
            <b>Beginn:</b><xsl:text> </xsl:text><xsl:value-of select="$from" /> Uhr. </xsl:if>
  <xsl:if
            test="$to">
            <b>Ende:</b><xsl:text> </xsl:text><xsl:value-of select="$to" /> Uhr. </xsl:if> <b>
          Sitzungsvorsitz:</b><xsl:text> </xsl:text><xsl:value-of
            select="$lead" />. <b>Ort:</b><xsl:text> </xsl:text><xsl:value-of
            select="$location" />.<br /> <b>Protokolltyp:</b><xsl:text> </xsl:text><xsl:value-of
            select="$protocol" />.<br />
  <br /> <b>Ediert durch:</b><xsl:text> </xsl:text><p><xsl:value-of
              select="$editor" />.</p><br />
  <xsl:if
            test="string-length($version) > 0">
            <b>Version:</b> <xsl:value-of select="$version" />, <xsl:value-of
              select="$version_date" />.<br />
          </xsl:if> <b>Zitationsvorschlag:</b> <p>
            <xsl:value-of select="$party" />, <xsl:value-of select="$period" />. WP, <xsl:if
              test="number($session) >= 2"> (<xsl:value-of select="$session" />. Sitzung) </xsl:if>
    <xsl:value-of
              select="$doc_title" /> am <xsl:value-of select="$date_final" /> bearb. v. <xsl:value-of
              select="$editor" />. In: Editionsprogramm »Fraktionen im Deutschen Bundestag
          1949–2005«, online. <xsl:text>https://www.fraktionsprotokolle.de</xsl:text>/<xsl:value-of select="$doc" /> (abgerufen am <xsl:value-of
              select="format-date(current-date(), '[D01].[M01].[Y0001]')" />). </p>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="MakeDate">
    <xsl:param name="date" />
    <xsl:choose>
      <xsl:when test="string-length($date) = 10">
        <xsl:value-of select="format-date(xs:date($date), '[D01].[M01].[Y]')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$date" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Helper -->
  <xsl:template name="GetParty">
    <xsl:param name="protocol" />
    <xsl:value-of select="$protocol//tei:profileDesc//tei:idno[@type='Fraktion-Landesgruppe']" />
  </xsl:template>

  <xsl:template name="PureDate">
    <xsl:param name="protocol" />

    <xsl:choose>
      <xsl:when test="$protocol//tei:profileDesc[1]/tei:creation[1]/tei:date[1]/@when">
        <xsl:value-of select="$protocol//tei:profileDesc[1]/tei:creation[1]/tei:date[1]/@when" />
      </xsl:when>
      <xsl:when test="$protocol//tei:profileDesc[1]/tei:creation[1]/tei:date[1]/@from">
        <xsl:value-of select="$protocol//tei:profileDesc[1]/tei:creation[1]/tei:date[1]/@from" />
      </xsl:when>
      <xsl:otherwise />
    </xsl:choose>
  </xsl:template>

  <xsl:template name="GetDate">
    <xsl:param name="protocol" />
    <xsl:variable name="date">
      <xsl:call-template name="PureDate">
        <xsl:with-param name="protocol" select="$protocol" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="date_array" select="tokenize($date, '-')" />
    <xsl:variable name="date_final">
      <xsl:if test="$date">
        <!-- if date is available, format date from yyyy-mm-dd to dd.mm.yyyy -->
        <xsl:variable name="formated_Date">
          <xsl:call-template name="MakeDate">
            <xsl:with-param name="date" select="$date" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$formated_Date" />
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="$date_final" />
  </xsl:template>

  <xsl:template name="GetPeriod">
    <xsl:param name="protocol" />
    <xsl:value-of select="$protocol//tei:profileDesc//tei:idno[@type='wp']" />
  </xsl:template>
</xsl:stylesheet>
