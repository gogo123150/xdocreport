<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2011 Angelo Zerr <angelo.zerr@gmail.com>, Pascal Leclercq <pascal.leclercq@gmail.com>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
	xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
	xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
	xmlns:fop="http://www.w3.org/1999/XSL/Format" exclude-result-prefixes="office style fo"
	version="2.0">

	<!-- ==================================== -->
	<!-- Generate FO layout-master-set -->
	<!-- ==================================== -->
	<xsl:template name="GenerateFOLayoutMasterSet">
		<fop:layout-master-set>
			<!-- Generate fop:simple-page-master for each style:master-page declared 
				in the styles.xml -->
			<xsl:apply-templates
				select="$styles-xml-doc//office:master-styles/style:master-page"
				mode="simple-page-master" />
		</fop:layout-master-set>
	</xsl:template>

	<!-- ====================================================================== -->
	<!-- Transform style:master-page (from styles.xml) 2 fop:simple-page-master -->
	<!-- ====================================================================== -->
	<xsl:template match="style:master-page" mode="simple-page-master">
		<xsl:variable name="master-name" select="@style:name" />
		<xsl:variable name="page-layout-name" select="@style:page-layout-name" />
		<fop:simple-page-master master-name="{$master-name}">
			<xsl:variable name="page-layout"
				select="//office:automatic-styles/style:page-layout[@style:name=$page-layout-name]" />
			<xsl:apply-templates select="$page-layout/style:page-layout-properties" mode="FO-attr" />
			<fop:region-body>
				<xsl:if test="$page-layout/style:header-style/child::*">
					<xsl:attribute name="margin-top">
							<xsl:value-of
						select="$page-layout/style:header-style/style:header-footer-properties/@fo:margin-bottom" />
							<xsl:if
						test="$page-layout/style:header-style/style:header-footer-properties/@style:dynamic-spacing='false'">*2</xsl:if>
						</xsl:attribute>
				</xsl:if>
				<xsl:if test="$page-layout/style:footer-style/child::*">
					<xsl:attribute name="margin-bottom">
							<xsl:value-of
						select="$page-layout/style:footer-style/style:header-footer-properties/@fo:margin-top" />
							<xsl:if
						test="$page-layout/style:footer-style/style:header-footer-properties/@style:dynamic-spacing='false'">*2</xsl:if>
						</xsl:attribute>
				</xsl:if>
			</fop:region-body>
			<fop:region-before 
				display-align="before">
				<xsl:if test="$page-layout/style:header-style/child::*">
					<xsl:call-template name="ApplyStyle">
						<xsl:with-param name="style-node"
							select="$page-layout/style:header-style" />
						<xsl:with-param name="style-type" select="'header:footer'" />
					</xsl:call-template>
				</xsl:if>
			</fop:region-before>
			<fop:region-after 
				display-align="after">
				<xsl:if test="$page-layout/style:footer-style/child::*">
					<xsl:call-template name="ApplyStyle">
						<xsl:with-param name="style-node"
							select="$page-layout/style:footer-style" />
						<xsl:with-param name="style-type" select="'header:footer'" />
					</xsl:call-template>
				</xsl:if>
			</fop:region-after>
		</fop:simple-page-master>
	</xsl:template>

	<xsl:template match="style:page-layout-properties" mode="FO-attr">
		<xsl:apply-templates select="@*" mode="FO-attr" />		
	</xsl:template>


	<xsl:template match="@fo:*" mode="FO-attr">
		<xsl:attribute name="{local-name(.)}"><xsl:value-of select="." /></xsl:attribute>
	</xsl:template>

	<xsl:template match="@*" mode="FO-attr">
		<!-- Unknown attributes, do nothing -->
	</xsl:template>


</xsl:stylesheet>