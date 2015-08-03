<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:gss="http://www.isotc211.org/2005/gss" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs xd gss gts gml xlink gco gmd gmi gmx gsr" version="2.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Update on:</xd:b>June 18, 2015 for data.noaa.gov </xd:p>
      <xd:p><xd:b>Update on:</xd:b>Aug 1, 2013 </xd:p>
      <xd:p><xd:b>Created on:</xd:b> Jul 30, 2012</xd:p>
      <xd:p><xd:b>Author:</xd:b> amilan</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:output encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" lang="en">
      <head>
        <title>Full View of ISO 19115/19115-2 Metadata</title>
        <style type="text/css">
          a:link{
              text-decoration:none;
          }
          a:visited{
              text-decoration:none;
          }
          a:hover{
              text-decoration:underline;
          }
          a:active{
              text-decoration:underline;
          }</style>
      </head>
      <body>
        <table cellpadding="10">
          <tr>
            <td>
              <xsl:text> | </xsl:text>
              <xsl:for-each select="//element()">
                <xsl:choose>
                  <xsl:when
                    test="(local-name(.)='spatialRepresentationInfo') or (local-name(.)='referenceSystemInfo') or (local-name(.)='metadataExtensionInfo') or (local-name(.)='identificationInfo') or (local-name(.)='contentInfo') or (local-name(.)='distributionInfo') or (local-name(.)='dataQualityInfo') or (local-name(.)='portrayalCatalogueInfo') or (local-name(.)='metadataConstraints') or (local-name(.)='applicationSchemaInfo') or (local-name(.)='metadataMaintenance') or (local-name(.)='metadataMaintenanceInfo') or (local-name(.)='acquisitionInformation') or (local-name(.)='seriesMetadata')">
                    <a href="#{generate-id(.)}">
                      <xsl:value-of select="local-name(.)"/>
                    </a><xsl:text> | </xsl:text>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </td>
          </tr>
          <tr>
            <th colspan="2" align="left">
              <font size="+2">
                <xsl:for-each select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title">
                  <xsl:value-of select="normalize-space(.)"/>
                </xsl:for-each>
              </font>
            </th>
          </tr>
          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="normalize-space(/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString) and normalize-space(string(/gmi:MI_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString !=''))">
                  <xsl:choose>
                    <xsl:when test="normalize-space(//gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString) and normalize-space(string(//gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString !=''))">
                      <img alt="browse graphic" height="200px" align="left" hspace="20">
                        <xsl:attribute name="src">
                          <xsl:value-of select="//gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString"/>
                        </xsl:attribute>
                      </img>
                      <xsl:value-of select="normalize-space(//gmd:MD_DataIdentification/gmd:abstract)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(//gmd:MD_DataIdentification/gmd:abstract)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <h3>No Abstract or Image available</h3>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>

          <tr>
            <td>
              <hr/>
            </td>
          </tr>
          <tr>
            <td>
              <xsl:call-template name="content"/>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="content" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:for-each select="//element()">
      <xsl:variable name="elementName">
        <xsl:value-of select="local-name()"/>
      </xsl:variable>
      <xsl:variable name="depth">
        <xsl:value-of select="xs:integer(count(ancestor::node()))"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="($elementName='CharacterString') or ($elementName='Integer') or ($elementName='Date') or ($elementName='Boolean') or ($elementName='Decimal') or ($elementName='URL')"/>
        <xsl:when
          test="($elementName='spatialRepresentationInfo') or ($elementName='referenceSystemInfo') or ($elementName='metadataExtensionInfo') or ($elementName='identificationInfo') or ($elementName='contentInfo') or ($elementName='distributionInfo') or ($elementName='dataQualityInfo') or ($elementName='portrayalCatalogueInfo') or ($elementName='metadataConstraints') or ($elementName='applicationSchemaInfo') or ($elementName='metadataMaintenance') or ($elementName='metadataMaintenanceInfo') or ($elementName='acquisitionInformation') or ($elementName='seriesMetadata')">
          <br/>
          <a><xsl:attribute name="href" select="'#top'"/>return to top</a>
          <hr/>
          <xsl:for-each select="1 to $depth">&#160;&#160;</xsl:for-each>
          <strong>
            <a name="{generate-id(.)}">
              <xsl:value-of select="$elementName"/>
              <xsl:text>: </xsl:text>
            </a>
          </strong>
        </xsl:when>
        <xsl:when test="not(contains($elementName, '_'))">
          <br/>
          <xsl:for-each select="1 to $depth">&#160;&#160;</xsl:for-each>
          <strong>
            <xsl:value-of select="$elementName"/>
            <xsl:text>: </xsl:text>
          </strong>
        </xsl:when>
        <xsl:when test="contains($elementName, '_')"><!--
            <xsl:text>&#160;</xsl:text>
            <a class="a">
              <xsl:attribute name="href">
                <xsl:value-of select="concat('https://geo-ide.noaa.gov/wiki/index.php?title=', $elementName)"/>
              </xsl:attribute>
              <xsl:attribute name="target">_blank</xsl:attribute>
              <font color="gray">(<xsl:value-of select="$elementName"/>)</font>
            </a>
          --></xsl:when>
      </xsl:choose>
      <xsl:for-each select="./attribute::node()">
        <xsl:variable name="attributeName">
          <xsl:value-of select="local-name()"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="contains($attributeName,'code') or contains($attributeName, 'schema')"/>
          <!--<xsl:when test="($attributeName='href')">                
                <xsl:text>&#160;</xsl:text><i><font color="gray"><xsl:value-of select="'xlink'"/><xsl:text>: </xsl:text><xsl:value-of select="normalize-space(.)"/></font></i>
              </xsl:when>-->
          <xsl:when test="($attributeName='href')">
            <xsl:text>&#160;</xsl:text>
            <!--<i>
                <font color="gray">
                  <xsl:value-of select="'xlink'"/>
                  <xsl:text>: </xsl:text>
                  <a class="a">
                    <xsl:attribute name="href">
                      <xsl:value-of select="normalize-space(.)"/>
                    </xsl:attribute>
                    <xsl:attribute name="target">blank</xsl:attribute>
                    <xsl:value-of select="normalize-space(.)"/>
                  </a>
                </font>              
              </i>-->
            <a class="a">
              <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="contains(../@xlink:href, 'docucomp')">
                    <xsl:value-of select="concat(normalize-space(../@xlink:href), '.guide')"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(../@xlink:href)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="target">blank</xsl:attribute>
              <xsl:attribute name="title" select="../@xlink:href"/>
              <xsl:choose>
                <xsl:when test="normalize-space(../@xlink:title)">
                  <xsl:value-of select="normalize-space(../@xlink:title)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="normalize-space(../@xlink:href)"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </xsl:when>

          <!--<xsl:when test="($attributeName='title') or ($attributeName='uuid')">
              <xsl:text>&#160;</xsl:text>
              <i>
                <font color="gray">
                  <xsl:value-of select="$attributeName"/>
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="normalize-space(.)"/>
                </font>
              </i>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&#160;</xsl:text>
              <i>
                <font color="gray">
                  <xsl:value-of select="normalize-space(.)"/>
                </font>
              </i>
            </xsl:otherwise>-->
        </xsl:choose>
      </xsl:for-each>
      <xsl:choose>
        <xsl:when test="count(child::text())=1">
          <xsl:variable name="content">
            <xsl:value-of select="child::text()"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="starts-with($content, 'http://')">
              <a class="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="$content"/>
                </xsl:attribute>
                <font color="SlateBlue">
                  <xsl:value-of select="$content"/>
                </font>
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&#160;</xsl:text>
              <xsl:value-of select="$content"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="@gco:nilReason">
            <i> (<xsl:value-of select="@gco:nilReason"/>) </i>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
