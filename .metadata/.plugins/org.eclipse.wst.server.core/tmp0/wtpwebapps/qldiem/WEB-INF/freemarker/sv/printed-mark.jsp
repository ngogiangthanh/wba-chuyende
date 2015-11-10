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
<style type="text/css" media="print">
        @page 
        {
            size: auto;   /* auto is the current printer page size */
            margin: 0mm;  /* this affects the margin in the printer settings */
        }

        body 
        {
            background-color:#fff; 
            margin: 10px;  /* the margin on the content before printing */
       }
    </style>
</head>
<body>
	<div class="container" id="content">
		<div class="row">
			<div class="col-sm-12 col-xs-12 pull-right">
				<div class="row">
					<!-- BEGIN CONTENT -->

					<table>
						<tbody>
							<tr>
								<td>
								<p>BỘ GIÁO DỤC VÀ ĐÀO TẠO</p>
								</td>
								<td>
								<p><strong>CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</strong></p>
								</td>
							</tr>
							<tr>
								<td>
								<p><strong>TRƯỜNG ĐẠI HỌC CẦN THƠ</strong></p>
								<div>
								<hr/></div>
								</td>
								<td>
								<p><strong>Độc lập - Tự do - Hạnh phúc</strong>&nbsp;</p>
								<div>
								<hr/>
								</div>
								</td>
							</tr>
						</tbody>
					</table>
					<table>
						<tbody>
							<tr>
								<td>
								<p><strong>Số......</strong></p>
								</td>
								<td>
								<p><strong>BẢNG ĐIỂM </strong><strong>ĐẠI HỌC</strong></p>
								</td>
							</tr>
							<tr>
								<td>
								<p>Cấp cho:</p>
								</td>
								<td>
								<p><strong>Value</strong>&nbsp;</p>
								</td>
							</tr>
							<tr>
								<td>
								<p>Mã số sinh viên:</p>
								</td>
								<td>
								<p><strong>Value</strong></p>
								</td>
							</tr>
							<tr>
								<td>
								<p>Ngày sinh:</p>
								</td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>
								<p>Nơi sinh:</p>
								</td>
								<td>
								<p>&nbsp;</p>
								</td>
							</tr>
							<tr>
								<td>
								<p>Khóa:</p>
								</td>
								<td>
								<p><strong></strong>&nbsp;</p>
								</td>
							</tr>
							<tr>
								<td>
								<p>Lớp: </p>
								</td>
								<td>
								<p><strong>Value</strong></p>
								</td>
							</tr>
							<tr>
								<td>
								<p>Ngành: </p>
								</td>
								<td>
								<p><strong>Value</strong></p>
								</td>
							</tr>
							<tr>
								<td>
								<p>Khoa: </p>
								</td>
								<td>
								<p><strong>Value</strong></p>
								</td>
							</tr>
						</tbody>
					</table>
					<br/>
					<br/>
					<#if dsDiemHP?has_content>
							<#list dsDiemHP.entrySet() as hknk_ds_hocPhan>  
							<#assign tsTCDK = 0 >
							<#assign tstchk = 0 >
							<#assign tdtbHK = 0 >
							<#assign tstctlhk = 0 >
							<table class="table table-bordered text-center">
							<tr><td colspan="10" class="well">Năm học:&nbsp;${hknk_ds_hocPhan.key.nk}&nbsp;-&nbsp;Học kỳ:&nbsp;${hknk_ds_hocPhan.key.hk}</td></tr>
								<tr>
									<th class="text-center info">STT</th>
									<th class="text-center info">Mã học phần</th>
									<th class="text-center info">Tên học phần</th>
									<th class="text-center info">Điều kiện</th>
									<th class="text-center info">Nhóm</th>
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
							<ul>
								<li>Tổng số tín chỉ đăng ký:&nbsp;${tsTCDK}</li>
								<li>Điểm trung bình học kỳ:&nbsp;${(tdtbHK/tstchk)?string("0.00")}</li>
								<li>Tổng số tín chỉ tích lũy học kỳ:&nbsp;${tstctlhk}</li>
								<li>Điểm trung bình tích lũy:&nbsp;${hknk_ds_hocPhan.key.tbctl?string("0.00")}</li>
								<li>Tổng số tín chỉ tích lũy:&nbsp;${hknk_ds_hocPhan.key.tstctl}</li>
							</ul>
							</#list>
							</#if>
					<br/>
					<br/>
					<p>Ghi ch&uacute;: Từ học kỳ 1 năm 2007-2008, trường Đại học Cần Thơ sử dụng thang điểm 4. Kết quả học tập của sinh vi&ecirc;n được ph&acirc;n loại như sau:</p>
					<ul>
						<li>Loại Xuất sắc: từ 3.6 đến 4.00</li>
						<li>Loại Giỏi: từ 3.2 đến 3.59</li>
						<li>Loại Kh&aacute;: từ 2.5 đến 3.19</li>
						<li>Loại Trung b&igrave;nh: từ 2.00 đến 2.49</li>
					</ul>
					<p style="margin-left: 252pt; text-align: center;">Cần Thơ, ng&agrave;y&hellip;th&aacute;ng&hellip;năm&hellip;</p>
					<p style="margin-left: 252pt; text-align: center;"><strong>Người in</strong></p>
					<p style="margin-left: 252pt; text-align: center;"><em>(K&yacute; v&agrave; ghi r&otilde; họ t&ecirc;n)</em></p>
					<button id="cmd" class="glyphicon glyphicon-print" onclick="window.print();">In</button>
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
					});
		</script>
</body>
</html>
