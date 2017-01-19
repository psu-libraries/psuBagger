<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3">
   <xsl:output method="text" omit-xml-declaration="yes"/>        
    <xsl:template match="/">
        <xsl:text>Title: </xsl:text> <xsl:value-of select="//mods:title" />
        <xsl:text>&#10;Access: Institution</xsl:text>
    </xsl:template>
</xsl:stylesheet>
