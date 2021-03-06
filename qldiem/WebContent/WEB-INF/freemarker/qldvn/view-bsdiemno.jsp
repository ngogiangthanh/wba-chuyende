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
							<i class="glyphicon glyphicon-th-list"></i>&nbsp;Bổ sung điểm nợ
						</div>
						<div class="panel-body">
							<a href="qldvn-ktdiemno.html" class="btn btn-default"/>Quay lại</a>&nbsp;
	                        <div class="clearfix">&nbsp;</div>
							<div class="table-responsive">
								<table class="table table-bordered text-center" id="dssv_no_diem">
									<thead>
										<tr>
											<td colspan="9" class="well">Danh sách sinh viên cần bổ sung điểm nợ (I)<br/>
											Đơn vị: ${tenKhoa}</td>
										</tr>
										<tr>
											<th class="text-center info">STT</th>
											<th class="text-center info">MSSV</th>
											<th class="text-center info">Họ tên</th>
											<th class="text-center info">Mã môn học</th>
											<th class="text-center info">Mã học phần</th>
											<th class="text-center info">Tên môn học</th>
											<th class="text-center info">Số TC</th>
											<th class="text-center info">Học kì - niên khóa</th>
											<th class="text-center info">Thao tác</th>
										</tr>
									</thead>
									<tbody>
										<#if dsSVCanBS?has_content> 
										<#list dsSVCanBS as sv> 
										<tr id="${sv.id_hp}_${sv.id_sv}">
											<td>${sv.stt}</td>
											<td>${sv.mssv}</td>
											<td>${sv.ho_ten}</td>
											<td>${sv.ma_mh}</td>
											<td>${sv.ma_hp}</td>
											<td>${sv.ten_hp}</td>
											<td>${sv.so_tc}</td>
											<td>${sv.hk}&nbsp;-&nbsp;${sv.nk}</td>
											<td><a href='#' data-toggle="modal" data-target="#nhapDiemModal"  onclick="setInfor2Form('${sv.id_sv}','${sv.ho_ten}','${sv.mssv}','${sv.cai_thien}','${sv.id_hp}');" ><i class="glyphicon glyphicon-plus"></i>&nbsp;Nhập điểm</a></td>
										</tr>
										</#list> 
										<#else>
										<tr>
											<td colspan="9">Không có sinh viên cần bổ sung điểm.</td>
										</tr>
										</#if>
									</tbody>
									<#if dsSVCanBS?has_content> 
									<tfoot>
										<tr>
											<td colspan="9" class="well"><a href="#" onclick="window.print()"><i class="glyphicon glyphicon-print"></i>&nbspIn</a></td>
										</tr>
									</tfoot>
									</#if>
								</table>
							</div>
						</div>
						</div>
					<!-- END CONTENT -->
					<!-- Bắt đầu nội dung modal nhập điểm -->
					<#if dsSVCanBS?has_content>
					<div class="modal fade" id="nhapDiemModal" tabindex="-1"
						role="dialog" aria-labelledby="myModalLabel">
						<div class="modal-dialog" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
									<h4 class="modal-title" id="myModalLabel">Khung nhập điểm</h4>
								</div>
								<div class="modal-body form-horizontal" role="form">
									<input name="id_hp" type="hidden" value="" /> 
									<input name="id_sv" type="hidden" value="" /> 
									<input name="cai_thien" type="hidden" value="" />
									<div class="form-group">
										<label for="title"
											class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
											<span class="glyphicon glyphicon-user text-info"></span>&nbsp;MSSV:
										</label>
										<div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
											<input type="text" value="" id="mssv" name="mssv"
												class="form-control" readonly="readonly" />
										</div>
									</div>
									<div class="form-group">
										<label for="title"
											class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
											<span class="glyphicon glyphicon-user text-info"></span>&nbsp;Họ
											tên:
										</label>
										<div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
											<input type="text" value="" id="ho_ten" name="ho_ten"
												class="form-control" readonly="readonly" />
										</div>
									</div>

									<div class="form-group">
										<label for="title"
											class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
											<span class="glyphicon glyphicon-tags"></span>&nbsp;&nbsp;Điểm
											10:
										</label>
										<div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
											<input type="number" id="diem_10" name="diem_10"
												class="form-control" min="0" max="10" step="0.50" value="0"/>
										</div>
									</div>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-success" id="btn_luu">Lưu</button>
									<button type="button" class="btn btn-default"
										data-dismiss="modal">Đóng</button>
								</div>
							</div>
						</div>
					</div>
					<!-- Kết thúc nội dung modal nhập điểm -->
					</#if>
				</div>
				<!--/span-->
			</div>
			<!--/row-->
		</div>
		
		<#if dsSVCanBS?has_content> 
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
							<strong>DS SINH VIÊN CẦN BỔ SUNG ĐIỂM NỢ</strong>
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
						<th class="text-center info">Mã môn học</th>
						<th class="text-center info">Mã học phần</th>
						<th class="text-center info">Tên môn học</th>
						<th class="text-center info">Số TC</th>
						<th class="text-center info">Học kì - niên khóa</th>
					</tr>
				</thead>
				<tbody>
					<#list dsSVCanBS as sv>
					<tr id="${sv.id_hp}_${sv.id_sv}_in">
						<td>${sv.stt}</td>
						<td>${sv.mssv}</td>
						<td>${sv.ho_ten}</td>
						<td>${sv.ma_mh}</td>
						<td>${sv.ma_hp}</td>
						<td>${sv.ten_hp}</td>
						<td>${sv.so_tc}</td>
						<td>${sv.hk}&nbsp;-&nbsp;${sv.nk}</td>
					</tr>
					</#list> 
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
					<td>&nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;Cảnh báo:&nbsp;Trong thời hạn 1 năm kể từ ngày kết thúc học kỳ của học phần nợ
					nếu sinh viên không bổ sung điểm sẽ bị điểm F.</td>
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
		</#if>
		
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

						<#if dsSVCanBS?has_content>
						//Xử lý nhập điểm
						$("#btn_luu").click(function(){
							var diem_10 = $("#diem_10").val();
							if($.isNumeric(diem_10) & (diem_10 >=0 && diem_10 <= 10)){
								$.getJSON('gv-luudiem.html', {
									id_hp : $("input[name=id_hp]").val(),
									id_sv : $("input[name=id_sv]").val(),
									diem_10 : $("input[name=diem_10]").val(),
									cai_thien : $("input[name=cai_thien]").val()
									
							      }, function(jsonResponse) {
							    	  if (jsonResponse.actionErrors.length > 0) {
							  			toastr["error"](jsonResponse.actionErrors);
							    	    }
							    	  if(jsonResponse.actionMessages.length > 0){
								  			toastr["info"](jsonResponse.actionMessages);
											$("#"+$("input[name=id_hp]").val()+"_"+$("input[name=id_sv]").val()).fadeOut(1000,function()
											{
												$(this).remove();
												delete_foot_tr();
											});
											$("#"+$("input[name=id_hp]").val()+"_"+$("input[name=id_sv]").val()+"_in").remove();
											$('#nhapDiemModal').modal('hide');
											$("input[name=diem_10]").val("0")
							    	  }
							      });
								} else{
						  			toastr["error"]("Điểm 10 nhập vào không hợp lệ! Vui lòng nhập lại!");
						  			$("input[name=diem_10]").focus()
								}
							
						});
						//Kết thúc xử lý nhập điểm
						</#if>
					});
		function setInfor2Form(id_sv, ho_ten, mssv, cai_thien,id_hp){
       		$("input[name=ho_ten]").val(ho_ten);
	        $("input[name=mssv]").val(mssv);
	        $("input[name=id_sv]").val(id_sv);
	        $("input[name=id_hp]").val(id_hp);
	        $("input[name=cai_thien]").val(cai_thien);
		}
		
		function delete_foot_tr(){
			if(isEmptyTable()){
				$('#dssv_no_diem > tfoot').remove();
				$('#dssv_no_diem > tbody').append("<tr><td colspan='9'>Không có sinh viên cần bổ sung điểm.</td></tr>");
			}
		}
		
		function isEmptyTable(){
			var tbody = $("#dssv_no_diem tbody");

			if (tbody.children().length == 0) {
				return true;
			}
			return false;
		}
		</script>
</body>
</html>
