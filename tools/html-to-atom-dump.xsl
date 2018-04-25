<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/2005/Atom"
                version="1.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="baseIRI">
    <xsl:text>https://defanor.uberspace.net/</xsl:text>
  </xsl:variable>

  <!-- Feed -->
  <xsl:template match="/">
    <feed>
      <title>defanor's notes</title>
      <link rel="self" href="{$baseIRI}atom.xml" />
      <link rel="alternate" href="{$baseIRI}" />
      <id>
        <xsl:value-of select="$baseIRI" />
      </id>
      <!--
          Setting <updated> statically, since it applies to some
          meaningful feed updates. Perhaps should be modified on
          metadata changes.
      -->
      <updated>2018-04-14T10:00:00Z</updated>
      <xsl:apply-templates select="/list/entry" />
    </feed>
  </xsl:template>

  <!-- Turns index entries into Atom entries -->
  <xsl:template match="entry">
    <xsl:variable name="localPath">
      <xsl:text>../</xsl:text>
      <xsl:value-of select="@name" />
    </xsl:variable>
    <xsl:variable name="doc" select="document($localPath)" />
    <entry>
      <link rel="alternate" href="{$baseIRI}{@name}" />
      <id>
        <xsl:text>https://defanor.uberspace.net/</xsl:text>
        <xsl:value-of select="@name" />
      </id>
      <!-- Setting this statically for now. -->
      <author>
        <name>defanor</name>
      </author>
      <xsl:apply-templates mode="atom-entry" select="$doc" />
    </entry>
  </xsl:template>

  <xsl:template mode="atom-entry" match="/ | xhtml:head | xhtml:html">
    <xsl:apply-templates mode="atom-entry" />
  </xsl:template>

  <!-- Title -->
  <xsl:template mode="atom-entry" match="xhtml:title">
    <title>
      <xsl:value-of select="." />
    </title>
  </xsl:template>

  <!-- Description/summary -->
  <xsl:template mode="atom-entry"
                match="xhtml:meta[@name='description' or
                       @property='dc:description schema:description']">
    <summary>
      <xsl:value-of select="@content" />
    </summary>
  </xsl:template>

  <!--
      Atom is rather strict in its date-time requriements. It's not
      always convenient or useful to be that strict in HTML metadata,
      so might be better to introduce some check and conversion.
  -->
  <!-- Publication date -->
  <xsl:template mode="atom-entry"
                match="xhtml:meta[@property='dc:issued schema:datePublished']">
    <published>
      <xsl:value-of select="@content" />
    </published>
  </xsl:template>
  
  <!-- Modification date -->
  <xsl:template mode="atom-entry"
                match="xhtml:meta[@property='dc:modified schema:dateModified']">
    <updated>
      <xsl:value-of select="@content" />
    </updated>
  </xsl:template>

  <!-- Body/content -->
  <xsl:template mode="atom-entry" match="xhtml:body">
    <content type="xhtml">
      <!--
          "the content of atom:content MUST be a single XHTML div
          element"
      -->
      <xhtml:div>
        <xsl:copy-of select="*" />
      </xhtml:div>
    </content>
  </xsl:template>

  <!-- Skip everything else -->
  <xsl:template mode="atom-entry" match="node()" priority="0" />

</xsl:stylesheet>
