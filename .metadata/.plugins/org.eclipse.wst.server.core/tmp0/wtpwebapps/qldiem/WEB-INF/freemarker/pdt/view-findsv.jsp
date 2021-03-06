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
							<i class="glyphicon glyphicon-th-list"></i>&nbsp;Tìm kiếm sinh viên
						</div>
						<div class="panel-body">
							<div role="form">
								<div class="form-group">
					                <div class="col-sm-6 col-xs-6 col-md-6 col-lg-6">
                                        <input type="search" id="id_mssv" name="mssv" value="" class="form-control" placeholder="Nhập MSSV "/>
					                </div>
					                <div class="col-sm-6 col-xs-6 col-md-6 col-lg-6">
								        <button type="button" class="btn btn-success" id="btn_tim">Tìm</button>
										<button type="button" onclick="location.href='pdt-index.html'" class="btn btn-default"/>Quay lại</button>&nbsp;
										<button type="button" id="btn_clear_content" class="btn btn-warning" style="display:none"/>Xóa kết quả</button>&nbsp;
					                </div>
					            </div>
							</div>
	                        <div class="clearfix">&nbsp;</div>
							<div id="id_content_kq" style="display:none">
								<div class="table-responsive">
										<table class="table table-bordered text-center" id="sv_in">
										<thead>
											<tr>
												<th class="text-center info">MSSV</th>
												<th class="text-center info">Họ tên</th>
												<th class="text-center info">Lớp</th>
												<th class="text-center info">Niên khóa</th>
												<th class="text-center info">Học kỳ</th>
												<th class="text-center info">Thao tác</th>
											</tr>
											</thead>
											<tbody>
											<input type="hidden" value="" name="id_sv_find"/>
											<tr>
												<td class="mssv">
												</td>
												<td class="ho_ten">
												</td>
												<td class="lop">
												</td>
												<td>
													<select name="nk_select"  id="id_nk_select" >
													<#list hknk.entrySet() as entry>  
														<option value="${entry.key}">${entry.key}</option>
													</#list>
														<option value="0" >Tất cả</option>
													</select> 
												</td>
												<td>
													<select name="hk_select" id="id_hk_select">
														<option value="1">1</option>
														<option value="2">2</option>
														<option value="3">Hè</option>
														<option value="0">Tất cả</option>
													</select>
												</td>
												<td>
													<a href='#' onclick="setInfor2Form()"><i class="glyphicon glyphicon-print"></i>&nbsp;Lập bảng in</a>
												</td>
											</tr>
											</tbody>
										</table>
									</div>
							</div>
						</div>
						</div>
					<!-- END CONTENT -->
					<form action="pdt-printed-mark.html" method="post" target="_blank" id="frmPrintedMark">
						<input type="hidden" value="" id="id_id_sv" name="id_sv"/>
						<input type="hidden" value="" id="id_hk" name="hk"/>
						<input type="hidden" value="" id="id_nk" name="nk"/>
					</form>
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
						//Bắt đầu xử lý tìm sinh viên
						$("#btn_tim").click(function(){
							var mssv = $.trim($("#id_mssv").val());
							//--kiem tra rang buoc
							if(mssv.length > 8 || mssv.length <= 0){
								toastr["error"]("Mã số sinh viên không hợp lệ!");
								$("#id_mssv").focus();
								return false;
							}
							var formData = new FormData();
							formData.append('mssv', mssv);
							$.ajax({
					                url: "pdt-xulytimsv.html",
					                type: "POST",
					                dataType: "json",
					                processData: false,
					                contentType: false,
					                cache: false,
					                data: formData
					            }).done(function(data) {
					            	if(data.kq_sv != null){
					            		$("input[name='id_sv_find']").val(data.kq_sv["id_sv"]);
										$('#sv_in > tbody > tr > td.mssv').text(data.kq_sv["mssv"]);
										$('#sv_in > tbody > tr > td.ho_ten').text(data.kq_sv["ho_ten"]);
										$('#sv_in > tbody > tr > td.lop').text(data.kq_sv["lop"]+" - "+data.kq_sv["ten_lop"]);
						  				$("#id_content_kq").show("slow");
						  				$("#btn_clear_content").show("slow");
										$("#id_mssv").val('');
					            	}
					            	else{
										toastr["warning"]("Không tìm thấy sinh viên có mã số này!");
										$("#id_mssv").focus();
					            	}
					            });
						});
						//Kết thúc Xử lý tìm sinh viên

						$("#btn_clear_content").click(function(){
							$("#id_content_kq").hide("slow");
			  				$("#btn_clear_content").hide("slow");
						});
					});
		function setInfor2Form(){
			var id_sv = $("input[name='id_sv_find']").val();
			var hk = $("#id_hk_select option:selected").val();
			var nk = $("#id_nk_select option:selected").val();
			$("#id_id_sv").val(id_sv);
			$("#id_hk").val(hk);
			$("#id_nk").val(nk);
			$("#frmPrintedMark").submit();
			
		}
		<#if (actionErrors?? & actionErrors?size>0)>
			toastr["error"]("${actionErrors}");
		</#if> 
		<#if (actionMessages?? & actionMessages?size>0)>
			toastr["info"]("${actionMessages}");
		</#if>
		</script>
</body>
</html>
