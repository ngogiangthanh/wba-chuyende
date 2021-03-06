package actions;

import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.sv_pdt;
import models.sv_qldvn;

public class QLDVNXLNhapDiemNoSVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;
	private QLDVNAction qlnAction = null;
	private Connect conn;
	private String mssv;
	private String id_hp;
	private String diem_chu;

	public QLDVNXLNhapDiemNoSVAction() {
	}

	public String execute() {
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		if (!this.qlnAction.Prefix_Check("", this.session))
			return ERROR;

		// Gọi procedure lấy thông tin
		this.conn = new Connect();
		String procedure = "call update_qldvn_diem_hp(?,?,?,?,?);";
		CallableStatement pstmt = null;
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			pstmt.setInt(1, Integer.parseInt(getId_hp()));
			pstmt.setString(2, getMssv());
			pstmt.setFloat(3, 11);
			pstmt.setString(4, getDiem_chu());
			pstmt.setFloat(5, 5);
			// Thực thi procedure
			pstmt.execute();
			// Đóng kết nối
			pstmt.close();
			this.conn.Close();
			addActionMessage("Nhập điểm "+this.getDiem_chu()+" hoàn tất!");
		} catch (Exception e) {
			addActionError("Có lỗi xảy ra khi nhập điểm!");
			e.printStackTrace();
		}

		return SUCCESS;
	}

	public String getMssv() {
		return mssv;
	}
	
	public String getId_hp() {
		return id_hp;
	}
	
	public String getDiem_chu() {
		return diem_chu;
	}
	
	public void setMssv(String mssv) {
		this.mssv = mssv;
	}
	
	public void setId_hp(String id_hp) {
		this.id_hp = id_hp;
	}
	
	public void setDiem_chu(String diem_chu) {
		this.diem_chu = diem_chu;
	}
}
