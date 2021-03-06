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
</style>
	<div class="container">
		<div class="row">
			<div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
				<div class="row">
					<!-- BEGIN CONTENT -->
					    <div class="panel panel-default">
						<div class="panel-heading">
							<i class="glyphicon glyphicon-th-list"></i>&nbsp;Nhập điểm M, I cho sinh viên
						</div>
						<div class="panel-body">
						<#if nhapDiemNo>
							<div role="form">
								<div class="form-group">
					                <div class="col-sm-4 col-xs-4 col-md-4 col-lg-4">
                                        <input type="search" id="id_mssv" name="mssv" value="" class="form-control" placeholder="Nhập MSSV "/>
					                </div>
					                <div class="col-sm-4 col-xs-4 col-md-4 col-lg-4">
                                        <input type="search" id="id_ma_hp" name="ma_hp" value="" class="form-control" placeholder="Nhập mã học phần "/>
					                </div>
					                <div class="col-sm-4 col-xs-4 col-md-4 col-lg-4">
								        <button type="button" class="btn btn-success" id="btn_tim">Tìm</button>
										<button type="button" onclick="location.href='qldvn-index.html'" class="btn btn-default"/>Quay lại</button>&nbsp;
										<button type="button" id="btn_clear_content" class="btn btn-warning" style="display:none"/>Xóa kết quả</button>&nbsp;
					                </div>
					            </div>
	                        	<div class="clearfix">&nbsp;</div>
							<div id="id_content_kq" style="display:none">
								<div class="table-responsive">
										<table class="table table-bordered text-center" id="sv_nhap_diem">
											<thead>
												<tr>
													<th class="text-center info">MSSV</th>
													<th class="text-center info">Họ tên</th>
													<th class="text-center info">Lớp</th>
													<th class="text-center info">Tên lớp</th>
													<th class="text-center info">Môn học</th>
													<th class="text-center info">Thao tác</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td class="mssv"></td>
													<td class="ho_ten"></td>
													<td class="lop"></td>
													<td class="ten_lop"></td>
													<td class="mon_hoc"></td>
													<td><a href='#' data-toggle="modal" data-target="#nhapDiemModal" ><i class="glyphicon glyphicon-plus"></i>&nbsp;Nhập điểm</a></td>
												</tr>
											</tbody>
										</table>
									</div>
							</div>
							</div>
						</div>
						<#else>
							<button type="button" onclick="location.href='qldvn-index.html'" class="btn btn-default"/>Quay lại</button>&nbsp;
	                        	<div class="clearfix">&nbsp;</div>
							<div class="alert alert-warning text-center" role="alert">
							Chưa đến thời gian nhập điểm nợ.
							</div>
						</#if>
						</div>
					<!-- END CONTENT -->
				</div>
				<!--/span-->
			</div>
			<!--/row-->
		</div>
		</div>

	<#if nhapDiemNo>
	<!-- Bắt đầu nội dung modal nhập điểm -->
	<div class="modal fade" id="nhapDiemModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
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
					<input name="id_hp" id="id_hp" type="hidden" value="" /> 
					<input name="mssv_modal" id="mssv_modal"  type="hidden" value="" /> 
					<div class="form-group">
						<label for="title"
							class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
							<span class="glyphicon glyphicon-calendar"></span>&nbsp;Học kỳ:
						</label>
						<div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
							<input type="text" value="${current_hk}" id="hk" name="hk"
								class="form-control" readonly="readonly" />
						</div>
					</div>
					<div class="form-group">
						<label for="title"
							class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
							<span class="glyphicon glyphicon-calendar"></span>&nbsp;Niên khóa:
						</label>
						<div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
							<input type="text" value="${current_nk}" id="nk" name="nk"
								class="form-control" readonly="readonly" />
						</div>
					</div>
					<div class="form-group">
						<label for="title"
							class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
							<span class="glyphicon glyphicon-barcode"></span>&nbsp;Mã học phần:
						</label>
						<div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
							<input type="text" value="" id="ma_hp_modal" name="ma_hp_modal"
								class="form-control" readonly="readonly" />
						</div>
					</div>
					<div class="form-group">
						<label for="title"
							class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
							<span class="glyphicon glyphicon-user text-info"></span>&nbsp;Tên môn học:
						</label>
						<div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
							<input type="text" value="" id="ten_mh_modal" name="ten_mh_modal"
								class="form-control" readonly="readonly" />
						</div>
					</div>
					<div class="form-group">
						<label for="title"
							class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
							<span class="glyphicon glyphicon-tags"></span>&nbsp;&nbsp;Điểm:
						</label>
						<div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
							<select name="diem_select" id="diem_select" class="form-control">
								<option value="">-Chọn-</option>
								<option value="M">Điểm M</option>
								<option value="I">Điểm I</option>
							</select>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" id="btn_luu">Lưu</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
				</div>
			</div>
		</div>
	</div>
	<!-- Kết thúc nội dung modal nhập điểm -->
	</#if>

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

						<#if nhapDiemNo>
						//Bắt đầu xử lý tìm sinh viên
						$("#btn_tim").click(function(){
			  				$('#diem_select option[value=]').attr('selected','selected');
							var mssv = $.trim($("#id_mssv").val());
							var ma_hp = $.trim($("#id_ma_hp").val());
							//--kiem tra rang buoc
							if(mssv.length > 8 || mssv.length <= 0){
								toastr["error"]("Mã số sinh viên không hợp lệ!");
								$("#id_mssv").focus();
								return false;
							}
							else if(ma_hp.length > 8 || ma_hp.length <= 0){
								toastr["error"]("Mã học phần không hợp lệ!");
								$("#id_ma_hp").focus();
								return false;
							}
							var formData = new FormData();
							formData.append('mssv', mssv);
							formData.append('ma_hp', ma_hp);
							$.ajax({
					                url: "qldvn-xulytimsv.html",
					                type: "POST",
					                dataType: "json",
					                processData: false,
					                contentType: false,
					                cache: false,
					                data: formData
					            }).done(function(data) {
					            	if(data.kq_sv != null){
					            		$("input[name='id_sv_find']").val(data.kq_sv["id_sv"]);
										$('#sv_nhap_diem > tbody > tr > td.mssv').text(data.kq_sv["mssv"]);
										$('#sv_nhap_diem > tbody > tr > td.ho_ten').text(data.kq_sv["ho_ten"]);
										$('#sv_nhap_diem > tbody > tr > td.lop').text(data.kq_sv["lop"]);
										$('#sv_nhap_diem > tbody > tr > td.ten_lop').text(data.kq_sv["ten_lop"]);
										$('#sv_nhap_diem > tbody > tr > td.mon_hoc').text(data.kq_sv["ten_mh"]);
						  				$("#id_content_kq").show("slow");
						  				$("#btn_clear_content").show("slow");
										$("#id_hp").val(data.kq_sv["id_hp"]);
										$("#mssv_modal").val(data.kq_sv["mssv"]);
										$("#ma_hp_modal").val(ma_hp);
										$("#ten_mh_modal").val(data.kq_sv["ten_mh"]);
										$("#id_mssv").val('');
										$("#id_ma_hp").val('');
					            	}
					            	else{
										toastr["warning"]("Không tìm thấy sinh viên có mã số và học học phần này!");
										$("#id_mssv").focus();
					            	}
					            });
						});
						//Kết thúc xử lý tìm sinh viên
						
						$("#btn_clear_content").click(function(){
							$("#id_content_kq").hide("slow");
			  				$("#btn_clear_content").hide("slow");
			  				$('#diem_select option[value=]').attr('selected','selected');
						});
						//Bắt đầu xử lý nhập điểm
						$("#btn_luu").click(function(){
							var diem_chu = $("#diem_select option:selected" ).val();
							//--kiem tra rang buoc
							if(diem_chu == ""){
								toastr["error"]("Vui lòng chọn điểm!");
								$("#diem_select").focus();
								return false;
							}
							//Gọi ham ajax jquery
							var formData = new FormData();
							formData.append('id_hp', $("#id_hp").val());
							formData.append('mssv', $("#mssv_modal").val());
							formData.append('diem_chu', diem_chu);
							$.ajax({
				                url: "qldvn-xulynhapdiemno.html",
				                type: "POST",
				                dataType: "json",
				                processData: false,
				                contentType: false,
				                cache: false,
				                data: formData
				            }).done(function(data) {
				            	if (data.actionErrors.length > 0) {
						  			toastr["error"](data.actionErrors);
						    	    }
						    	  if(data.actionMessages.length > 0){
							  		toastr["info"](data.actionMessages);
						    	  }
				            });
							
						});
						//Kết thúc xử lý nhập điểm
						</#if>
					});
		<#if (actionErrors?? & actionErrors?size>0)>
			toastr["error"]("${actionErrors}");
		</#if> 
		<#if (actionMessages?? & actionMessages?size>0)>
			toastr["info"]("${actionMessages}");
		</#if>
		</script>
</body>
</html>
