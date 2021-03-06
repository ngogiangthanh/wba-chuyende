package actions;

import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.sv_pdt;
import models.sv_qldvn;

public class QLDVNXLFindSVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;
	private QLDVNTKAction qlntkAction = null;
	private QLDVNAction qlnAction = null;
	private Connect conn;
	private String mssv;
	private String ma_hp;
	private sv_qldvn kq_sv;

	public QLDVNXLFindSVAction() {
	}

	public String execute() {
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		if (!this.qlnAction.Prefix_Check("", this.session))
			return ERROR;
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		this.qlntkAction = new QLDVNTKAction();
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.qlntkAction.assignHKNKValues(this.session);
		}

		// Gọi procedure lấy thông tin
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_tim_sv(?,?,?,?,?);";
		CallableStatement pstmt = null;
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			pstmt.setString(1, getMssv());
			pstmt.setString(2, getMa_hp());
			pstmt.setInt(3, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			pstmt.setInt(4, Integer.parseInt(session.get("current_hk").toString()));
			pstmt.setString(5, session.get("current_nk").toString());
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			// Duyệt kết quả
			if (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					this.kq_sv = new sv_qldvn();
					this.kq_sv.setId_sv(rs.getInt("ID"));
					this.kq_sv.setMssv(rs.getString("MSSV"));
					this.kq_sv.setHo_ten(rs.getString("HO_TEN"));
					this.kq_sv.setLop(rs.getString("LOP"));
					this.kq_sv.setTen_lop(rs.getString("TEN_LOP"));
					
					this.kq_sv.setMa_mh(rs.getString("MA_MH"));
					this.kq_sv.setTen_mh(rs.getString("TEN_MH"));
					this.kq_sv.setSo_tc(rs.getInt("SO_TC"));
					this.kq_sv.setDieu_kien(rs.getString("DIEU_KIEN"));
					this.kq_sv.setId_hp(rs.getInt("ID_HP"));
					this.kq_sv.setDiem_chu(rs.getString("DIEM_CHU"));
					this.kq_sv.setDiem_4(rs.getFloat("DIEM_4"));
					this.kq_sv.setDiem_10(rs.getFloat("DIEM_10"));
				}
			}

			// Đóng kết nối
			pstmt.close();
			rs.close();
			this.conn.Close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return SUCCESS;
	}

	public sv_qldvn getKq_sv() {
		return kq_sv;
	}

	public String getMssv() {
		return mssv;
	}
	
	public String getMa_hp() {
		return ma_hp;
	}

	public void setKq_sv(sv_qldvn kq_sv) {
		this.kq_sv = kq_sv;
	}

	public void setMssv(String mssv) {
		this.mssv = mssv;
	}
	
	public void setMa_hp(String ma_hp) {
		this.ma_hp = ma_hp;
	}
}
