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

<xsl:stylesheet xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
	xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
	xmlns:config="urn:oasis:names:tc:opendocument:xmlns:config:1.0"
	xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
	xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
	xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
	xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
	xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
	xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
	xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
	xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
	xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
	xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
	xmlns:anim="urn:oasis:names:tc:opendocument:xmlns:animation:1.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:xforms="http://www.w3.org/2002/xforms"
	xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
	xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
	xmlns:smil="urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">

	<xsl:template match="@*" mode="CSS-attr" />

	<!-- FONT -->
	<xsl:template
		match="
			@fo:font-name|
			@fo:font-family|
			@svg:font-family"
		mode="CSS-attr">
		<xsl:text>font-family: </xsl:text>
		<xsl:value-of select="." />
		<xsl:text>; </xsl:text>
	</xsl:template>


	<xsl:template match="@style:font-name" mode="CSS-attr">
		<xsl:variable name="style_name" select="." />
		<xsl:text>font-family: </xsl:text>
		<xsl:value-of
			select="//style:font-face[@style:name=$style_name]/@svg:font-family" />
		<xsl:text>; </xsl:text>
	</xsl:template>

	<xsl:template
		match="
			@fo:font-variant|
			@fo:font-style|
			@fo:font-weight"
		mode="CSS-attr">
		<xsl:call-template name="copy-attr" />
	</xsl:template>


	<xsl:template match="
			@fo:color|
			@fo:background-color"
		mode="CSS-attr">
		<xsl:call-template name="copy-attr" />
	</xsl:template>


	<xsl:template
		match="
			@fo:text-indent|
			@fo:font-size|
			@fo:line-height"
		mode="CSS-attr">
		<xsl:call-template name="copy-attr-normalized" />
	</xsl:template>


	<xsl:template match="@fo:text-align" mode="CSS-attr">
		<xsl:value-of select="local-name()" />
		<xsl:text>: </xsl:text>
		<xsl:choose>
			<xsl:when test=".='start'">
				<xsl:text>left</xsl:text>
			</xsl:when>
			<xsl:when test=".='end'">
				<xsl:text>right</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="." />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>; </xsl:text>
	</xsl:template>


	<!-- CSS2 only has one type of underline. We can improve this when CSS3 
		is better supported. -->
	<xsl:template
		match="
			@style:text-underline-style|
			@style:text-underline-type"
		mode="CSS-attr">
		<xsl:if test="not(.='none')">
			<xsl:text>text-decoration: underline;</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- WIDTH/HEIGHT -->

	<xsl:template match="@style:width|@style:height|@fo:width|@fo:height"
		mode="CSS-attr">
		<xsl:call-template name="copy-attr-normalized" />
	</xsl:template>

	<!-- MARGIN -->

	<xsl:template match="@fo:margin-top" mode="CSS-attr">
		<xsl:text>margin-top:</xsl:text>
		<xsl:call-template name="normalized-value" />
	</xsl:template>

	<xsl:template match="@fo:margin-bottom" mode="CSS-attr">
		<xsl:text>margin-bottom:</xsl:text>
		<xsl:call-template name="normalized-value" />
	</xsl:template>

	<xsl:template match="@fo:margin-left" mode="CSS-attr">
		<xsl:text>margin-left:</xsl:text>
		<xsl:call-template name="normalized-value" />
	</xsl:template>

	<xsl:template match="@fo:margin-right" mode="CSS-attr">
		<xsl:text>margin-right:</xsl:text>
		<xsl:call-template name="normalized-value" />
	</xsl:template>

	<!-- Utility functions -->
	<xsl:template name="copy-attr-normalized" mode="CSS-attr">
		<xsl:value-of select="local-name()" />
		<xsl:text>:</xsl:text>
		<xsl:call-template name="normalized-value" />
	</xsl:template>

	<xsl:template name="normalized-value" mode="CSS-attr">
		<xsl:call-template name="length-normalize">
			<xsl:with-param name="length" select="." />
		</xsl:call-template>
		<xsl:text>; </xsl:text>
	</xsl:template>

	<xsl:template name="normalized-just-value" mode="CSS-attr">
		<xsl:call-template name="length-normalize">
			<xsl:with-param name="length" select="." />
			<xsl:with-param name="unit" select="''" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="copy-attr" mode="CSS-attr">
		<xsl:value-of select="local-name()" />
		<xsl:text>:</xsl:text>
		<xsl:value-of select="." />
		<xsl:text>; </xsl:text>
	</xsl:template>

</xsl:stylesheet>