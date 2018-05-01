<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
                version="1.0">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates select="document" />
  </xsl:template>

  <xsl:template match="document">
    <xsl:text disable-output-escaping='yes'>
      &lt;!DOCTYPE html&gt;
    </xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"
          prefix="dc: http://purl.org/dc/terms/
                  rdfs: http://www.w3.org/1999/02/22-rdf-syntax-ns#
                  schema: http://schema.org/
                  foaf: http://xmlns.com/foaf/0.1/
                  dbr: http://dbpedia.org/resource/
                  home: https://defanor.uberspace.net/"
          typeof="dc:Text schema:Article foaf:Document">
      <head>
        <!-- Only title is required -->
        <title property="dc:title schema:name foaf:name">
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
          <meta property="dc:modified schema:dateModified"
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
        <link property="dc:creator schema:creator foaf:maker"
              href="https://defanor.uberspace.net/about.xhtml#me" />
        <link property="dc:isPartOf schema:isPartOf"
              href="https://defanor.uberspace.net/" />
        <link rel="stylesheet" title="Dark, blueish"
              href="/xhtml-rdfa-dark.css" />
        <link rel="alternate stylesheet" title="No colourisation"
              href="/xhtml-rdfa.css" />
        <link rel="alternate stylesheet" title="Light, beige"
              href="/xhtml-rdfa-light.css" />
        <meta name="robots" content="noarchive" />
      </head>
      <xsl:apply-templates mode="body" select="xhtml:body" />
    </html>
  </xsl:template>

  <!-- Additional topics -->
  <xsl:template match="topic">
    <link property="dc:subject schema:about foaf:topic"
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
    </dd>
  </xsl:template>

  <xsl:template mode="body" match="node()" priority="0">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates mode="body" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
