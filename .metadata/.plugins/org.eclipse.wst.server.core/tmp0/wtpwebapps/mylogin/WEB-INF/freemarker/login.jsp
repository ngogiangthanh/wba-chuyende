<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Trang chủ đăng nhập</title>
<style type="text/css">
.errors {
	background-color: #FFCCCC;
	border: 1px solid #CC0000;
	width: 400px;
	margin-bottom: 8px;
}

.errors li {
	list-style: none;
}

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
	<h1>Đăng nhập</h1>
	<form action="login.html" method="post"
		onsubmit="return checkLogin(this)">
		<input type="text" name="username" /><br /> <input type="password"
			name="password" /><br /> <input type="submit" name="submit"
			value="Đăng nhập" />
	</form>
	<#if (actionErrors?? & actionErrors?size>0)>
	<div class="errors"><@s.actionerror /></div>
	</#if> <#if (actionMessages?? & actionMessages?size>0)>
	<div class="welcome"><@s.actionmessage /></div>
	</#if>
</body>

<script>
function checkLogin(frmLogin){
		var username = document.getElementsByName("username")[0].value;
		var password = document.getElementsByName("password")[0].value;
		if(username == ""){
			alert("Tài khoản không hợp lệ!");
			document.getElementsByName("username")[0].focus();
			return false;
		}
		else if (password == ""){
			alert("Mật khẩu không hợp lệ!");
			document.getElementsByName("password")[0].focus();
			return false;
		}
		else
			return true;
}
</script>
</html>