<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="sortBy" />

  <xsl:template match="notes">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:choose>
        <xsl:when test="$sortBy='modified'">
          <xsl:apply-templates select="note">
            <xsl:sort select="document/@modified" order="descending"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="note">
            <xsl:sort select="document/@published" order="descending"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node()" priority="-1">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
