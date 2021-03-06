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
			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
				<div class="row">
					<!-- BEGIN CONTENT -->
					<div class="panel panel-default">
						<div class="panel-heading">
							<i class="glyphicon glyphicon-th-list"></i>&nbsp;Xem kết quả học tập
						</div>
						<div class="panel-body">
						<a href="index.html" class="btn btn-default"/>Quay lại</a>&nbsp;
	                    <div class="clearfix">&nbsp;</div>
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
							<#assign tstcdkhk = 0 >
							<#assign tstchk = 0 >
							<#assign tdtbHK = 0 >
							<#assign tstctlhk = 0 >
							 <div class="table-responsive"> 
							<table class="table table-bordered text-center">
							<tr><td colspan="10" class="well">Năm học:&nbsp;${hknk_ds_hocPhan.key.nk}&nbsp;-&nbsp;Học kỳ:&nbsp;${hknk_ds_hocPhan.key.hk}</td></tr>
								<tr>
									<th class="text-center info">STT</th>
									<th class="text-center info">Mã môn học</th>
									<th class="text-center info">Tên môn học</th>
									<th class="text-center info">Điều kiện</th>
									<th class="text-center info">Nhóm học phần</th>
									<th class="text-center info">Tín chỉ</th>
									<th class="text-center info">Điểm chữ</th>
									<th class="text-center info">Điểm số</th>
									<th class="text-center info">Cải thiện</th>
									<th class="text-center info">Tích lũy</th>
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
										${hocPhan.soTC}
									</td>
									<td>
										<#if hocPhan.diemChu != "W">
											<#assign tstcdkhk = tstcdkhk + hocPhan.soTC >	
										</#if>
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
									<#if hocPhan.diemChu != "W" & hocPhan.diemChu != "M" & hocPhan.diemChu != "I" & hocPhan.diemChu != "">
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
							</div>
							<ul class="list-group pull-left">
								<li class="list-group-item list-group-item-success">Tổng số tín chỉ đăng ký:&nbsp;<span class="badge">${tstcdkhk}</span></li>
								<li class="list-group-item list-group-item-info">Điểm trung bình học kỳ:&nbsp;<span class="badge">${(tdtbHK/tstchk)?string("0.00")}</span></li>
								<li class="list-group-item list-group-item-success">Tổng số tín chỉ tích lũy học kỳ:&nbsp;<span class="badge">${tstctlhk}</span></li>
								<li class="list-group-item list-group-item-info">Điểm trung bình tích lũy:&nbsp;<span class="badge">${hknk_ds_hocPhan.key.tbctl?string("0.00")}</span></li>
								<li class="list-group-item list-group-item-success">Tổng số tín chỉ tích lũy:&nbsp;<span class="badge">${hknk_ds_hocPhan.key.tstctl}</span></li>
							</ul>
							</#list>
							<#else>
								<div class="alert alert-warning" role="alert">Học kỳ chưa mở. Vui lòng chọn lại học kỳ - năm học khác.</div>
							</#if>
						</div>
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
