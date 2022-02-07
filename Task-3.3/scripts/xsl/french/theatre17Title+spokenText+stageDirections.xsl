<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:saxon="http://saxon.sf.net/"
    extension-element-prefixes="saxon"
    version="2.0">
    <xsl:strip-space elements="head stage l"/>
    <xsl:output
        method="text"
        encoding="UTF-8"
        indent="no" />
    <xsl:template match="/">
        <xsl:for-each select="TEI/teiHeader/fileDesc/titleStmt">
            <xsl:value-of select="author"/><xsl:text>: »</xsl:text>
            <xsl:value-of select="title"/><xsl:text>«</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="TEI/text/body/div">
            <xsl:value-of select="head"/>
            <xsl:for-each select="div">
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
 </xsl:stylesheet>

<!--<xsl:value-of select="stage"/><xsl:text>
    </xsl:text>
    <xsl:value-of select="./sp"/><xsl:text>
    </xsl:text>-->
<!--IN ALLEN DREI KORPORA
    
    <title type="main">A Dios por razón de estado</title>
    <author key="pnd:118518399">Calderón de la Barca, Pedro</author>
    
    – Sprechernamen (wer sagt was?)
    – Regieanweisungen-->