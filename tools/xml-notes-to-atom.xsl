<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/2005/Atom"
                version="1.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:variable name="baseIRI">
    <xsl:text>https://thunix.net/~defanor/</xsl:text>
  </xsl:variable>

  <xsl:template match="notes">
    <feed>
      <title>defanor's notes</title>
      <link rel="self" href="{$baseIRI}notes/atom.xml" />
      <link rel="alternate" href="{$baseIRI}notes/" />
      <id><xsl:value-of select="$baseIRI" />notes/</id>
      <!--
          Setting <updated> statically, since it applies to some
          meaningful feed updates. Perhaps should be modified on
          metadata changes.
      -->
      <updated>2018-05-01T01:00:00Z</updated>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates  />
    </feed>
  </xsl:template>

  <xsl:template match="note">
    <entry>
      <link rel="alternate" href="{$baseIRI}{@src}" />
      <id>
        <xsl:text>https://thunix.net/~defanor/</xsl:text>
        <xsl:value-of select="@src" />
      </id>
      <author>
        <name>defanor</name>
      </author>
      <title>
        <xsl:value-of select="document/@title" />
      </title>
      <summary>
        <xsl:value-of select="document/@description" />
      </summary>
      <published>
        <xsl:value-of select="document/@published" />
      </published>
      <updated>
        <xsl:value-of select="document/@modified" />
      </updated>
      <content type="xhtml">
        <!--
            "the content of atom:content MUST be a single XHTML div
            element"
        -->
        <xhtml:div xmlns="http://www.w3.org/1999/xhtml">
          <xsl:copy-of select="document/xhtml:body/*" />
        </xhtml:div>
      </content>
    </entry>
  </xsl:template>

  <xsl:template match="node()" priority="-1">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
