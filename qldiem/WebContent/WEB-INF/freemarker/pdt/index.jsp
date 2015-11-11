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
				<a class="navbar-brand" href="index.html">
				<i class="glyphicon glyphicon-th-large"></i>&nbsp;Trang chủ</a>
			</div>
			<!-- Collect the nav links, forms, and other content for toggling -->
			<div class="collapse navbar-collapse"
                     id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown" style="font-size: 15px"><a href="#"
                                                                        class="dropdown-toggle" data-toggle="dropdown">Xin chào, ${username}&nbsp;<b
                                    class="caret"></b></a>
                            <ul class="dropdown-menu">
                            	<#if roles?size gt 1>
                            	 <li><a href="index.html"><i
                                            class="glyphicon glyphicon-list-alt"></i>&nbsp;Bảng điều khiển</a></li>
                            	</#if>
                                <li><a href="view-profile-cb.html"><i
                                            class="glyphicon glyphicon-user"></i>&nbsp;Thông tin cán bộ</a></li>
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
			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
				<div class="row">
					<!-- BEGIN CONTENT -->
					  <div id="menu">
                            <a href="pdt-indiem.html" class="col-sm-6 col-xs-6 col-md-6 col-lg-6">
                                <i class="glyphicon glyphicon-print"></i>&nbsp;In bảng điểm
                            </a>
                        </div>
					<!-- END CONTENT -->
				</div>
				<!--/span-->
			</div>
			<!--/row-->
		</div>
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
