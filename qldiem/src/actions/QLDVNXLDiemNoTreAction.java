package actions;

import java.util.ArrayList;
import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import connection.Connect;
import models.muc_chuyen_doi;
import models.sv_tt_diem_no;
import models.thang_diem;

public class QLDVNXLDiemNoTreAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNAction qlnAction = null;
	private ArrayList<sv_tt_diem_no> dsSVTreTT = null;
	private String tenKhoa = null;
	private String diem_chu;
	private String diem_4;
 
	public QLDVNXLDiemNoTreAction() {
	}
	
	public String execute(){
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		if(!this.qlnAction.Prefix_Check("Thanh toán trường hợp trễ bổ sung điểm nợ",this.session))
			return ERROR;

		this.xlDSSVTreTT(this.session);
		return SUCCESS;
	}
	
	public void xlDSSVTreTT(Map<String, Object> session){
		// Kiểm tra xem nếu session thang_diem đã có thì khởi tạo lại và ngược
		// lại
		if (!session.containsKey("thang_diem")) {
			System.out.println("Gán thang điểm lần đầu");
			ThangDiemAction thangDiemAction = new ThangDiemAction();
			thangDiemAction.assignTDValues(this.session);
		}

		thang_diem thang_diem_qd = (thang_diem) session.get("thang_diem");
		ArrayList<muc_chuyen_doi> ds_mcd = thang_diem_qd.getDs_muc_chuyen_doi();
		int size_ds = ds_mcd.size();

		for (int i = 0; i < size_ds; i++) {
			if (0 >= ds_mcd.get(i).getDiem10()) {
				setDiem_4(ds_mcd.get(i).getDiem4() + "");
				setDiem_chu(ds_mcd.get(i).getDiemChu() + "");
				break;
			}
		}
		
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_dssv_thanh_toan_tre(?);";
		String procedure_xl = "call update_gv_diem_hp(?,?,?,?,?,?);";
		CallableStatement pstmt = null;
		CallableStatement pstmt_xl = null;
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			//
			pstmt.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			setTenKhoa(infor_user.get("6_KHOA"));
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			// Duyệt kết quả ds sv
			this.dsSVTreTT = new ArrayList<sv_tt_diem_no>();
			int stt = 1;
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					pstmt_xl = (CallableStatement) this.conn.getConn().prepareCall(procedure_xl);
						// Gán tham số id_hp
					pstmt_xl.setInt(1, rs.getInt("ID_HP"));
						// Gán tham số id_sv
					pstmt_xl.setInt(2, rs.getInt("ID"));
						// Gán tham số diem_10
					pstmt_xl.setFloat(3, 0);
						// Gán tham số diem_chu
					pstmt_xl.setString(4, getDiem_chu());
						// Gán tham số diem_4
					pstmt_xl.setFloat(5, Float.parseFloat(getDiem_4()));
						// Gán tham số cai_thien
					pstmt_xl.setInt(6, rs.getInt("CAI_THIEN"));
						// Thực thi procedure
					pstmt_xl.execute();
				}
			}
			// Đóng kết nối
			pstmt_xl.close();
			pstmt.close();
			rs.close();
			this.conn.Close();
		} catch (Exception e) {
			addActionError("Xử lý sinh viên bổ sung điểm nợ trễ thất bại!");
			e.printStackTrace();
		}
		addActionMessage("Xử lý sinh viên bổ sung điểm nợ trễ hoàn tất!");
	}
	
	public String getTenKhoa() {
		return tenKhoa;
	}
	
	public ArrayList<sv_tt_diem_no> getDsSVTreTT() {
		return dsSVTreTT;
	}
	
	public String getDiem_4() {
		return diem_4;
	}
	
	public String getDiem_chu() {
		return diem_chu;
	}
	
	public void setDsSVTreTT(ArrayList<sv_tt_diem_no> dsSVTreTT) {
		this.dsSVTreTT = dsSVTreTT;
	}
	
	public void setTenKhoa(String tenKhoa) {
		this.tenKhoa = tenKhoa;
	}
	
	public void setDiem_4(String diem_4) {
		this.diem_4 = diem_4;
	}
	
	public void setDiem_chu(String diem_chu) {
		this.diem_chu = diem_chu;
	}
}
