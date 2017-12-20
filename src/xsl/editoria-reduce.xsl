<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsw="http://coko.foundation/xsweet"
  xpath-default-namespace="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="#all">
  
  <!-- Note the default namespace for matching (given above) is
     "http://www.w3.org/1999/xhtml" -->
  
<!-- The results will have XML syntax but no XML declaration or DOCTYPE declaration
     (as permitted by HTML5). -->

  <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>

<!-- Just in case:
     <xsl:key name="elements-by-class" match="*[matches(@class,'\S')]"
     use="tokenize(@class,'\s+')"/>
-->  
  

  <!-- By default we *drop* elements.
       Better templates will copy the ones we want. -->
  
  <xsl:template match="*">
     <xsl:apply-templates/>
  </xsl:template>

  <!-- But we keep attributes -->
  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <!-- Sorry guys, until further notice Editoria doesn't know what to do with you. -->
  <xsl:template match="comment() | processing-instruction()"/>
  
  <!-- Drop head/style -->
  <xsl:template priority="5" match="head/style"/>
  
  <xsl:template match="html | head | head//* | body">
    <xsl:apply-templates select="." mode="copy-after-all"/>
  </xsl:template>
  
  <!-- We only permit a header to be propagated if it has (non-ws) contents. -->
  <xsl:template match="h1| h2 | h3 | h4 | h5 | h6">
    <xsl:if test="matches(.,'\S')">
      <xsl:apply-templates select="." mode="copy-after-all"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="p | extract | blockquote | pre">
    <xsl:apply-templates select="." mode="copy-after-all"/>
  </xsl:template>
  
  <!-- Empty line feeds may be left especially after paragraph splitting in an earlier step. -->
  <xsl:template match="p[not(matches(.,'\S'))]"/>
  
  <!-- NB stripping b and strong for now. -->
  <xsl:template match="I | sup | sub | a | code | em">
    <xsl:apply-templates select="." mode="copy-after-all"/>
  </xsl:template>
  
  <xsl:template match="note | note/@*">
    <xsl:apply-templates select="." mode="copy-after-all"/>
  </xsl:template>
  
  <xsl:template match="node()" mode="comment-in"/>
  
  <xsl:template match="p//* | td//*" mode="comment-in">
    <xsl:if test="not(matches(string(.),'\S'))">
      <xsl:comment> open/close </xsl:comment>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="node() | @*" mode="copy-after-all">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="." mode="comment-in"/>
      <!-- switching back out of mode -->
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Bye-bye @class, bye-bye @style! -->
  <xsl:template match="@class | @style" priority="2"/>
  
  
</xsl:stylesheet>