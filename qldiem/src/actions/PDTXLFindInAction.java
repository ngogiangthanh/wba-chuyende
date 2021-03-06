package actions;

import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import connection.Connect;
import models.sv_pdt;

public class PDTXLFindInAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;
	private PDTAction pdtAction = null;
	private Connect conn;
	private String mssv;
	private sv_pdt kq_sv;

	public PDTXLFindInAction() {
	}

	public String execute() {
		this.pdtAction = new PDTAction();
		this.session = ActionContext.getContext().getSession();
		if (!this.pdtAction.Prefix_Check("", this.session))
			return ERROR;

		// Gọi procedure lấy thông tin
		this.conn = new Connect();
		String procedure = "call get_tt_pdt_tim_sv(?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			// Gán tham số mssv
			pstmt.setString(1, getMssv());
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			// Duyệt kết quả
			if (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					this.kq_sv = new sv_pdt();
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

	public String getMssv() {
		return mssv;
	}
	
	public sv_pdt getKq_sv() {
		return kq_sv;
	}
	
	public void setMssv(String mssv) {
		this.mssv = mssv;
	}
	
	public void setKq_sv(sv_pdt kq_sv) {
		this.kq_sv = kq_sv;
	}
}
