<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="sorting_countingCanon60.xsl"?>
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

    <xsl:template match="/">
        <xsl:for-each select="TEI/teiHeader/fileDesc/sourceDesc/listBibl/bibl/author">
            <xsl:if test="not(. = preceding::author)">
                <xsl:value-of select="."/>
            <xsl:text>
            </xsl:text>
            </xsl:if>
            <!--<xsl:value-of select="normalize-unicode(replace(normalize-unicode(lower-case(substring(translate(title[@type='main'], ' ', ''), 1, 6)),'NFKD'),'\p{Mn}',''),'NFKC')" />-->

        </xsl:for-each>
        
    </xsl:template>

</xsl:stylesheet>











