<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="directoryEnglishDramasAuthorTitleYear.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    xmlns:saxon="http://saxon.sf.net/"
    extension-element-prefixes="saxon"
    version="2.0">
    
    <xsl:output
        method="text"
        encoding="UTF-8"
        indent="yes" />
    
    <xsl:variable name="xmlDocuments" select="collection('.?select=*.xml')"/>
    
    <xsl:template match="/">
        <xsl:text>Number of dramas in directory: </xsl:text><xsl:value-of select="count($xmlDocuments)"/>
<xsl:text>
</xsl:text>
<xsl:for-each select="$xmlDocuments/TEI/teiHeader/fileDesc/titleStmt">
<xsl:sort/>
<xsl:value-of select="author"/><xsl:text>: »</xsl:text> <xsl:value-of select="title"/><xsl:text>«</xsl:text><xsl:text>: 
Number of ‹person› in ‹listPerson›: </xsl:text><xsl:value-of select="count(../../profileDesc/particDesc/listPerson/person)"/>
<xsl:text>
</xsl:text>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>











