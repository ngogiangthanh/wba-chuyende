<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>File Upload</title>
</head>
<body>
You have uploaded the following file.
<hr>
File Name : ${userImageFileName} <br>
Content Type : ${userImageContentType}
<br/>
							<#list dataOfFile.entrySet() as entry>  
							${entry.key}<br/>
								<#assign listNoiDung = entry.value>
								<#list listNoiDung as noidung> 
									${noidung}<br/>
								</#list>
								</#list>
</body>
</html>