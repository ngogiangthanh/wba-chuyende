<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Chỉnh sửa người dùng</title>

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
</style>
<body>

	<div id="content">

		<fieldset>
			<legend>Add User</legend>
			<@s.form action="edituserexecute.html" method="post"> <@s.textfield
			label="Tài khoản" name="user.username" readonly="readonly"
			value="${user.username}"/> <@s.textfield label="Mật khẩu"
			type="password" name="user.password" value="${user.password}"/>
			<@s.submit value="Lưu"/>
			<h3>
				<a href="index.html">Trang chủ</a>
			</h3>
			<h3>
				<a href="quanly.html">Trang chủ quản lý người dùng</a>
			</h3>
			</@s.form>
		</fieldset>
		<br /> <#if (actionErrors?? & actionErrors?size>0)>
		<div class="errors"><@s.actionerror /></div>
		</#if>
	</div>
</body>
</html>
