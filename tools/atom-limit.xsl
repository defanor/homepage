<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/2005/Atom"
                version="1.0">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="atom:feed">
    <feed>
      <xsl:apply-templates select="node()[not(self::atom:entry)]" />
      <!-- Take the top 10 entries. -->
      <xsl:apply-templates select="atom:entry[position()&lt;10]" />
    </feed>
  </xsl:template>

  <!-- Copy everything else -->
  <xsl:template match="node()" priority="0">
    <xsl:copy-of select="." />
  </xsl:template>

</xsl:stylesheet>
