<html lang="vi">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Trang chủ</title>
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
				<a class="navbar-brand" href=""><i
					class="glyphicon glyphicon-th-large"></i>&nbsp;Đăng nhập hệ thống</a>
			</div>
		</div>
		<!-- /.container-fluid -->
	</nav>
	<style type="text/css">
</style>
	<div class="container">
		<div class="row">
			<div class="col-sm-12 col-xs-12 pull-right">
				<div class="row">
					<!-- BEGIN CONTENT -->
					<div id="login">
						<div class="container">
							<div class="panel panel-default">
								<div class="panel-heading ">
									<h4>
										<i class="glyphicon glyphicon-cog"></i>&nbsp; Lựa chọn nhóm
										quyền sử dụng
									</h4>
								</div>
								<div class="panel-body">
									<#list roles.entrySet() as entry>
										<a href="${entry.key}.html">${entry.value.name}</a><br /> 
									</#list>
									<h3>
										<a href="logout.html">Đăng xuất</a>
									</h3>
								</div>
							</div>
							<!-- /container -->
						</div>

						<!-- END CONTENT -->
					</div>
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