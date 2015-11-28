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
	private QLDVNAction qlnAction = null;
	private Connect conn;
	private String mssv;
	private sv_qldvn kq_sv;

	public QLDVNXLFindSVAction() {
	}

	public String execute() {
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		if (!this.qlnAction.Prefix_Check("", this.session))
			return ERROR;

		// Gọi procedure lấy thông tin
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_tim_sv(?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			pstmt.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			pstmt.setString(2, getMssv());
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

	public void setKq_sv(sv_qldvn kq_sv) {
		this.kq_sv = kq_sv;
	}

	public void setMssv(String mssv) {
		this.mssv = mssv;
	}
}
