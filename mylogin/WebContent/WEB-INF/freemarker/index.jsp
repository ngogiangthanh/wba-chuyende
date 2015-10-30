<#if !logined??>
		<#include "login.jsp">
<#else>
		<#switch logined>
				<#case "true">
						<#include "welcome.jsp">
			    <#break>
		</#switch>
</#if>