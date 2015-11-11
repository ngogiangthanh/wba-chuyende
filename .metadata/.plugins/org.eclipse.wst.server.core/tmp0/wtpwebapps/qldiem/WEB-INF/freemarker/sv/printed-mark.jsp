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
        <style type="text/css" media="print">
        @media print
			{    
			    #toast-container, .no-print *
			    {
			        display: none !important;
			    }
			}
            @page 
            {
                size: auto;   /* auto is the current printer page size */
                margin: 0mm;  /* this affects the margin in the printer settings */
            }

            body 
            {
                background-color:#fff; 
                margin: 25mm;  /* the margin on the content before printing */
            }
		    table { page-break-inside:avoid; }
		    tr    { page-break-inside:avoid; page-break-after:auto }
		    thead { display:table-header-group }
		    tfoot { display:table-footer-group }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="row">
                <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
                    <div class="row">
                        <!-- BEGIN CONTENT -->
						<table class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
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
                                     <p><strong>BẢNG ĐIỂM </strong><strong>ĐẠI HỌC</strong></p>
                                </td>
                            </tr>
						</table>
                        <table class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-left">
                            <tbody>
                                <#list information.entrySet() as entry>  
							<#switch entry.key>
							 <#case "1_MSSV">
							    <tr>
                                    <td>
                                        Mã số sinh viên:&nbsp;<strong>${entry.value}</strong>
                                    </td>
							    <#break>
							  <#case "2_HO_TEN">
                                    <td>
                                        Cấp cho:&nbsp;<strong>${entry.value}</strong>
                                    </td>
                                </tr>
							    <#break>
							  <#case "4_NGAY_SINH">
                                <tr>
                                    <td>
                                        Ngày sinh:&nbsp;<strong>${entry.value}</strong>
                                    </td>
							    <#break>
							  <#case "5_LOP">
                                    <td>
                                        Lớp:&nbsp;<strong>${entry.value}</strong>
                                    </td>
                                </tr>
							    <#break>	
							  <#case "6_TEN_LOP">
                                <tr>
                                    <td>
                                        Tên lớp:&nbsp;<strong>${entry.value}</strong>
                                    </td>
							    <#break>	
							  <#case "7_CHUYEN_NGANH">
                                    <td>
                                        Ngành:&nbsp;<strong>${entry.value}</strong>
                                    </td>
                                </tr>
							    <#break>	
							  <#case "8_KHOA">
                                <tr>
                                    <td colspan="2">
                                        Khoa:&nbsp;<strong>${entry.value}</strong>
                                    </td>
                                </tr>
							    <#break>								    						    						    						    
							</#switch>
						     </#list>
                            </tbody>
                        </table>
                        <#if dsDiemHP?has_content>
                        <#list dsDiemHP.entrySet() as hknk_ds_hocPhan>  
						<#assign tstcdkhk = 0 >
                        <#assign tstchk = 0 >
                        <#assign tdtbHK = 0 >
                        <#assign tstctlhk = 0 >
                        <table class="table table-bordered text-center">
                            <tr><td colspan="7" class="well">Năm học:&nbsp;${hknk_ds_hocPhan.key.nk}&nbsp;-&nbsp;Học kỳ:&nbsp;${hknk_ds_hocPhan.key.hk}</td></tr>
                            <tr>
                                <th class="text-center info">STT</th>
                                <th class="text-center info">Mã môn học</th>
                                <th class="text-center info">Tên môn học</th>
                                <th class="text-center info">Tín chỉ</th>
                                <th class="text-center info">Điểm chữ</th>
                                <th class="text-center info">Điểm số</th>
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
                            <#if hocPhan.tichLuyDiem == "1">
                            <#assign tdtbHK = tdtbHK + hocPhan.tichDiem >
                            <#assign tstchk = tstchk + hocPhan.soTC >
                            </#if>
                            </#list>
                            <#else>
                            <tr>
                                <td colspan="7">
                                    Không có học phần nào.
                                </td>
                            </tr>
                            </#if>
                            <#if tstchk == 0>
                            <#assign tstchk = 1 >
                            </#if>
                        </table>
                        <table class="col-sm-12 col-xs-12 col-md-12 col-lg-12 pull-right">
                        	<tr>
                        		<td>
                        			Tổng số tín chỉ đăng ký:&nbsp;${tstcdkhk}
                        		</td>
                        		<td>
                        			Điểm trung bình học kỳ:&nbsp;${(tdtbHK/tstchk)?string("0.00")}
                        		</td>
                        	</tr>
                        		<td>
                        			Tổng số tín chỉ tích lũy học kỳ:&nbsp;${tstctlhk}
                        		</td>
                        		<td>
                        			Điểm trung bình tích lũy:&nbsp;${hknk_ds_hocPhan.key.tbctl?string("0.00")}
                        		</td>
                        	<tr>
                        	</tr>
                        	<tr>
                        		<td colspan="2">
                        			Tổng số tín chỉ tích lũy:&nbsp;${hknk_ds_hocPhan.key.tstctl}
                        		</td>
                        	</tr>
                        </table>
                        </#list>
                        </#if>
                        <br/>
                        <br/>
                        <p>Ghi chú: Từ học kỳ 1 năm 2007-2008, trường Đại học Cần Thơ sử dụng thang điểm 4. Kết quả học tập của sinh viên được phân loại như sau:</p>
                        <ul>
                            <li>Loại Xuất sắc: từ 3.6 đến 4.00</li>
                            <li>Loại Giỏi: từ 3.2 đến 3.59</li>
                            <li>Loại Khá: từ 2.5 đến 3.19</li>
                            <li>Loại Trung bình: từ 2.00 đến 2.49</li>
                        </ul>
                        <div class="col-sm-12 col-xs-12 col-md-12 col-lg-12 text-center">
                        <#assign aDateTime = .now>
	                        <p class="pull-right">
	                        Cần Thơ, ${aDateTime?string["dd/MM/yyyy"]}<br/>
	                        <strong>Người in</strong><br/><br/><br/><br/><br/>
	                        <em>(Ký và ghi rõ họ tên)</em>
	                        </p>
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
                                        			  "timeOut": 5000,
                                        			  "extendedTimeOut": 0,
                                        			  "showEasing": "swing",
                                        			  "hideEasing": "linear",
                                        			  "showMethod": "fadeIn",
                                        			  "hideMethod": "fadeOut",
                                        			  "tapToDismiss": false
                                        			}
                                            $(window).on('scroll', function () {
                                            	toastr["info"]("Bạn có muốn in trang này?<br /><br /><button type='button' class='btn clear glyphicon glyphicon-print' onclick='window.print();'> In</button>", "Xác nhận in");

                                            });
                                           

                                        });
            </script>
    </body>
</html>