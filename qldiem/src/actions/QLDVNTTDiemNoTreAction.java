package actions;

import java.util.ArrayList;
import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import connection.Connect;
import models.sv_tt_diem_no;

public class QLDVNTTDiemNoTreAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNAction qlnAction = null;
	private ArrayList<sv_tt_diem_no> dsSVTreTT = null;
	private String tenKhoa = null;
 
	public QLDVNTTDiemNoTreAction() {
	}
	
	public String execute(){
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		if(!this.qlnAction.Prefix_Check("Thanh toán trường hợp trễ bổ sung điểm nợ",this.session))
			return ERROR;

		this.assignDSSVTreTT(this.session);
		return SUCCESS;
	}
	
	public void assignDSSVTreTT(Map<String, Object> session){
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_dssv_thanh_toan_tre(?);";
		CallableStatement pstmt = null;
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
					sv_tt_diem_no sv = new sv_tt_diem_no();
					sv.setStt(stt++);
					sv.setId_sv(rs.getInt("ID"));
					sv.setId_hp(rs.getInt("ID_HP"));
					sv.setMssv(rs.getString("MSSV"));
					sv.setHo_ten(rs.getString("HO_TEN"));
					sv.setTen_hp(rs.getString("TEN_MH"));
					sv.setMa_hp(rs.getString("MA_HP"));
					sv.setMa_mh(rs.getString("MA_MH"));
					sv.setSo_tc(rs.getInt("SO_TC"));
					sv.setHk(rs.getInt("HK"));
					sv.setNk(rs.getString("NK"));
					//
					this.dsSVTreTT.add(sv);
				}
			}
			// Đóng kết nối
			pstmt.close();
			rs.close();
			this.conn.Close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getTenKhoa() {
		return tenKhoa;
	}
	
	public ArrayList<sv_tt_diem_no> getDsSVTreTT() {
		return dsSVTreTT;
	}
	
	public void setDsSVTreTT(ArrayList<sv_tt_diem_no> dsSVTreTT) {
		this.dsSVTreTT = dsSVTreTT;
	}
	
	public void setTenKhoa(String tenKhoa) {
		this.tenKhoa = tenKhoa;
	}
}
