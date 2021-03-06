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
<link href="public/css/toastr.css" rel="stylesheet" type="text/css"/>
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
	<div class="container">
		<div class="row">
			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
				<div class="row">
					<!-- BEGIN CONTENT -->
					<div id="login">
						<div class="container">
							<div class="panel panel-default">
								<div class="panel-heading ">
									<h4>
										<i class="glyphicon glyphicon-cog"></i>&nbsp;Đăng nhập hệ thống
									</h4>
								</div>
								<div class="panel-body">
									<form method="post" action="login.html" class="form-signin"
										role="form" onsubmit="return checkLogin(this)">
										<div class="form-group">
											<input name="username" type="text"
												class="form-control input-lg"
												placeholder="MSCB hoặc MSSV" required="" autofocus>
										</div>
										<div class="form-group">
											<input name="password" type="password"
												class="form-control input-lg" placeholder="Mật khẩu"
												required="">
										</div>
										<button class="btn btn-lg btn-primary btn-block" type="submit">Đăng
											nhập</button>
									</form>
								</div>
							</div>
							<!-- /container -->
						</div>
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
        <script type="text/javascript" src="public/js/toastr.js"></script>
		<script type="text/javascript">
			$(document).ready(
					function() {
						toastr.options = {
						  "closeButton": true,
						  "debug": true,
						  "newestOnTop": false,
						  "progressBar": true,
						  "positionClass": "toast-top-right",
						  "preventDuplicates": false,
						  "onclick": null,
						  "showDuration": "300",
						  "hideDuration": "1000",
						  "timeOut": "5000",
						  "extendedTimeOut": "1000",
						  "showEasing": "swing",
						  "hideEasing": "linear",
						  "showMethod": "fadeIn",
						  "hideMethod": "fadeOut"
						}
						$('#sidebar .panel-heading').click(
								function() {
									$('#sidebar .list-group').toggleClass(
											'hidden-xs');
									$('#sidebar .panel-heading b').toggleClass(
											'glyphicon-plus-sign').toggleClass(
											'glyphicon-minus-sign');
								});
						
						<#if (actionErrors?? & actionErrors?size>0)>
							toastr["error"]("${actionErrors}");
						</#if> 
						<#if (actionMessages?? & actionMessages?size>0)>
							toastr["info"]("${actionMessages}");
						</#if>
						
					});
			
					function checkLogin(frmLogin) {
						var username = document
								.getElementsByName("username")[0].value;
						var password = document
								.getElementsByName("password")[0].value;
						if (username == "") {
							toastr["error"]("Tài khoản không hợp lệ!")
							document.getElementsByName("username")[0]
									.focus();
							return false;
						} else if (password == "") {
							toastr["error"]("Mật khẩu không hợp lệ!")
							document.getElementsByName("password")[0]
									.focus();
							return false;
						} else
							return true;
					}
		</script>
</body>
</html>
