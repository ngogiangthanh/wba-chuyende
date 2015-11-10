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
				<a class="navbar-brand" href="sv-index.html"> <i
					class="glyphicon glyphicon-th-large"></i>&nbsp;Trang chủ sinh viên
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
							<i class="glyphicon glyphicon-th-list"></i>&nbsp;Xem kết quả học tập
						</div>
						<div class="panel-body">
						<div class="alert alert-success text-center" role="alert">
							<form action="view-mark.html" method="post">
								Năm học:&nbsp;
								<select name="nk"  id="id_nk" >
								<#list hknk.entrySet() as entry>  
									<option value="${entry.key}">${entry.key}</option>
								</#list>
									<option value="0" >Tất cả</option>
								</select> 
								&nbsp;Học kỳ&nbsp; <select name="hk" id="id_hk">
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">Hè</option>
									<option value="0">Tất cả</option>
								</select>&nbsp; 
								<input type="submit" value="Liệt kê" class="btn btn-primary"/>
							</form>
							</div>
						<#if dsDiemHP?has_content>
							<#list dsDiemHP.entrySet() as hknk_ds_hocPhan>  
							<#assign tsTCDK = 0 >
							<#assign tstchk = 0 >
							<#assign tdtbHK = 0 >
							<#assign tstctlhk = 0 >
							<table class="table table-bordered text-center">
							<tr><td colspan="10" class="well">Năm học:&nbsp;${hknk_ds_hocPhan.key.nk}&nbsp;-&nbsp;Học kỳ:&nbsp;${hknk_ds_hocPhan.key.hk}</td></tr>
								<tr>
									<td>STT</td>
									<td>Mã học phần</td>
									<td>Tên học phần</td>
									<td>Điều kiện</td>
									<td>Nhóm</td>
									<td>Tín chỉ</td>
									<td>Điểm chữ</td>
									<td>Điểm số</td>
									<td>Cải thiện</td>
									<td>Tích lũy</td>
								</tr>
								<#assign listHocPhan = hknk_ds_hocPhan.value>
								<#if listHocPhan?has_content>
								<#list listHocPhan as hocPhan>  
								<tr style="border: 1px solid #ccc">
									<td>${hocPhan.stt}</td>
									<td>${hocPhan.maMH}</td>
									<td>${hocPhan.tenHP}</td>
									<td>
										<#if hocPhan.hpDieuKien == "1">
											x
										</#if>
									</td>
									<td>${hocPhan.maHP}</td>
									<td>
										<#assign tsTCDK = tsTCDK + hocPhan.soTC >		
										${hocPhan.soTC}
									</td>
									<td>
										<#if hocPhan.diemChu??>
											${hocPhan.diemChu}
										</#if>
									</td>
									<td><#if hocPhan.diem10?? && hocPhan.diem10 lt 11 >${hocPhan.diem10}</#if></td>
									<td>
										<#if hocPhan.caiThien == "1">
											*
										</#if>
									</td>
									<td>
										<#if hocPhan.tichLuy == "1">
											<#assign tstctlhk = tstctlhk + hocPhan.soTC >
											*
										</#if>
									</td>
								</tr>
										<#if hocPhan.tichLuyDiem == "1">
											<#assign tdtbHK = tdtbHK + hocPhan.tichDiem >
											<#assign tstchk = tstchk + hocPhan.soTC >
										</#if>
								</#list>
								<#else>
								<tr>
									<td colspan="10">
										Không có học phần nào.
									</td>
								</tr>
								</#if>
								<#if tstchk == 0>
									<#assign tstchk = 1 >
								</#if>
							</table>
							<ul class="col-xs-4 col-sm-4 col-md-4 col-lg-4 list-group">
								<li class="list-group-item">Tổng số tín chỉ đăng ký:&nbsp;<span class="badge">${tsTCDK}</span></li>
								<li class="list-group-item">Điểm trung bình học kỳ:&nbsp;<span class="badge">${(tdtbHK/tstchk)?string("0.00")}</span></li>
								<li class="list-group-item">Tổng số tín chỉ tích lũy học kỳ:&nbsp;<span class="badge">${tstctlhk}</span></li>
								<li class="list-group-item">Điểm trung bình tích lũy:&nbsp;<span class="badge">-1</span></li>
								<li class="list-group-item">Tổng số tín chỉ tích lũy:&nbsp;<span class="badge">-1</span></li>
							</ul>
							</#list>
							<#else>
								<div class="alert alert-warning" role="alert">Học kỳ chưa mở. Vui lòng chọn lại học kỳ - năm học khác.</div>
							</#if>
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
			$(document).ready(function() {
						$('#sidebar .panel-heading').click(
								function() {
									$('#sidebar .list-group').toggleClass(
											'hidden-xs');
									$('#sidebar .panel-heading b').toggleClass(
											'glyphicon-plus-sign').toggleClass(
											'glyphicon-minus-sign');
								});
						<#if nk?has_content>
							$("select#id_nk").val("${nk}");
						</#if>
						<#if hk?has_content>
							$("select#id_hk").val("${hk}");
						</#if>
					});
		</script>
</body>
</html>
