package actions;

import java.util.ArrayList;
import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.sv_bs_diem_no;

public class QLDVNBSDiemNoAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNTKAction qlntkAction = null;
	private QLDVNAction qlnAction = null;
	private ArrayList<sv_bs_diem_no> dsSVCanBS = null;
	private String tenKhoa;

	public QLDVNBSDiemNoAction() {
	}
	
	public String execute(){
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		if(!this.qlnAction.Prefix_Check("Danh sách sinh viên cần bổ sung điểm nợ",this.session))
			return ERROR;
		
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		this.qlntkAction = new QLDVNTKAction();
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.qlntkAction.assignHKNKValues(this.session);
		}
		
		this.assignDSSVCanBS(this.session);
		
		return SUCCESS;
	}
	
	public void assignDSSVCanBS(Map<String, Object> session){
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_dssv_bo_sung(?,?,?);";
		CallableStatement pstmt = null;
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			//
			pstmt.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			pstmt.setInt(2, Integer.parseInt(session.get("current_hk").toString()));
			pstmt.setString(3, session.get("current_nk").toString());
			setTenKhoa(infor_user.get("6_KHOA"));
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			// Duyệt kết quả ds
			this.dsSVCanBS = new ArrayList<sv_bs_diem_no>();
			int stt = 1;
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					sv_bs_diem_no sv = new sv_bs_diem_no();
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
					sv.setCai_thien(rs.getString("CAI_THIEN"));
					//
					this.dsSVCanBS.add(sv);
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
	
	public ArrayList<sv_bs_diem_no> getDsSVCanBS() {
		return dsSVCanBS;
	}
	
	public void setDsSVCanBS(ArrayList<sv_bs_diem_no> dsSVCanBS) {
		this.dsSVCanBS = dsSVCanBS;
	}
	
	public void setTenKhoa(String tenKhoa) {
		this.tenKhoa = tenKhoa;
	}
}
