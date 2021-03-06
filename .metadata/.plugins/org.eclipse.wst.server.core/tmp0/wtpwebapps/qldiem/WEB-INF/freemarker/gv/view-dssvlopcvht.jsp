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
							<i class="glyphicon glyphicon-th-list"></i>&nbsp;Xem các lớp học cố vấn
						</div>
						<div class="panel-body">
							<a href="gv-lopcv.html" class="btn btn-default"/>Quay lại</a>&nbsp;
	                        <div class="clearfix">&nbsp;</div>
							<#if dsSVLopCV?? >
								<div class="table-responsive"> 
								<table class="table table-bordered text-center">
									<thead>
								<tr><td colspan="6" class="well">Danh sách sinh viên lớp - ${ten_lop}</td></tr>
									<tr>
										<th class="text-center info">STT</th>
										<th class="text-center info">MSSV</th>
										<th class="text-center info">Họ tên</th>
										<th class="text-center info">Năm sinh</th>
										<th class="text-center info">Giới tính</th>
										<th class="text-center info">Thao tác</th>
									</tr>
									</thead>
									<tbody>
								<#list dsSVLopCV as sv>
									<tr>
										<td>${sv.stt}</td>
										<td id="${sv.mssv}_mssv">${sv.mssv}</td>
										<td id="${sv.mssv}_ho_ten">${sv.ho_ten}</td>
										<td id="${sv.mssv}_ngay_sinh">${sv.ngay_sinh?string["dd/MM/yyyy"]}</td>
										<td id="${sv.mssv}_gioi_tinh">${sv.gioi_tinh}</td>
										<td><a  href="#" data-toggle="modal" data-target="#xemTTSV" onclick="setInfor2Form('${sv.id_sv}','${sv.ho_ten}','${sv.mssv}','${sv.gioi_tinh}', $('#${sv.mssv}_ngay_sinh').text());"><i class="glyphicon glyphicon-plus"></i>&nbsp;Xem</a></td>
									</tr>
								</#list>
									</tbody>
								</table>
								</div>
						</#if>
						</div>
						</div>
					<!-- END CONTENT -->
					
					<!-- Bắt đầu nội dung modal xem thông tin sinh viên -->
					<div class="modal fade" id="xemTTSV" tabindex="-1" role="dialog"
						aria-labelledby="myModalLabel">
						<div class="modal-dialog" role="document">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal"
										aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
									<h4 class="modal-title" id="myModalLabel">Thông tin chi
										tiết sinh viên</h4>
								</div>
								<div class="modal-body form-horizontal" role="form">
									<ul class="list-group" id="tt_cn_sv">
										<li class="list-group-item mssv">MSSV:</li>
										<li class="list-group-item ho_ten">Họ tên:</li>
										<li class="list-group-item gioi_tinh">Giới tính:</li>
										<li class="list-group-item ngay_sinh">Năm sinh:</li>
									</ul>
									<input type="hidden" value="" name="id_sv_modal"
										id="id_sv_modal" />
									<div class="alert alert-success text-center" role="alert">
										Năm học:&nbsp; <select name="nk" id="id_nk"> <#list
											hknk.entrySet() as entry>
											<option value="${entry.key}">${entry.key}</option> </#list>
											<option value="0">Tất cả</option>
										</select> &nbsp;Học kỳ&nbsp; <select name="hk" id="id_hk">
											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">Hè</option>
											<option value="0">Tất cả</option>
										</select>&nbsp; <input type="button" value="Liệt kê"
											class="btn btn-primary" id="btn_lk_tt_hk_nk" />
									</div>
									<div id="content_tt_ht"></div>
								</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-default"
										data-dismiss="modal">Đóng</button>
								</div>
							</div>
						</div>
					</div>
					<!-- Kết thúc nội dung modal xem thông tin sinh viên -->
					
					
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
						//Xử lý gửi nhận xem tt chi tiết sinh viên
						
						$('#btn_lk_tt_hk_nk').click(function() {
							var formData = new FormData();
							formData.append('hk', $("#id_hk").val());
							formData.append('nk', $("#id_nk").val());
							formData.append('id_sv',$("input[name=id_sv_modal]").val());
							$.ajax({
					                url: "cvht-xemctsv.html",
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
							  			$("#content_tt_ht").empty();
							  			$.each(data.dsTTSV, function(key, value) {
							  				var ul = document.createElement("ul");
							  				ul.className = "list-group";
											var hk_nk = "<li class='list-group-item text-center'>"+key+"</li>";
											var tstcdk = "<li class='list-group-item list-group-item-success'>Tổng số tín chỉ đăng ký:&nbsp;<span class='badge'>"+
											value["tstcdk"]+"</span></li>";
											var dtbhk = "<li class='list-group-item list-group-item-info'>Điểm trung bình học kỳ:&nbsp;<span class='badge'>"+
											value["dtbhk"].toFixed(2)+"</span></li>";
											var tstctlhk = "<li class='list-group-item list-group-item-success'>Tổng số tín chỉ tích lũy học kỳ:&nbsp;<span class='badge'>"+
											value["tstctlhk"]+"</span></li>";
											var dtbtl = "<li class='list-group-item list-group-item-info'>Điểm trung bình tích lũy:&nbsp;<span class='badge'>"+
											value["dtbtl"].toFixed(2)+"</span></li>";
											var tstctl = "<li class='list-group-item list-group-item-success'>Tổng số tín chỉ tích lũy:&nbsp;<span class='badge'>"+
											value["tstctl"]+"</span></li>";
											ul.innerHTML =  hk_nk + " " +tstcdk + " " + dtbhk + " "+ tstctlhk + " "+ dtbtl + " "+ tstctl;
							  				$("#content_tt_ht").append(ul);
							  				$("#content_tt_ht").hide();
							  				$("#content_tt_ht").show("slow");
							  			});
					            });
							
								});
								
						//Kết thúc xử lý gửi nhận xem tt chi tiết sinh viên
					});
		function setInfor2Form(id_sv, ho_ten, mssv,  gioi_tinh, ngay_sinh){
			 $("#tt_cn_sv").find(".mssv").text("MSSV: "+mssv);
			 $("#tt_cn_sv").find(".ho_ten").text("Họ tên: "+ho_ten);
			 $("#tt_cn_sv").find(".gioi_tinh").text("Giới tính: "+gioi_tinh);
			 $("#tt_cn_sv").find(".ngay_sinh").text("Ngày sinh: "+ngay_sinh);
		     $("input[name=id_sv_modal]").val(id_sv);
			 $("#content_tt_ht").empty();
			
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
