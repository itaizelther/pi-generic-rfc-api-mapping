<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:map="java:java.util.Map"
	xmlns:dyn="java:com.sap.aii.mapping.api.DynamicConfiguration"
	xmlns:key="java:com.sap.aii.mapping.api.DynamicConfigurationKey">
	
	<xsl:output indent="no"/>
	<xsl:param name="inputparam"/>
	
	<xsl:variable name="dynamic-conf" select="map:get($inputparam, 'DynamicConfiguration')"/>
	<xsl:variable name="dynamic-key" select="key:create('http://sap.com/xi/XI/System/REST', 'resource2')"/>
	<xsl:variable name="function" select="dyn:get($dynamic-conf, $dynamic-key)"/>
	
	<xsl:template match="/">
		<xsl:element name="ns0:{$function}" namespace="urn:sap-com:document:sap:rfc:functions">
			<xsl:copy-of select="*/node()"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
