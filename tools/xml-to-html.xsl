<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:str="http://exslt.org/strings"
                xmlns="http://www.w3.org/1999/xhtml"
                extension-element-prefixes="str"
                version="1.0">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="document" />
  </xsl:template>

  <xsl:template match="document">
    <xsl:text disable-output-escaping='yes'>
      &lt;!DOCTYPE html&gt;
    </xsl:text>
    <!-- Some of the prefixes are omitted, since they should be
         available by default:
         https://www.w3.org/2011/rdfa-context/rdfa-1.1 -->
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"
          prefix="dbr: http://dbpedia.org/resource/
                  home: https://defanor.uberspace.net/"
          typeof="dc:Text schema:Article foaf:Document sioc:Post">
      <head>
        <!-- Only title is required -->
        <title property="dc:title schema:name foaf:name sioc:name">
          <xsl:value-of select="@title" />
        </title>
        <xsl:if test="@description">
          <meta name="description"
                property="dc:description schema:description"
                content="{@description}" />
        </xsl:if>
        <xsl:if test="@keywords">
          <meta name="keywords"
                property="schema:keywords"
                content="{@keywords}" />
        </xsl:if>
        <xsl:if test="@created">
          <meta property="dc:created schema:dateCreated"
                datatype="schema:Date"
                content="{@created}" />
        </xsl:if>
        <xsl:if test="@published">
          <meta property="dc:issued schema:datePublished"
                datatype="schema:Date"
                content="{@published}" />
        </xsl:if>
        <xsl:if test="@modified">
          <meta property="dc:modified schema:dateModified sioc:last_activity_date"
                datatype="schema:Date"
                content="{@modified}" />
        </xsl:if>
        <xsl:if test="@primaryTopic">
          <link property="dc:subject schema:about foaf:primaryTopic"
                href="{@primaryTopic}" />
        </xsl:if>

        <!-- Additional topics -->
        <xsl:apply-templates select="topic" />

        <!-- Additional raw meta and links -->
        <xsl:apply-templates select="xhtml:meta" />
        <xsl:apply-templates select="xhtml:link" />

        <!-- The rest is fixed metadata -->
        <link property="dc:creator schema:creator foaf:maker sioc:has_creator"
              href="https://defanor.uberspace.net/about.xhtml#me" />
        <link property="dc:isPartOf schema:isPartOf sioc:has_container"
              href="https://defanor.uberspace.net/" />
        <style>
          body { max-width: 86ch; margin: auto; padding: 0ch 1ch 1ch 1ch;
          background: #061014; color: #c0d0d6; }
          img { max-width: 84ch; }
          a { color: #60b0a0; }
          a:visited { color: #60a0b0; }
        </style>
        <meta name="robots" content="noarchive" />
      </head>
      <body>
        <xsl:apply-templates mode="body" select="xhtml:body/*" />
        <footer>
          <xsl:if test="not(//notes)">
            <a href="https://defanor.uberspace.net/">defanor</a>,
            <time><xsl:copy-of select="substring(@created,0,8)" /></time>
            <xsl:if test="substring(@created,0,8) != substring(@modified,0,8)"> to <time><xsl:copy-of select="substring(@modified,0,8)" /></time></xsl:if>
          </xsl:if>
        </footer>
      </body>
    </html>
  </xsl:template>

  <!-- Additional topics -->
  <xsl:template match="topic">
    <link property="dc:subject schema:about foaf:topic sioc:topic"
          href="{@iri}" />
  </xsl:template>

  <!-- Additional raw meta and link elements -->
  <xsl:template match="xhtml:meta | xhtml:link">
    <xsl:copy-of select="." />
  </xsl:template>

  <xsl:template mode="body" match="notes">
    <xsl:variable name="notes" select="document(@src)" />
    <xsl:variable name="number" select="@number" />
    <dl>
      <xsl:apply-templates mode="note-index"
                           select="$notes/notes/note[$number=0 or position()&lt;=$number]">
         <xsl:with-param name="prefix"
                         select="@prefix" />
      </xsl:apply-templates>
    </dl>
  </xsl:template>

  <xsl:template mode="note-index" match="note">
    <xsl:param name="prefix" />
    <dt>
      <a href="{$prefix}/{@src}">
        <xsl:value-of select="document/@title" />
      </a>
    </dt>
    <dd>
      <xsl:value-of select="document/@description" />
      (<time><xsl:copy-of select="substring(document/@created,0,8)" /></time>
      <xsl:if test="substring(document/@created,0,8) != substring(document/@modified,0,8)"> to <time><xsl:copy-of select="substring(document/@modified,0,8)" /></time></xsl:if>)
    </dd>
  </xsl:template>

  <xsl:template mode="body" match="xhtml:h1|xhtml:h2|xhtml:h3|xhtml:h4|xhtml:h5">
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:value-of select="str:replace(text(),' ','_')"/>
      </xsl:attribute>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates mode="body" />
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="body" match="node()" priority="0">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates mode="body" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
