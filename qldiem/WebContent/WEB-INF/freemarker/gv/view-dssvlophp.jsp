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
							<i class="glyphicon glyphicon-th-list"></i>&nbsp;Xem các lớp học phần giảng dạy
						</div>
						<div class="panel-body">
						<#if nhapDiem>
						<a href="#" class="btn btn-primary" data-toggle="modal" data-target="#upFileModal"/>Tệp điểm excel</a>
						</#if>
						<a href="gv-lophp.html" class="btn btn-default"/>Quay lại</a>&nbsp;
                        <div class="clearfix">&nbsp;</div>
						<#if dsSVHP?? >
								<div class="table-responsive"> 
								<table class="table table-bordered text-center" id="dssv_hp">
								<thead>
								<tr><td colspan="7" class="well">Danh sách sinh viên học phần: ${ma_hp} - ${ten_mh} - Năm học:&nbsp;${nk}&nbsp;-&nbsp;Học kỳ:&nbsp;${hk}</td></tr>
									<tr>
										<th class="text-center info">STT</th>
										<th class="text-center info">MSSV</th>
										<th class="text-center info">Họ tên</th>
										<th class="text-center info">Điểm chữ</th>
										<th class="text-center info">Điểm 10</th>
										<th class="text-center info">Điểm 4</th>
										<th class="text-center info">Thao tác</th>
									</tr>
									</thead>
									<tbody>
								<#list dsSVHP as sv>
									<tr>
										<td>${sv.stt}</td>
										<td id="${sv.mssv}_mssv" class="mssv">${sv.mssv}</td>
										<td id="${sv.mssv}_ho_ten">${sv.ho_ten}</td>
										<td id="${sv.mssv}_diem_chu">${sv.diem_chu}</td>
										<td id="${sv.mssv}_diem_10">${sv.diem_10?string("0.00")}</td>
										<td id="${sv.mssv}_diem_4">${sv.diem_4?string("0.00")}</td>
										<td><#if nhapDiem>
												<input type="hidden" value="${sv.id_sv}" name="id_sv_td" id="${sv.mssv}_id_sv"/>
												<input type="hidden" value="${sv.cai_thien}" name="cai_thien_td" id="${sv.mssv}_cai_thien"/>
												<a href="#" data-toggle="modal" data-target="#nhapDiemModal" onclick="setInfor2Form('${sv.ho_ten}','${sv.mssv}', '${sv.id_sv}',$('#${sv.mssv}_diem_10').text(), '${sv.cai_thien}');"><i class="glyphicon glyphicon-plus"></i>&nbsp;Nhập điểm</a>
											<#else>
											<i class="glyphicon glyphicon-time"></i>&nbsp;
											</#if>
											</td>
									</tr>
								</#list>
									</tbody>
								</table>
								</div>
						</#if>
						</div>
						<!-- Bắt đầu nội dung modal nhập điểm -->
					<#if nhapDiem>	
					<div class="modal fade" id="nhapDiemModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
					  <div class="modal-dialog" role="document">
					    <div class="modal-content">
					      <div class="modal-header">
					        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					        <h4 class="modal-title" id="myModalLabel">Khung nhập điểm</h4>
					      </div>
					      <div class="modal-body form-horizontal" role="form">
					            <input name="id_hp" type="hidden" value="${id_hp}"/>
					            <input name="id_sv" type="hidden" value=""/>
					            <input name="cai_thien" type="hidden" value=""/>
					            <div class="form-group">
					                <label for="title" class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
                                        <span class="glyphicon glyphicon-user text-info"></span>&nbsp;MSSV:</label>
					                <div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
                                        <input type="text" value="" id="mssv" name="mssv" class="form-control" readonly="readonly"/>
					                </div>
					            </div>
					            <div class="form-group">
					                <label for="title" class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
                                        <span class="glyphicon glyphicon-user text-info"></span>&nbsp;Họ tên:</label>
					                <div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
                                        <input type="text" value="" id="ho_ten" name="ho_ten" class="form-control" readonly="readonly"/>
					                </div>
					            </div>
					         
					            <div class="form-group">
					                <label for="title" class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
                                        <span class="glyphicon glyphicon-tags"></span>&nbsp;&nbsp;Điểm 10:</label>
					                <div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
                                        <input type="number" value="" id="diem_10" name="diem_10" class="form-control" min="0" max="10" step="0.50"/>
					                </div>
					            </div>
						</div>
						      <div class="modal-footer">
					            <button type="button" class="btn btn-success" id="btn_luu">Lưu</button>
					            <button type="button" class="btn btn-info" id="btn_next">Kế tiếp</button>
						        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
						      </div>
						    </div>
						  </div>
						</div>
						<!-- Kết thúc nội dung modal nhập điểm -->
						<!-- Bắt đầu nội dung modal úp file -->
						<div class="modal fade" id="upFileModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
					  <div class="modal-dialog" role="document">
					    <div class="modal-content">
					      <div class="modal-header">
					        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
					        <h4 class="modal-title" id="myModalLabel">Khung úp tệp excel</h4>
					      </div>
					      <div class="modal-body form-horizontal" role="form">
					            <div class="form-group" id="content_file">
					                <label for="title" class="col-sm-3 col-xs-3 col-md-3 col-lg-3 control-label">
                                        <span class="glyphicon glyphicon-floppy-open"></span>&nbsp;Chọn tệp:</label>
					                <div class="col-sm-9 col-xs-9 col-md-9 col-lg-9">
                                        <input type="file" id="file_excel" name="file_excel" class="form-control" accept="application/vnd.ms-excel"/>
					                </div>
					            </div>
					            
					            <div class="form-group" id="dssv_div">
									<div class="table-responsive">
										<table class="table table-bordered text-center" id="dssv_ul">
										<thead>
											<tr>
												<th class="text-center info">STT</th>
												<th class="text-center info">MSSV</th>
												<th class="text-center info">Họ tên</th>
												<th class="text-center info">Điểm 10</th>
												<th class="text-center info">Xóa</th>
											</tr>
											</thead>
											<tbody>
											</tbody>
										</table>
									</div>
					            </div>
						</div>
						      <div class="modal-footer">
					            <button type="button" class="btn btn-info" id="btn_insert">Lưu vào CSDL</button>
					            <button type="button" class="btn btn-success" id="btn_upload">Tải lên</button>
						        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
						      </div>
						    </div>
						  </div>
						</div>
						<!-- Kết thúc nội dung modal úp file-->
						</#if>
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
								  			var mssv = $("input[name=mssv]").val();
								  			$("#"+mssv+"_diem_chu").text(jsonResponse.diem_chu);
								  			$("#"+mssv+"_diem_10").text(parseFloat(jsonResponse.diem_10).toFixed(2));
								  			$("#"+mssv+"_diem_4").text(parseFloat(jsonResponse.diem_4).toFixed(2));
							    	  }
							      });
								} else{
						  			toastr["error"]("Điểm 10 nhập vào không hợp lệ! Vui lòng nhập lại!");
						  			$("input[name=diem_10]").focus()
								}
							
						});
						
						var count = 0;
						$("#btn_next").click(function(){
							$('#dssv_hp > tbody  > tr').each(function() {
					  			var mssv = $("input[name=mssv]").val();
								var current_mssv = $(this).find("td.mssv").text();
								if(mssv === current_mssv){
									count++;
									return;
								}
								
								if(count === 1 & current_mssv.length > 0){
						       		$("input[name=ho_ten]").val($("#"+current_mssv+"_ho_ten").text());
							        $("input[name=mssv]").val($("#"+current_mssv+"_mssv").text());
							        $("input[name=id_sv]").val($("#"+current_mssv+"_id_sv").val());
							        $("input[name=diem_10]").val($("#"+current_mssv+"_diem_10").text());
							        $("input[name=cai_thien]").val($("#"+current_mssv+"_cai_thien").val());
									count = 0;
									
									if(isEndTable(current_mssv))
										$("#btn_next").hide("slow");
									
									return false;
								}
							});
						});
						//Kết thúc xử lý nhập điểm
						
						//Xử lý úp file
						$("#content_file").show("slow");
						$("#btn_upload").show("slow");
						$("#dssv_div").hide("slow");
						$("#btn_insert").hide("slow");
						
						$("#btn_upload").click(function(){
							var file = $('input[name=file_excel]').get(0).files[0];
							if($("input[name=file_excel]").val() === ''){
					  			toastr["error"]("Vui lòng chọn tệp excel cần tải lên!");
						        $("input[name=file_excel]").focus();
						        return false;
						     }
							
							var formData = new FormData();
							formData.append('excelFile', file);
							formData.append('hk', ${hk});
							formData.append('nk', '${nk}');
							formData.append('id_hp', ${id_hp});
							formData.append('id_gv', ${id_gv});
							
							 $.ajax({
					                url: "gv-excelUpload.html",
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
											$("#content_file").hide("slow");
											$("#btn_upload").hide("slow");
											$("#dssv_div").show("slow");
											$("#btn_insert").show("slow");
											var stt = 0;
								  			$.each(data.dsSVHP, function(key, value) {
								  	        	stt++;
								  	        	$('#dssv_ul > tbody:last-child')
								  	        		.append("<tr id="+value["mssv"]+"><td>"+stt+"</td><td class='mssv'>"+value["mssv"]+
								  	        				"</td><td>"+value["ho_ten"]+
								  	        				"</td><td class='diem_10'>"+value["diem_10"]+
								  	        				"</td><td><a href='#' onclick='delete_tr("+"\""+value["mssv"]+"\""+")'>Xóa</a>"+
								  	        				"<input type='hidden' value='"+value["id_sv"]+"' class='class_sv_ul'/>"+
								  	        				"<input type='hidden' value='"+value["cai_thien"]+"' class='class_cai_thien_ul'/></td></tr>").fadeIn("slow");
								  	        });
							    	  }
					            });
						});
						//Kết thúc xử lý úp file
						
						//Bắt đầu xử lý nhập điểm theo file
						$("#btn_insert").click(function(){
							var formData = new FormData();
							var key = 0;
							$('#dssv_ul > tbody  > tr').each(function() {
								formData.append('dsSVHP['+key+'].id_hp', parseInt(${id_hp}));
								formData.append('dsSVHP['+key+'].mssv', $(this).find("td.mssv").text());
								formData.append('dsSVHP['+key+'].id_sv', parseInt($(this).find(".class_sv_ul").val()));
								formData.append('dsSVHP['+key+'].diem_10', parseFloat($(this).find("td.diem_10").text()));
								formData.append('dsSVHP['+key+'].cai_thien', $(this).find(".class_cai_thien_ul").val());
								key++;
							});
								//Gửi đến server insert vào csdl
								 $.ajax({
						                url: "gv-excelInsert.html",
						                type: "POST",
						                dataType: "json",
						                processData: false,
						                traditional: true,
						                contentType: false,
						                cache: false,
						                data: formData
						            }).done(function(data) {
						            	if (data.actionErrors.length > 0) {
								  			toastr["error"](data.actionErrors);
								    	    }
								    	  if(data.actionMessages.length > 0){
									  			toastr["info"](data.actionMessages);
												$("#content_file").show("slow");
												$("#btn_upload").show("slow");
												$("#dssv_div").hide("slow");
												$("#btn_insert").hide("slow");
												$('input[name=file_excel]').val("");
												$('#dssv_ul > tbody > tr').remove();
												$('#upFileModal').modal('hide');

									  			$.each(data.dsSVHP, function(key, value) {
									  				var mssv = value['mssv'];
										  			$("#"+mssv+"_diem_chu").text(value['diem_chu']);
										  			$("#"+mssv+"_diem_10").text(value['diem_10'].toFixed(2));
										  			$("#"+mssv+"_diem_4").text(value['diem_4'].toFixed(2));
								    	  });
								    	  }
						            });
						});
						//Kết thúc xử lý nhập điểm theo file
					});
	
			function isEndTable(mssv){
				var match = false;
				var count = 0;
				$('#dssv_hp > tbody  > tr').each(function() {
					var current_mssv = $(this).find("td.mssv").text();
					if(current_mssv === mssv){
						match = true;
						return;
					}
					
					if(match) count++;
				});
				return (count > 0) ? false : true;
			}
			function setInfor2Form(ho_ten, mssv, id_sv, diem_10, cai_thien){
	       		$("input[name=ho_ten]").val(ho_ten);
		        $("input[name=mssv]").val(mssv);
		        $("input[name=id_sv]").val(id_sv);
		        $("input[name=diem_10]").val(diem_10);
		        $("input[name=cai_thien]").val(cai_thien);
				if(isEndTable(mssv))
					$("#btn_next").hide("slow");
				else
					$("#btn_next").show("slow");
			}
			
			function delete_tr(mssv){
				$("#"+mssv).remove().fadeOut("slow");
				if(isEmptyTable()){
					$("#content_file").show("slow");
					$("#btn_upload").show("slow");
					$("#dssv_div").hide("slow");
					$("#btn_insert").hide("slow");
					$('input[name=file_excel]').val("");
					$('#dssv_ul > tbody > tr').remove();
				}
			}
			
			function isEmptyTable(){
				var tbody = $("#dssv_ul tbody");

				if (tbody.children().length == 0) {
					return true;
				}
				return false;
			}
		</script>
</body>
</html>
