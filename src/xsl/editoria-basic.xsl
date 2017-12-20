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
  
  <!-- By default (when not matched with a template of higher priority)
       copy any element and its attributes. -->
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- Any 'i' element becomes an 'em' element; its attributes are copied. -->
  <!-- (Unwanted attributes can be removed in a subsquent step.) -->
  <xsl:template match="i">
    <em>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  
  <!-- Any 'b' element becomes a 'strong' element; its attributes are copied. -->
  <!-- NB note that inline elements may be modified further or stripped in a subsequent 'reduce' step:
       the story is not over. -->
  <xsl:template match="b">
    <strong>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
  
  <!-- 'u' becomes 'i' for Editoria.... -->
  <xsl:template match="u">
    <i>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  
  <!-- We declare a key that enables us to match elements based on 'class' (attribute) values.
  Any element with a non-ws @class may be so matched (and retrieved). 
  Since 'class' may be overloaded this is a many-to-many match, so template
  priority will be important.
  i.e. <p class="Quote Special"> matches with both 'Quote' and 'Special' key values.
  Note the key matches elements of any type (p, h1, span etc.) so no worries about that; only
  as assigned 'class' value (delimited by whitespace) will count. -->
  <xsl:key name="elements-by-class"
    match="*[matches(@class,'\S')]" use="tokenize(@class,'\s+')"/>
  
  <!-- Calling the key() function, match any element .Quote and emit 'extract', copying attributes.
       Explicit @priority assignments prevent template collisions and let us control
       the order of preference. -->
  <xsl:template match="key('elements-by-class','Quote')" priority="100">
    <extract>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </extract>
  </xsl:template>

</xsl:stylesheet>