<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ÄÄng nháº­p thÃ nh cÃ´ng</title>
<style type="text/css">
.welcome {
	background-color: #DDFFDD;
	border: 1px solid #009900;
	width: 200px;
}

.welcome li {
	list-style: none;
}
</style>
</head>
<body>
	<center>
		<h3>
			Xin chÃ o, <i> ${username}</i>, báº¡n ÄÃ£ ÄÄng nháº­p vÃ o lÃºc ${time}!
		</h3>
		<h3>
			<a href="quanly.html">Quáº£n lÃ½ ngÆ°á»i dÃ¹ng</a>
		</h3>
		<h3>
			<a href="logout.html">Đăng xuất</a>
		</h3>
<#list information.entrySet() as entry>  
  ${entry.key}-${entry.value}<br/>
</#list>

	</center>
	<#if (actionMessages?? & actionMessages?size>0)>
	<div class="welcome"><@s.actionmessage /></div>
	</#if>
</body>
</html>