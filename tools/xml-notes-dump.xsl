<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="note">
    <xsl:variable name="docPath">
      <xsl:text>../src/</xsl:text>
      <xsl:value-of select="@src" />
    </xsl:variable>
    <xsl:variable name="doc" select="document($docPath)" />
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:copy-of select="$doc" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node()" priority="0">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
