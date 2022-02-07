<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="numberOfCharactersPerDrama.xsl"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon"
  version="2.0">

<!-- WICHTIG:
  1. XSLT-Script muß sich im selben Ordner wie XML-Doks. befinden.
  2. Weil die Dateien der französischen Dramen von http://theatre-classique.fr/pages/programmes/PageEdition.php keine Stylesheets oder Namensraumangaben enthalten, sind diese im XSLT-Script ebenfalls ausgeklammert. 
-->    
    <xsl:output
        method="text"
        version="1.0"
        encoding="UTF-8"
        indent="yes" />
    <!--<xsl:variable name="allDocuments" select="collection('.')"/>-->
    <xsl:variable name="xmlDocs" select="collection('.?select=*.xml')"/>
    
    <!--<xsl:variable name="attendees-counter" select="0" saxon:assignable="yes"/>-->    
    
    <xsl:template match="/">
        <!--<xsl:text>Number of dramas in directory: </xsl:text><xsl:value-of select="count($xmlDocs)"/>-->
        <xsl:for-each select="$xmlDocs/TEI">
            <!--<saxon:assign name="attendees-counter" select="$attendees-counter + 1"/>
        <xsl:value-of select="$attendees-counter"/>. -->
            
            <xsl:sort case-order="upper-first" data-type="text" order="descending"></xsl:sort><xsl:value-of select="base-uri()"/><xsl:text>	</xsl:text> <!----><xsl:value-of select="count(text/front/castList/castItem)"/><xsl:text>
</xsl:text>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>




