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
				<a class="navbar-brand" href="index.html"> <i
					class="glyphicon glyphicon-th-large"></i>&nbsp;Trang chủ
				</a>
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
				<div class="panel panel-default">
						<div class="panel-heading">
							<i class="glyphicon glyphicon-th-list"></i>&nbsp;Nhập điểm ${ma_hp}&nbsp;-&nbsp;${ten_mh}&nbsp;-&nbsp;Học kỳ:&nbsp;${hk}&nbsp;-&nbsp;Niên khóa:&nbsp;${nk} 
						</div>
						<div class="panel-body">
						     <form id="" class="form-horizontal" method="post" action="gv-luudiem.html" role="form">
					            <input name="id_hp" type="hidden" value="${id_hp}"/>
					            <input name="id_sv" type="hidden" value="${id_sv}"/>
					            <input name="cai_thien" type="hidden" value="${cai_thien}"/>
					            <div class="form-group">
					                <label for="title" class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
                                        <span class="glyphicon glyphicon-user text-info"></span>&nbsp;MSSV:</label>
					                <div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
                                        <input type="text" value="${mssv}" id="mssv" name="mssv" class="form-control" readonly="readonly"/>
					                </div>
					            </div>
					            <div class="form-group">
					                <label for="title" class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
                                        <span class="glyphicon glyphicon-user text-info"></span>&nbsp;Họ tên:</label>
					                <div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
                                        <input type="text" value="${ho_ten}" id="ho_ten" name="ho_ten" class="form-control" readonly="readonly"/>
					                </div>
					            </div>
					            <div class="form-group">
					                <label for="title" class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
                                        <span class="glyphicon glyphicon-tags"></span>&nbsp;&nbsp;Điểm 10:</label>
					                <div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
                                        <input type="number" value="${diem_10}" id="diem_10" name="diem_10" class="form-control" min="0" max="10" step="0.50"/>
					                </div>
					            </div>
					            <div class="form-group">
					                <div class="col-sm-offset-3 col-xs-offset-3 col-md-offset-3 col-lg-offset-3 col-sm-9 col-xs-9 col-md-9 col-lg-9">
					                    <button type="button" class="btn btn-success" id="btn_luu">Lưu</button>&nbsp;
					                </div>
					            </div>
					        </form>
						</div>
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
    <script type="text/javascript" src="public/js/toastr.js"></script>
	<script type="text/javascript">
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
						$("#btn_luu").click(function(){
							var diem_10 = $("#diem_10").val();
							$.getJSON('gv-luudiem.html', {
								id_hp : '${id_hp}',
								id_sv : '${id_sv}',
								diem_10 : diem_10,
								cai_thien : '${cai_thien}'
								
						      }, function(jsonResponse) {
						    	  if (jsonResponse.actionErrors.length > 0) {
						  			toastr["error"](jsonResponse.actionErrors);
						    	    }
						    	  if(jsonResponse.actionMessages.length > 0){
							  			toastr["info"](jsonResponse.actionMessages);
						    	  }
						      });
						});
					});
		</script>
</body>
</html>
