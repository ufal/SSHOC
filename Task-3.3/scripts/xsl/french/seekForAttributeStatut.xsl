<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="theatre-classique-Auswahl.xsl"?>

<!--<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon"
  version="2.0">-->

<!-- WICHTIG:
  1. XSLT-Script muß sich im selben Ordner wie XML-Doks. befinden.
  2. Weil die Dateien der französischen Dramen von http://theatre-classique.fr/pages/programmes/PageEdition.php keine Stylesheets oder Namensraumangaben enthalten, sind diese im XSLT-Script ebenfalls ausgeklammert. 
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon"
  version="2.0">
  
  <xsl:output
    method="text"
    version="1.0"
    encoding="UTF-8"
    indent="yes" />
  <!--<xsl:variable name="allDocuments" select="collection('.')"/>-->
  <xsl:variable name="xmlDocs" select="collection('.?select=*.xml')"/>
  
  <xsl:variable name="attendees-counter" select="0" saxon:assignable="yes"/>    
  
  <xsl:template match="/">
    
    <xsl:for-each select="$xmlDocs">
      <!--<xsl:sort/>-->
      <xsl:value-of select="substring(document-uri(/),75)"/><xsl:text>
</xsl:text>
      <!--<saxon:assign name="attendees-counter" select="$attendees-counter + 1"/>
        <xsl:value-of select="$attendees-counter"/>. -->
      <xsl:for-each select="TEI/text/front/castList/castItem/role">
        <xsl:if test=".[@statut]">
          <xsl:text>@statut vorhanden.</xsl:text>  
        </xsl:if>  
      </xsl:for-each>
<xsl:text>
</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>














