<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
  xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon"
  version="2.0">

<!--xmlns="http://www.w3.org/1999/xhtml"-->
  <xsl:output
    method="xml"
    encoding="UTF-8"
    indent="yes" />

  <xsl:template match="/">
    <xsl:for-each select="TEI/text/front/castList/castGroup/castItem">
<xsl:element name="castItem"><xsl:attribute name="xml:id"><xsl:value-of select="@sameAs"/></xsl:attribute>
<xsl:element name="role"><xsl:element name="name"><xsl:value-of select="role/name"/></xsl:element></xsl:element>
<xsl:element name="roleDesc"><xsl:value-of select="roleDesc"/></xsl:element></xsl:element><xsl:text>
</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

<!--
  <castGroup>
                  <castItem xml:id="Helen_AWW_gentry">
                     <role><name>Helen</name></role>
                     <roleDesc>a gentlewoman of Rossillion</roleDesc>
                  </castItem>
</castGroup>-->


<!--<xsl:for-each select="TEI/text/body/table/row/cell[@n='3']">-->












