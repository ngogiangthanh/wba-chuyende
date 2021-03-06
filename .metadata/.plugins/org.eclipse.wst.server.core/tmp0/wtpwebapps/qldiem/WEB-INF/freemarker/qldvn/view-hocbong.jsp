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
#display_print{
	display: none !important;
}
</style>
</style>
	<style type="text/css" media="print">
@media print {
	#none_print {
		display: none !important;
	}
	#display_print {
		display: block !important;
	}
	body {
		background-color: #fff;
		margin-top: 0mm;
		margin-bottom: 0mm;
	}
	.page-break, table {
		page-break-inside: avoid;
	}
	tr {
		page-break-inside: avoid;
		page-break-after: avoid;
	}
	thead {
		display: table-header-group;
	}
	tfoot {
		display: table-footer-group;
		margin-top: 25mm;
	}
	@page {
		size: A4;
		margin: 2cm; /* this affects the margin in the printer settings */
	}
	@page :left {
		margin-left: 2.5cm;
		margin-right: 2.5cm;
	}
	@page :right {
		margin-right: 2.5cm;
		margin-left: 2.5cm;
	}
}
</style>
	<div class="container">
		<div class="row" id="none_print">
			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
				<div class="row">
					<!-- BEGIN CONTENT -->
					    <div class="panel panel-default">
						<div class="panel-heading">
							<i class="glyphicon glyphicon-th-list"></i>&nbsp;Lập danh sách sinh viên nhận học bổng
						</div>
						<div class="panel-body">
							<a href="qldvn-thongke.html" class="btn btn-default"/>Quay lại</a>&nbsp;
	                        <div class="clearfix">&nbsp;</div>
							<div class="table-responsive">
								<table class="table table-bordered text-center">
									<thead>
										<tr>
											<td colspan="6" class="well">Danh sách sinh viên nhận
												được học bổng - Niên
												khóa:&nbsp;${current_nk}&nbsp;-&nbsp;Học
												kỳ:&nbsp;${current_hk} <br /> <strong>${tenKhoa}</strong>
											</td>
										</tr>
										<tr>
											<th class="text-center info">STT</th>
											<th class="text-center info">MSSV</th>
											<th class="text-center info">Họ tên</th>
											<th class="text-center info">Giới tính</th>
											<th class="text-center info">Ngày sinh</th>
											<th class="text-center info">ĐTB</th>
										</tr>
									</thead>
									<tbody>
										<#if dsSVNhanHB?has_content> <#list dsSVNhanHB.entrySet() as
										list_dssv> <#assign dssv = list_dssv.value> <#assign flag = 0
										> <#list dssv as sv> <#if flag = 0>
										<tr class="warning">
											<td colspan="6"><strong>${sv.ten_lop} -
													${sv.lop}</strong> <#assign flag = 1 ></td>
										</tr>
										</#if>
										<tr>
											<td>${sv.stt}</td>
											<td>${sv.mssv}</td>
											<td>${sv.ho_ten}</td>
											<td>${sv.gioi_tinh}</td>
											<td>${sv.ngay_sinh?string["dd/MM/yyyy"]}</td>
											<td>${sv.dtb}</td>
										</tr>
										</#list> <#assign flag = 0 > </#list> <#else>
										<tr>
											<td colspan="6">Không có sinh viên nào nhận học bổng.</td>
										</tr>
										</#if>
									</tbody>
									<#if dsSVNhanHB?has_content>
									<tfoot>
										<tr>
											<td colspan="6"><a href="#" onclick="window.print()"><i
													class="glyphicon glyphicon-print"></i>&nbspIn</a></td>
										</tr>
									</tfoot>
									</#if>
								</table>
							</div>
						</div>
						</div>
					<!-- END CONTENT -->
				</div>
				<!--/span-->
			</div>
			<!--/row-->
		</div>
		
		<!--/Bat dau định dạng in-->
		<div class="row" id="display_print">
			<table
				class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right text-center">
				<tr>
					<td>BỘ GIÁO DỤC VÀ ĐÀO TẠO<br /> <strong>TRƯỜNG ĐẠI
							HỌC CẦN THƠ</strong>
					</td>
					<td><strong>CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</strong></br> <strong>Độc
							lập - Tự do - Hạnh phúc</strong>&nbsp;</td>
				</tr>
				<tr>
					<td>
						<p>
							<strong>Số......</strong>
						</p>
					</td>
					<td>
						<p>
						<h4>
							<strong>DS SINH VIÊN NHẬN HỌC BỔNG</strong>
						</h4>
						</p>
					</td>
				</tr>
			</table>
			<div class="clearfix">&nbsp;</div>
			<table class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
				<tbody>
					<tr>
						<td>Đơn vị:&nbsp;<strong>${tenKhoa}</strong>
						</td>
						<td>Trường:&nbsp;<strong>Đại học Cần Thơ</strong>
						</td>
					<tr>
					<tr>
						<td>Học kỳ:&nbsp;<strong>${current_hk}</strong>
						</td>
						<td>Niên khóa:&nbsp;<strong>${current_nk}</strong>
						</td>
					<tr>
				</tbody>
			</table>
			<div class="clearfix">&nbsp;</div>
			<table class="table table-bordered text-center">
				<thead>
					<tr>
						<th class="text-center info">STT</th>
						<th class="text-center info">MSSV</th>
						<th class="text-center info">Họ tên</th>
						<th class="text-center info">Giới tính</th>
						<th class="text-center info">Ngày sinh</th>
						<th class="text-center info">ĐTB</th>
					</tr>
				</thead>
				<tbody>
					<#if dsSVNhanHB?has_content> <#list dsSVNhanHB.entrySet() as
					list_dssv> <#assign dssv = list_dssv.value> <#assign flag = 0 >
					<#list dssv as sv> <#if flag = 0>
					<tr>
						<td colspan="6">${sv.ten_lop}&nbsp;-&nbsp;${sv.lop}
						<#assign flag = 1 ></td>
					</tr>
					</#if>
					<tr>
						<td>${sv.stt}</td>
						<td>${sv.mssv}</td>
						<td>${sv.ho_ten}</td>
						<td>${sv.gioi_tinh}</td>
						<td>${sv.ngay_sinh?string["dd/MM/yyyy"]}</td>
						<td>${sv.dtb}</td>
					</tr>
					</#list> <#assign flag = 0 > </#list> <#else>
					<tr>
						<td colspan="6">Không có sinh viên nào nhận học bổng.</td>
					</tr>
					</#if>
				</tbody>
			</table>
			<table class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right ">
				<tr class="">
					<td>
						<p>
							<em>*&nbsp;<u>Ghi chú:</u></em>
						</p>
					</td>
				</tr>
				<tr class="">
					<td>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;Điều kiện:&nbsp;Điểm trung bình học kỳ >= 2.5.</td>
				</tr>
				<tr class="">
					<td>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;Số lượng:&nbsp;Theo tỉ lệ 10% sĩ số mỗi lớp.</td>
				</tr>
			</table>
			<div class="clearfix">&nbsp;</div>
			<div class="clearfix">&nbsp;</div>
			<div
				class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center page-break">
				<#assign aDateTime = .now>
				<p class="pull-right">
					Cần
					Thơ,&nbsp;ngày&nbsp;${aDateTime?string["dd"]}&nbsp;tháng&nbsp;${aDateTime?string["MM"]}&nbsp;năm&nbsp;${aDateTime?string["yyyy"]}<br />
					<strong>Người in</strong><br />
					<br />
					<br />
					<br /> <em>(Ký và ghi rõ họ tên)</em>
				</p>
			</div>
		</div>
		<!--/Ket thuc định dạng in-->
		
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
