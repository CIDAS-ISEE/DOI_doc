<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times"
    xmlns="http://www.w3.org/1999/xhtml"
    extension-element-prefixes="date"
    exclude-result-prefixes="date">

  <xsl:output method="text"/>
  <xsl:output method="html" indent="yes" encoding="UTF-8" name="html"/>
  
  <xsl:template match="text()" />

  <xsl:template match="/root">
    <xsl:apply-templates select="body"/>
  </xsl:template>
  
  <xsl:template match="/root/head"></xsl:template>
  
  <xsl:template match="/root/body">
    <xsl:for-each select="content">
      <xsl:apply-templates select="generate_citation"/>
      <xsl:variable name="doi" select="doi"/>
      <xsl:variable name="doi-suffix" select="substring-after($doi, '10.34515/')"/>
      <xsl:variable name="fnameroot" select="replace($doi-suffix,'DATA.','DATA_')"/>
      <xsl:variable name="filename" select="concat('output/html/', $fnameroot, '.html')"/>
      <xsl:result-document href="{$filename}" format="html">
        <html>
          <head>
            <title>
              <xsl:value-of select="title_list/titles[@lang='en']/title"/><xsl:text>, DOI: </xsl:text><xsl:value-of select="doi"/>
            </title>
            <style type="text/css">
              <xsl:text disable-output-escaping="yes">
                a.data_download { text-decoration: none; }
                ul.subject <![CDATA[>]]> li:not(:last-child)::after { content: ","; }
                ul.subject li { display: inline; }
                h2 { margin-left: 2ex; margin-top: 1em; }
                h3 { margin-left: 4ex; }
                h4 { margin-left: 7ex; }
                h2 + ul { margin-left: 4ex; }
                h3 + ul { margin-left: 6ex; }
                h3 + ul { margin-left: 6ex; }
                h4 + ul { margin-left: 7ex; }
                h2 + p  { margin-left: 2ex; padding-left: 4ex; }
                h3 + p  { margin-left: 4ex; padding-left: 4ex; }
                h4 + p  { margin-left: 5ex; padding-left: 5ex; }
                h1,h2 { border-bottom: 0.1em solid rgba(33,29,82,0.96); }
                h3 { padding-left: 0.5em; border-left: 0.5ex solid rgba(33,29,82,0.5); }
                h4 { padding-left: 0.5em; border-left: 0.5ex solid rgba(33,29,82,0.3); }
                ul.data > li { display: inline; }
                ul.data > li > a { display: inline-block; margin: 0.5em; padding: 0.5em; background-color: #f0f8ff; border: 1px solid gray; border-radius: 0.6em; }
                ul.geolocation { list-style-type: none; }
              </xsl:text>
            </style>
          </head>
          <body>
            <h1><xsl:value-of select="title_list/titles[@lang='en']/title"/></h1>

            <xsl:apply-templates select="isas_data_list"/>
            
            <h2><xsl:text>DATA CITATION</xsl:text></h2>
            <p><xsl:value-of select="isas_citation"/></p>

            <h2>IDENTIFICATION INFORMATION</h2>
            <ul>
              <xsl:apply-templates select="title_list"/>
              <li><xsl:text>DOI: </xsl:text><xsl:value-of select="doi"/></li>

<!--Modified by A. Shinbori (2023-04-29)-->
<!--Add a function to judge whether the contents (alternate_identifier_list/alternate_identifier) are included in each element or not-->
<!--If they are null, the description is represented as "None.".-->
              <li><xsl:text>Alternate identifier(s): </xsl:text>
              <xsl:choose>
                <xsl:when test="alternate_identifier_list/alternate_identifier">
                  <xsl:if test="alternate_identifier_list/alternate_identifier=''">
                    <xsl:text>None.</xsl:text>
                  </xsl:if>
                  <xsl:if test="alternate_identifier_list/alternate_identifier[*|text()]">
                    <ul>
                      <xsl:apply-templates select="alternate_identifier_list/alternate_identifier"/>
                    </ul>
                  </xsl:if>
                </xsl:when>
<!--Modified by A. Shinbori (2023-04-29)-->

                <xsl:otherwise>
                  <xsl:text>None.</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
              </li>
            </ul>

            <h2>DATASET CREATOR</h2>
            <ul>
              <xsl:apply-templates select="creator_list/creator"/>
            </ul>
            
            <h2>DATASET OVERVIEW</h2>
            <xsl:apply-templates select="description_list"/>
            <xsl:apply-templates select="resource_type"/>
            <xsl:apply-templates select="subject_list"/>
            <xsl:apply-templates select="edition"/>
            <xsl:apply-templates select="publication_date"/>
            <xsl:apply-templates select="publisher"/>        
            <xsl:apply-templates select="relation_list"/>
            <xsl:apply-templates select="contributor_list"/>
            <xsl:apply-templates select="content_language"/>
            <xsl:apply-templates select="geolocation_list"/>
            <xsl:apply-templates select="access_rights"/>
            <xsl:apply-templates select="repository"/>
            
            <h2>DATES OF DATASET</h2>
            <xsl:apply-templates select="date_list"/>

            <h2>RIGHTS, CREDITS, LICENSES</h2>
            <xsl:apply-templates select="rights_list"/>

            <h2>DATES OF THIS METADATA</h2>
            <xsl:apply-templates select="isas_metadata_date_list"/>
            
            <xsl:text disable-output-escaping="yes"><![CDATA[<hr>]]></xsl:text>
            <footer>
              <address style="display: inline;">[contact: ergsc-help _AT_ isee.nagoya-u.ac.jp]</address>
              <xsl:text> </xsl:text>
              <a href="https://ergsc.isee.nagoya-u.ac.jp/index.shtml.en">ERG-SC</a> / 
              <a href="https://www.isee.nagoya-u.ac.jp/en/index.html">ISEE</a> / 
              <a href="http://en.nagoya-u.ac.jp/index.html">Nagoya University</a>
            </footer>
          </body>
        </html>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="isas_data_list">
    <!-- If not empty -->
    <h2><xsl:text>DATA FILE DOWNLOAD</xsl:text></h2>
    <ul class="data">
      <xsl:for-each select="isas_data">
        <xsl:variable name="data_url" select="@url"/>
        <li><a class="data_download" href="{$data_url}"><xsl:value-of select="."/></a></li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="title_list">
    <!-- If not empty -->
    <li>
      <xsl:text>Title: </xsl:text>
      <xsl:apply-templates select="titles[@lang='en']"/>
    </li>
  </xsl:template>

  <xsl:template match="titles[@lang='en']">
    <xsl:value-of select="title"/>
  </xsl:template>
  
  <xsl:template match="subject_list">
    <!-- If not empty -->
    <h3><xsl:text>Keywords</xsl:text></h3>
    <ul class="subject">
      <xsl:for-each select="subject">
        <li><xsl:value-of select="."/></li>
      </xsl:for-each>
    </ul>
  </xsl:template>
  
  <xsl:template match="creator_list">
    <!-- If not empty -->
    <h3><xsl:text>Creator</xsl:text></h3>
    <ul>
      <xsl:apply-templates select="creator"/>
    </ul>
  </xsl:template>

  <xsl:template match="creator">
    <li>
      <xsl:value-of select="names[@lang='en']/first_name"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="names[@lang='en']/last_name"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="affiliation/affiliation_name[@lang='en']"/>
      <!-- If not empty -->
      <xsl:if test="researcher_id/id_code/@type='ORCID'">
        <xsl:variable name="url" select="researcher_id/id_code[@type='ORCID']"/>
        <xsl:text>, </xsl:text>
        <a href="{$url}"><xsl:value-of select="$url"/></a>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match="publication_date">
    <!-- If not empty -->
    <h3><xsl:text>Publication Year</xsl:text></h3>
    <p><xsl:value-of select="year"/></p>
  </xsl:template>

  <xsl:template match="publisher">
    <!-- If not empty -->
    <h3><xsl:text>Publisher</xsl:text></h3>
    <p><xsl:value-of select="publisher_name[@lang='en']"/></p>
  </xsl:template>

  <xsl:template match="contributor_list">
    <!-- If not empty -->
    <h3><xsl:text>Contributors</xsl:text></h3>
    <ul>
      <xsl:apply-templates select="contributor"/>
    </ul>
  </xsl:template>

  <xsl:template match="contributor">
    <xsl:if test="@contributor_type='RightsHolder'">
      <li><xsl:text>Rights Holder: </xsl:text><xsl:value-of select="names/first_name"/></li>
    </xsl:if>
    <xsl:if test="@contributor_type='Distributor'">
      <li><xsl:text>Distributor: </xsl:text><xsl:value-of select="names/first_name"/></li>
    </xsl:if>
    
  </xsl:template>

  <xsl:template match="relation_list">
    <!-- If not empty -->
    <h3><xsl:text>Related contents</xsl:text></h3>
    <ul>
      <xsl:apply-templates select="related_content"/>
    </ul>
  </xsl:template>

  <xsl:template match="related_content">
    <xsl:variable name="relationDesc">
      <xsl:choose>
        <xsl:when test="@relation='References'">Reference of dataset</xsl:when>
        <xsl:when test="@relation='IsDescribedBy'">Dataset is described by</xsl:when>
        <xsl:when test="@relation='IsDerivedFrom'">Dataset is derived from</xsl:when>
        <xsl:when test="@relation='IsSourceOf'">Dataset is source of</xsl:when>
        <xsl:when test="@relation='IsMetadataFor'">Dataset is metadata for</xsl:when>
        <xsl:when test="@relation='HasMetadata'">Metadata of dataset is in</xsl:when>
        <xsl:when test="@relation='HasInfo'">Additional info</xsl:when>
        <xsl:otherwise>(Undefined type of relation)</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li><xsl:value-of select="$relationDesc"/><xsl:text>: </xsl:text>
    <xsl:choose>
      <xsl:when test="@type='DOI'">
        <xsl:variable name="doi" select="."/>
        <xsl:variable name="url" select="concat('https://doi.org/', $doi)"/>
        <a href="{$url}"><xsl:value-of select="@title"/><xsl:text>, doi:</xsl:text><xsl:value-of select="$doi"/></a>
      </xsl:when>
      <xsl:when test="@type='URL'">
        <xsl:variable name="url" select="."/>
        <a href="{$url}"><xsl:value-of select="@title"/></a>
      </xsl:when>
      <xsl:when test="@type='WEB'">
        <xsl:variable name="url" select="."/>
        <a href="{$url}"><xsl:value-of select="@title"/></a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/><xsl:text> (</xsl:text><xsl:value-of select="@type"/><xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    </li>
  </xsl:template>
  
  <xsl:template match="content_language">
    <!-- If not empty -->
    <h3><xsl:text>Language used in dataset</xsl:text></h3>
    <p><xsl:value-of select="."/><xsl:text></xsl:text></p>
  </xsl:template>

  <xsl:template match="geolocation_list">
    <!-- If not empty -->
    <h3><xsl:text>Geolocation(s)</xsl:text></h3>
     <ul>
      <xsl:for-each select="geolocation">
      	<xsl:choose>
           <xsl:when test="geolocation_point">
            <li><xsl:text>Point in Latitude and Latitude: </xsl:text><xsl:value-of select="geolocation_point"/></li>
         </xsl:when>
         <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
              <xsl:when test="geolocation_box">
                <li><xsl:text>Rectangular region of South-West corner and North-East corner in Latitude and Longitude: </xsl:text><xsl:value-of select="geolocation_box"/></li>
              </xsl:when>
              <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="geolocation_place">
                <li><xsl:text>Description of geographic location: </xsl:text><xsl:value-of select="geolocation_place"/></li>
              </xsl:when>
            <xsl:otherwise></xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="repository">
    <!-- If not empty -->
    <h3><xsl:text>Repository</xsl:text></h3>
     <ul>
      <xsl:for-each select="repository_name_list">
      	<xsl:choose>
           <xsl:when test="repository_name">
            <xsl:apply-templates select="repository_name"/>
         </xsl:when>
         <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </ul>
  </xsl:template>
  
  <xsl:template match="edition">
    <!-- If not empty -->
    <h3><xsl:text>Version of dataset</xsl:text></h3>
    <ul>
      <li><xsl:value-of select="variation"/></li>
      <p><xsl:value-of select="version"/></p>
    </ul>
  </xsl:template>
  
  <xsl:template match="date_list">
    <!-- If not empty -->
    <ul>
      <xsl:apply-templates select="date"/>
    </ul>
  </xsl:template>

  <xsl:template match="date">
    <xsl:variable name="dateDesc">
      <xsl:choose>
        <xsl:when test="@type='Issued'">Issued</xsl:when>
        <xsl:when test="@type='Updated'">Updated</xsl:when>
        <xsl:otherwise>(Undefined type of date)</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li><xsl:value-of select="$dateDesc"/><xsl:text>: </xsl:text><xsl:value-of select="."/></li>
  </xsl:template>
  
  <xsl:template match="resource_type">
    <!-- If not empty -->
    <h3><xsl:text>Resource Type</xsl:text></h3>
    <p><xsl:value-of select="@type"/><xsl:text>, </xsl:text><xsl:value-of select="."/></p>
  </xsl:template>

  <xsl:template match="alternate_identifier_list/alternate_identifier">
    <!-- If not empty -->
    <li><xsl:value-of select="@type"/><xsl:text>: </xsl:text><xsl:value-of select="."/></li>
  </xsl:template>
  
  <xsl:template match="rights_list">
    <!-- If not empty -->
    <ul>
      <xsl:apply-templates select="rights"/>
    </ul>
  </xsl:template>

  <xsl:template match="rights">
    <!-- If not empty -->
    <xsl:variable name="uritext" select="@uri"/>
    <li><a href="{$uritext}"><xsl:value-of select="."/></a></li>
  </xsl:template>

  <xsl:template match="access_rights">
    <!-- If not empty -->
    <h3><xsl:text>Access rights</xsl:text></h3>
     <ul>
           <xsl:variable name="access_rights" select="@date"/>
        <li><xsl:value-of select="."/><xsl:text> (</xsl:text><xsl:value-of select="@date"/><xsl:text>)</xsl:text></li>
     </ul>
  </xsl:template>

<!--
  <xsl:template match="repository_name">
    <xsl:variable name="uritext" select="@uri"/>
    <li><a href="{$uritext}"><xsl:value-of select="."/></a></li>
  </xsl:template>
-->

  <xsl:template match="repository_name">
    <xsl:if test="@lang='en'">
        <li><xsl:value-of select="."/></li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="description_list">
    <!-- If not empty -->
    <h3><xsl:text>Description(s)</xsl:text></h3>
    <xsl:apply-templates select="description"/>
  </xsl:template>

  <xsl:template match="description">
    <xsl:if test="@type='Abstract'">
      <xsl:if test="@lang='en'">
        <h4><xsl:text>Abstract</xsl:text></h4>
        <p><xsl:value-of select="."/></p>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="isas_metadata_date_list">
    <!-- If not empty -->
    <ul>
      <xsl:apply-templates select="isas_metadata_date"/>
    </ul>
  </xsl:template>

  <xsl:template match="isas_metadata_date">
    <li><xsl:value-of select="."/><xsl:text>: </xsl:text><xsl:value-of select="@type"/></li>
  </xsl:template>

  
</xsl:stylesheet>
  
