package actions;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.muc_chuyen_doi;
import models.thang_diem;

public class ThangDiemAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;

	public ThangDiemAction() {
	}
	
	public void assignTDValues(Map<String, Object> session){
		this.conn = new Connect();
		String procedure = "call get_tt_thang_diem();";
		
		thang_diem thang_diem_qd = new thang_diem();
		
		try {
			ResultSet rs = this.conn.call_procedure(procedure);
			SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
			if(rs.next()){
				Date ngay_ap_dung = formatter.parse(rs.getString("NGAY_AP_DUNG"));
				//Thiết lập ngày áp dụng
				thang_diem_qd.setTd_ap_dung(ngay_ap_dung);
				//Phân tách giá trị đa trị
				String[] cac_bac = rs.getString("THANG_DIEM").split(",");
				int length_cac_bac = cac_bac.length;
				
				for(int i = 0; i < length_cac_bac; i++){
					muc_chuyen_doi mcd = new muc_chuyen_doi();
					String[] cac_muc = cac_bac[i].split("-");
					mcd.setDiemChu(cac_muc[0]);
					mcd.setDiem10(Float.parseFloat(cac_muc[1]));
					System.out.println("diem chu "+cac_muc[0]+"Tich luy tc "+ cac_muc[2]+"| tl diem "+ cac_muc[3]);
					mcd.setTichLuyTC((cac_muc[2].equals("Y")) ? true : false);
					mcd.setTichLuyDiem((cac_muc[3].equals("Y")) ? true : false);
					mcd.setDiem4(Float.parseFloat(cac_muc[4]));
					//Thêm vào quy định thang điểm
					thang_diem_qd.addDs_muc_chuyen_doi(mcd);
				}
			}
			//Đóng kết nối
			rs.close();
			this.conn.Close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		//Thêm vào session
		session.put("thang_diem", thang_diem_qd);
	}
}
