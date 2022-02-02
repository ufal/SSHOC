<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:saxon="http://saxon.sf.net/"
    extension-element-prefixes="saxon">
    
<!--<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0"
    xmlns:saxon="http://saxon.sf.net/"
    extension-element-prefixes="saxon">-->

    <xsl:output
        method="text"
        encoding="UTF-8"
        indent="no" />
    
    <xsl:variable name="c" select="0" saxon:assignable="yes"/>
    
    <xsl:template match="/">
<xsl:for-each select="//head[not(preceding::head = .)]">
    <xsl:sort/><!--select="note[@type='discipline']"-->
<xsl:variable name="ref" select="@ref"/>
<saxon:assign name="c" select="$c + 1"/>
<xsl:value-of select="$c"/><xsl:text>. </xsl:text> <xsl:value-of select="."/><xsl:text>
</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>    
    <!--<xsl:template match="/">
        <xsl:for-each select="//note[@type='discipline'][not(preceding::note[@type='discipline'] = .)]">
            <xsl:sort/><!-\-select="note[@type='discipline']"-\->
            <xsl:variable name="ref" select="@ref"/>
            <saxon:assign name="c" select="$c + 1"/>
            <xsl:value-of select="$c"/><xsl:text>. </xsl:text> <xsl:value-of select="."/><xsl:text>
</xsl:text>
        </xsl:for-each>
    </xsl:template>-->
