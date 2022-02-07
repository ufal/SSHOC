<?xml version="1.0" encoding="UTF-8"?>
<!--<?xml-stylesheet type="text/xsl" href="CalDracorTOCAchtungFunztNurInIdentischemVerzeichnis.xsl"?>-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon"
  version="2.0">
  
<!--  <xsl:output
    method="xml"
    version="1.0"
    encoding="UTF-8"
    indent="yes" />-->

  <xsl:output
    method="text"
    encoding="UTF-8"
    indent="yes" />
  
  <!--<xsl:variable name="attendees-counter" select="0" saxon:assignable="yes"/>    
  
  <xsl:variable name="allDocuments" select="collection('.')"/> 
    <xsl:variable name="xmlDocs" select="collection('.?select=*.xml')"/>-->

<!--TEI/text/front/castList/castGroup/castGroup/head/castItem/-->    
  <xsl:template match="/">
    <xsl:for-each select="TEI/teiHeader/profileDesc/particDesc/listPerson/person">
      <xsl:value-of select="."/><xsl:text>
</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
