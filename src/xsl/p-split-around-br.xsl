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
  
<!-- Splitting paragraphs around br elements, including all descendants.
  
  Note: no special provision is made for 'hands off' elements inside paragraphs, i.e.
  wrappers within which the splitting is non-operative (such as embedded footnotes or other)
  i.e. this is safe to run *only* on files that are known to be flat, as it will split
  around br elements with impunity, wherever they are, within the scope of any element
  (in this case p) considered to be subject or liable to the treatment. -->
 
  <xsl:template match="node() | @*">
   <xsl:copy>
     <xsl:apply-templates select="node() | @*"/>
   </xsl:copy>
 </xsl:template>
  
  <xsl:template match="p[exists(.//br)]">
    <div>
      <xsl:copy-of select="@id"/>
      
      <xsl:apply-templates select="." mode="p-break"/>
    </div>
  </xsl:template>

  <xsl:key name="element-by-generated-id" match="*" use="generate-id()"/>
  
  <xsl:template mode="p-break" match="node()">
    <xsl:variable name="here" select="."/>
      <!-- grouping all the leaf nodes into sets representing groups around breaks -->
      <xsl:for-each-group select="descendant::node()[empty(node())]"
      group-starting-with="br">
      <p>
        <xsl:copy-of select="$here/@* except $here/@id"/>
        <xsl:call-template name="build">
          <xsl:with-param name="from" select="$here" tunnel="yes"/>
        </xsl:call-template>
      </p>
    </xsl:for-each-group>
  </xsl:template>
  
  <xsl:template name="build">
    <xsl:param name="to-copy" select="current-group()"/>
    <xsl:param name="level" select="1" as="xs:integer"/>
    <xsl:param name="from" select="." tunnel="yes"/>
    <xsl:for-each-group select="current-group()"
      group-adjacent="generate-id((ancestor::* except $from/ancestor-or-self::*)[$level])">
      <xsl:variable name="copying" select="key('element-by-generated-id',current-grouping-key())"/>
      <xsl:sequence select="current-group()[empty($copying)][not(self::br)]"/>
      <xsl:for-each select="$copying">
        <xsl:copy>
          <xsl:copy-of select="@* except @id"/>
          <xsl:call-template name="build">
            <xsl:with-param name="level" select="$level + 1"/>
          </xsl:call-template>
        </xsl:copy>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:template>
  
</xsl:stylesheet>