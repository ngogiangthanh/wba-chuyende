<!DOCTYPE html>
<html lang="vi" moznomarginboxes mozdisallowselectionprint>
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
        <style type="text/css" media="print">
        	@media print
			{    
			    #toast-container, .no-print *
			    {
			        display: none !important;
			    }
			    
	            body 
	            {
	                background-color:#fff; 
	                margin-top: 0mm; 
	                margin-bottom: 0mm;
	            }
			    .page-break, table {page-break-inside:avoid;}
			    tr    { page-break-inside:avoid; page-break-after:avoid;}
			    thead { display:table-header-group; }
			    tfoot { display:table-footer-group; 
				  		margin-top: 25mm;}
			    
			    @page {
			  			size: A4;
			            margin: 2cm;  /* this affects the margin in the printer settings */
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
    </head>
    <body>
        <div class="container">
            <div class="row">
                <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
                    <div class="row">
                        <!-- BEGIN CONTENT -->
						<table class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right text-center">
							<tr>
								<td>
									BỘ GIÁO DỤC VÀ ĐÀO TẠO<br/>
                                    <strong>TRƯỜNG ĐẠI HỌC CẦN THƠ</strong>
								</td>
								<td> 
									<strong>CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</strong></br>
									<strong>Độc lập - Tự do - Hạnh phúc</strong>&nbsp;
								</td>
							</tr>
                            <tr>
                                <td>
                                    <p><strong>Số......</strong></p>
                                </td>
                                <td>
                                     <p><h4><strong>BẢNG GHI ĐIỂM THI HỌC KỲ</strong></h4></p>
                                </td>
                            </tr>
						</table>
                        <div class="clearfix">&nbsp;</div>
                        <#if sv_print_mark??>
                        <table class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
                            <tbody>
							    <tr>
                                    <td>
                                        Mã số sinh viên:&nbsp;<strong>${sv_print_mark.mssv}</strong>
                                    </td>
                                    <td>
                                        Cấp cho:&nbsp;<strong>${sv_print_mark.ho_ten}</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Ngày sinh:&nbsp;<strong>${sv_print_mark.ngay_sinh?string["dd/MM/yyyy"]}</strong>
                                    </td>
                                    <td>
                                        Lớp:&nbsp;<strong>${sv_print_mark.lop}</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Tên lớp:&nbsp;<strong>${sv_print_mark.ten_lop}</strong>
                                    </td>
                                    <td>
                                        Ngành:&nbsp;<strong>${sv_print_mark.chuyen_nganh}</strong>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Khoa:&nbsp;<strong>${sv_print_mark.khoa}</strong>
                                    </td>
                                    <td>
                                        Hệ:&nbsp;<strong>Đại học - Chính quy</strong>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="clearfix">&nbsp;</div>
                        </#if>
                        <#if dsDiemHP?has_content>
                        <#list dsDiemHP.entrySet() as hknk_ds_hocPhan>  
						<#assign tstcdkhk = 0 >
                        <#assign tstchk = 0 >
                        <#assign tdtbHK = 0 >
                        <#assign tstctlhk = 0 >
                        <table class="table table-bordered text-center ">
                            <tr class=""><td colspan="7" class="well">Năm học:&nbsp;${hknk_ds_hocPhan.key.nk}&nbsp;-&nbsp;Học kỳ:&nbsp;${hknk_ds_hocPhan.key.hk}</td></tr>
                            <tr class="">
                                <th class="text-center info">STT</th>
                                <th class="text-center info">Mã MH</th>
                                <th class="text-center info">Tên MH</th>
                                <th class="text-center info">TC</th>
                                <th class="text-center info">Điểm chữ</th>
                                <th class="text-center info">Điểm số</th>
                                <th class="text-center info">N</th>
                            </tr>
                            <#assign listHocPhan = hknk_ds_hocPhan.value>
                            <#if listHocPhan?has_content>
                            <#list listHocPhan as hocPhan>  
                            <tr class="">
                                <td>${hocPhan.stt}</td>
                                <td>${hocPhan.maMH}</td>
                                <td>${hocPhan.tenHP}</td>
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
										<#if hocPhan.tichLuyDiem == "1">
										</#if>
                            </#list>
                            <#else>
                            <tr class="">
                                <td colspan="7">
                                    Không có học phần nào.
                                </td>
                            </tr>
                            </#if>
                            <#if tstchk == 0>
                            <#assign tstchk = 1 >
                            </#if>
                        </table>
                        <table class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right ">
                        	<tr class="">
                        		<td>
                        			&nbsp;&nbsp;-&nbsp;Tổng số tín chỉ đăng ký:&nbsp;${tstcdkhk}
                        		</td>
                        		<td>
                        			&nbsp;&nbsp;-&nbsp;Điểm trung bình học kỳ:&nbsp;${(tdtbHK/tstchk)?string("0.00")}
                        		</td>
                        	</tr>
                        	<tr class="">
                        		<td>
                        			&nbsp;&nbsp;-&nbsp;Tổng số tín chỉ tích lũy học kỳ:&nbsp;${tstctlhk}
                        		</td>
                        		<td>
                        			&nbsp;&nbsp;-&nbsp;Điểm trung bình tích lũy:&nbsp;${hknk_ds_hocPhan.key.tbctl?string("0.00")}
                        		</td>
                        	</tr>
                        	<tr class="">
                        		<td colspan="2">
                        			&nbsp;&nbsp;-&nbsp;Tổng số tín chỉ tích lũy:&nbsp;${hknk_ds_hocPhan.key.tstctl}
                        		</td>
                        	</tr>
                        </table>
                        <div class="clearfix">&nbsp;</div>
                        </#list>
                        </#if>
                        <table class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right ">
                        	<tr class="">
                        		<td colspan="2">
                        		<p><em>*&nbsp;<u>Ghi chú:</u></em> Từ học kỳ 1 năm 2007-2008, trường Đại học Cần Thơ sử dụng thang điểm 4. Kết quả học tập của sinh viên được phân loại như sau:</p>
                        		</td>
                        	</tr>
                        	<tr class="">
                        		<td>&nbsp;&nbsp;-&nbsp;Loại Xuất sắc: từ 3.6 đến 4.00</td>
                        		<td>&nbsp;&nbsp;-&nbsp;Loại Giỏi: từ 3.2 đến 3.59</td>
                        	</tr>
                        	<tr class="">
                        		<td>&nbsp;&nbsp;-&nbsp;Loại Khá: từ 2.5 đến 3.19</td>
                        		<td>&nbsp;&nbsp;-&nbsp;Loại Trung bình: từ 2.00 đến 2.49</td>
                        	</tr>
                        </table>
                        <div class="clearfix">&nbsp;</div>
                        <div class="clearfix">&nbsp;</div>
                        <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center page-break">
                        <#assign aDateTime = .now>
	                        <p class="pull-right">
	                        Cần Thơ,&nbsp;ngày&nbsp;${aDateTime?string["dd"]}&nbsp;tháng&nbsp;${aDateTime?string["MM"]}&nbsp;năm&nbsp;${aDateTime?string["yyyy"]}<br/>
	                        <strong>TL. Hiệu trưởng</strong><br/>
	                        <strong>TRƯỞNG PHÒNG ĐÀO TẠO</strong><br/><br/><br/><br/>
	                        </p>
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
        	<script type="text/javascript" src="public/js/toastr.js"></script>
        	<script type="text/javascript" src="public/js/jspdf.js"></script>
        	<script type="text/javascript" src="public/js/jspdf.plugin.from_html.js"></script>
        	<script type="text/javascript" src="public/js/jspdf.plugin.split_text_to_size.js"></script>
        	<script type="text/javascript" src="public/js/jspdf.plugin.standard_fonts_metrics.js"></script>
            <script type="text/javascript">
                                        $(document).ready(function () {
                                            $('#sidebar .panel-heading').click(
                                                    function () {
                                                        $('#sidebar .list-group').toggleClass(
                                                                'hidden-xs');
                                                        $('#sidebar .panel-heading b').toggleClass(
                                                                'glyphicon-plus-sign').toggleClass(
                                                                'glyphicon-minus-sign');
                                                    });
                                        	toastr.options = {
                                        			  "closeButton": false,
                                        			  "debug": false,
                                        			  "newestOnTop": false,
                                        			  "progressBar": false,
                                        			  "positionClass": "toast-bottom-right",
                                        			  "preventDuplicates": true,
                                        			  "onclick": null,
                                        			  "showDuration": "300",
                                        			  "hideDuration": "1000",
                                        			  "timeOut": 0,
                                        			  "extendedTimeOut": 0,
                                        			  "showEasing": "swing",
                                        			  "hideEasing": "linear",
                                        			  "showMethod": "fadeIn",
                                        			  "hideMethod": "fadeOut",
                                        			  "tapToDismiss": false
                                        			}
                                            $(window).on('scroll', function () {
                                            	toastr["info"]("Bạn có muốn in trang này?<br /><br /><button type='button' class='btn btn-default glyphicon glyphicon-print' onclick='window.print();'>&nbsp;In</button>", "Xin chào!");

                                            });
                                        });
            </script>
    </body>
</html>
