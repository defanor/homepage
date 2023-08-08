<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="number" />

  <xsl:template match="notes">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates select="note[position()&lt;=$number]" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node()" priority="-1">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
