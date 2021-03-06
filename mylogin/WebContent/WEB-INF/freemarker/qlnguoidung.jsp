<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Quản lý người dùng</title>

<style>
body, input {
	font-family: Calibri, Arial;
	margin: 0px;
	padding: 0px;
}

#header h2 {
	color: white;
	background-color: #3275A8;
	height: 50px;
	padding: 5px 0 0 5px;
	font-size: 22px;
}

dÃ¹ng
	
.datatable {
	margin-bottom: 5px;
	border: 1px solid #eee;
	border-collapse: collapse;
	width: 400px;
	max-width: 100%;
	font-family: Calibri
}

.datatable th {
	padding: 3px;
	border: 1px solid #888;
	height: 30px;
	background-color: #B2D487;
	text-align: center;
	vertical-align: middle;
	color: #444444
}

.datatable tr {
	border: 1px solid #888
}

.datatable tr.odd {
	background-color: #eee
}

.datatable td {
	padding: 2px;
	border: 1px solid #888
}

#content {padding 5px;
	margin: 5px;
	text-align: center
}

fieldset {
	width: 300px;
	padding: 5px;
	margin-bottom: 0px;
}

legend {
	font-weight: bold;
}

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
<body>

	<div id="content">

		<fieldset>
			<legend>Add User</legend>
			<@s.form action="adduser.html" method="post"> <@s.textfield
			label="Tài khoản" name="user.username"/> <@s.textfield label="Mật
			khẩu" type="password" name="user.password"/> <@s.submit value="Lưu"/>
			<h3>
				<a href="index.html">Trang chủ</a>
			</h3>
			</@s.form>
		</fieldset>
		<br />
		<table class="datatable">
			<tr>
				<th>Tài khoản</th>
				<th>Mật khẩu</th>
				<th>Sửa</th>
				<th>Xóa</th>
			</tr>
			<#list userList as user>
			<tr>
				<td>${user.username}</td>
				<td>${user.password}</td>
				<td><a href="edituser.html?user.username=${user.username}">Sửa</a>
				</td>
				<td><a href="deleteuser.html?user.username=${user.username}">Xóa</a>
				</td>
			</tr>
			</#list>
		</table>
		<#if (actionErrors?? & actionErrors?size>0)>
		<div class="errors"><@s.actionerror /></div>
		</#if> <#if (actionMessages?? & actionMessages?size>0)>
		<div class="welcome"><@s.actionmessage /></div>
		</#if>
	</div>
</body>
</html>
