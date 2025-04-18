<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8"/>

<!--Modified by A. Shinbori (2023-04-29)-->
<!--
  <xsl:template match="/|node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>
-->
 <!--
  <xsl:template match="/|node()|@*">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="0!=count(node())">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:when>
       <xsl:otherwise><xsl:comment></xsl:comment></xsl:otherwise>  
        <xsl:otherwise>N/A</xsl:otherwise>   
      </xsl:choose>
    </xsl:copy>
  </xsl:template>
-->
<!--Add a function to judge whether the contents are included in each element or not-->
<!--Remove the empty tags.-->

  <xsl:template match="@*|node()">
    <xsl:if test=".!=''">
      <xsl:copy>
	<xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/root/body/content/contributor_list/contributor/researcher_id"/>

  <xsl:template match="/root/body/content/alternate_identifier_list"/>

  <xsl:template match="/root/body/content/size_list"/>


  <xsl:template match="/root/body/content/relation_list/related_content/@title"/>
  
  <xsl:template match="/root/body/content/isas_data_list"/>

  <xsl:template match="/root/body/content/isas_metadata_date_list"/>

  <xsl:template match="/root/body/content/isas_citation"/>
  
</xsl:stylesheet>
  
