package actions;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.lop_cv;
import models.sv_hp;
import models.sv_lop_cv;

public class CVHTViewDSSVLopCVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;
	private GVAction gvAction = null;
	private ArrayList<sv_lop_cv> dsSVLopCV = null;
	private Connect conn;
	private String id_lop;

	public CVHTViewDSSVLopCVAction() {
	}

	public String execute() {
		this.gvAction = new GVAction();
		this.session = ActionContext.getContext().getSession();
		if (!gvAction.Prefix_Check("Trang chủ xem danh sách sinh viên lớp cố vấn", this.session))
			return ERROR;

		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_cvht_lop_cv_ds_sv(?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			pstmt.setInt(1, Integer.parseInt(getId_lop()));
			pstmt.setInt(2, Integer.parseInt(infor_user.get("7_ID")));

			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int stt = 1;

			// Duyệt kết quả
			this.dsSVLopCV = new ArrayList<sv_lop_cv>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					sv_lop_cv sv_lop = new sv_lop_cv();
					sv_lop.setStt(stt++);
					sv_lop.setId_sv(rs.getInt("ID_SV"));
					sv_lop.setMssv(rs.getString("MSSV"));
					sv_lop.setHo_ten(rs.getString("HO_TEN"));
					sv_lop.setGioi_tinh((rs.getString("GIOI_TINH").equals("0")) ? "nam" : "nữ");
					sv_lop.setNgay_sinh(rs.getString("NGAY_SINH"));
					sv_lop.setKhoa(rs.getString("KHOA"));
					sv_lop.setChuyen_nganh(rs.getString("CHUYEN_NGANH"));

					this.dsSVLopCV.add(sv_lop);
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

	public void validate() {
		try {
			int test_id_lop = Integer.parseInt(getId_lop());
			if (test_id_lop <= 0)
				addActionError("Lớp không hợp lệ!");
		} catch (Exception ex) {
			addActionError("Lớp không hợp lệ!");
		}
	}

	public ArrayList<sv_lop_cv> getDsSVLopCV() {
		return dsSVLopCV;
	}

	public String getId_lop() {
		return id_lop;
	}

	public void setDsSVLopCV(ArrayList<sv_lop_cv> dsSVLopCV) {
		this.dsSVLopCV = dsSVLopCV;
	}

	public void setId_lop(String id_lop) {
		this.id_lop = id_lop;
	}
}
