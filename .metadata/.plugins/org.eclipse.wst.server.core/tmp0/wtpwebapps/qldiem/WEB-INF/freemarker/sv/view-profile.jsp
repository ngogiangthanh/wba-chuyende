<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>${title}</title>
<link rel="shortcut icon" href="public/img/logo_dhct.ico" />
<!-- Bootstrap -->
<link href="public/css/bootstrap.min.css" rel="stylesheet" />
<!-- Custom styles for this template -->
<link href="public/css/admin.css" rel="stylesheet" />
<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
        <script src="public/js/html5shiv.js"></script>
        <script src="public/js/respond.min.js"></script>
        <![endif]-->
</head>
<body>
	<nav class="navbar navbar-inverse" role="navigation">
		<div class="container">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle navigation</span> <span
						class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="sv-index.html">
				<i class="glyphicon glyphicon-th-large"></i>&nbsp;Trang chủ sinh viên</a>
			</div>
			<!-- Collect the nav links, forms, and other content for toggling -->
			<div class="collapse navbar-collapse"
				id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown" style="font-size: 15px"><a href="#"
						class="dropdown-toggle" data-toggle="dropdown">Xin chào,
							${username}&nbsp;<b class="caret"></b>
					</a>
						<ul class="dropdown-menu">
							<li><a href="view-profile.html"><i
									class="glyphicon glyphicon-user"></i>&nbsp;Thông tin sinh viên</a></li>
							<li class="divider"></li>
							<li><a href="#"
								onclick="if (confirm('Xác nhận đăng xuất hệ thống?')) {
                                            location.href = 'logout.html';
                                            return true;
                                        } else {
                                            return false;
                                        }"><i
									class="glyphicon glyphicon-off"></i>&nbsp;Đăng xuất</a></li>
						</ul></li>
				</ul>
			</div>
			<!-- /.navbar-collapse -->
		</div>
		<!-- /.container-fluid -->
	</nav>
	<style type="text/css">
.dropdown-menu>li>a:hover {
	color: #000;
	font-weight: normal;
	font-size: 14px;
}

.dropdown-menu>li>a {
	color: #000;
}
</style>
	<div class="container">
		<div class="row">
			<div class="col-sm-12 col-xs-12 pull-right">
				<div class="row">
					<!-- BEGIN CONTENT -->
					<div class="panel panel-default">
						<div class="panel-heading">
							<i class="glyphicon glyphicon-pencil"></i>&nbsp;Thông tin sinh viên
						</div>
						<div class="panel-body">
						<ul class="list-group">
							<#list information.entrySet() as entry>  
							<#switch entry.key>
							 <#case "1_MSSV">
						     	<li class="list-group-item">Mã số sinh viên:&nbsp;${entry.value}</li>
							    <#break>
							  <#case "2_HO_TEN">
						     	<li class="list-group-item">Họ tên sinh viên:&nbsp;${entry.value}</li>
							    <#break>
							  <#case "3_GIOI_TINH">
						     	<li class="list-group-item">Giới tính:&nbsp;
						     		<#if entry.value == '0'>
						     			Nam
						     		<#elseif entry.value == '1'>
						     			Nữ
						     		</#if>
						     	</li>
							    <#break>
							  <#case "4_NGAY_SINH">
						     	<li class="list-group-item">Ngày sinh:&nbsp;${entry.value}</li>
							    <#break>
							  <#case "5_LOP">
						     	<li class="list-group-item">Lớp:&nbsp;${entry.value}</li>
							    <#break>	
							  <#case "6_TEN_LOP">
						     	<li class="list-group-item">Tên lớp:&nbsp;${entry.value}</li>
							    <#break>	
							  <#case "7_CHUYEN_NGANH">
						     	<li class="list-group-item">Chuyên ngành:&nbsp;${entry.value}</li>
							    <#break>	
							  <#case "8_KHOA">
						     	<li class="list-group-item">Khoa:&nbsp;${entry.value}</li>
							    <#break>								    						    						    						    
							</#switch>
						     </#list>
						</ul>
						</div>
					</div>
					<!-- END CONTENT -->
				</div>
				<!--/span-->
			</div>
			<!--/row-->
		</div>
		<!--/.container-->
		<script type="text/javascript" src="public/js/jquery-1.10.0.min.js"></script>
		<!-- Include all compiled plugins (below), or include individual files as needed -->
		<script type="text/javascript" src="public/js/bootstrap.min.js"></script>
		<script type="text/javascript">
			$(document).ready(
					function() {
						$('#sidebar .panel-heading').click(
								function() {
									$('#sidebar .list-group').toggleClass(
											'hidden-xs');
									$('#sidebar .panel-heading b').toggleClass(
											'glyphicon-plus-sign').toggleClass(
											'glyphicon-minus-sign');
								});
					});
		</script>
</body>
</html>