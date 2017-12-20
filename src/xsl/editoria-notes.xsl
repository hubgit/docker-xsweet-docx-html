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
  
  <xsl:key name="elements-by-class"
    match="*[matches(@class,'\S')]" use="tokenize(@class,'\s+')"/>
  
  <xsl:key name="internal-links" match="*[@id]" use="concat('#',@id)"/>
  
  <!-- By default (when not matched with a template of higher priority)
       copy any element and its attributes. -->
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template priority="10" match="div[@id='docx-body'] | key('elements-by-class','docx-body')">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="body/div"/>

  <xsl:template match="key('elements-by-class','endnoteReference') | key('elements-by-class','footnoteReference')">
    <xsl:variable name="contents">
      <xsl:apply-templates select="key('internal-links',@href)" mode="plaintext"/>
    </xsl:variable>
    <!-- note comes out empty since we don't actually want the referencing string (number). -->
    <note note-content="{$contents}"/>
  </xsl:template>
  
  <xsl:template match="*" mode="plaintext">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <xsl:template match="p" mode="plaintext">
    <xsl:for-each select="preceding-sibling::*[1]">
      <xsl:text>&#xA;&#xA;</xsl:text>
    </xsl:for-each>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>

  <!-- Note references suppressed inside notes. -->
  <xsl:template match="key('elements-by-class','endnoteRef')"  mode="plaintext"/>
  <xsl:template match="key('elements-by-class','footnoteRef')" mode="plaintext"/>
  
  <xsl:template match="text()" mode="plaintext">
    <xsl:value-of select="replace(.,'\s+',' ')"/>
  </xsl:template>
  
</xsl:stylesheet>