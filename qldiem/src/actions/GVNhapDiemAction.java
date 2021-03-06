package actions;

import java.util.ArrayList;
import java.util.Map;
import com.mysql.jdbc.CallableStatement;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import connection.Connect;
import models.muc_chuyen_doi;
import models.thang_diem;

public class GVNhapDiemAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private String id_hp;
	private String id_sv;
	private String diem_10;
	private String diem_chu;
	private String diem_4;
	private String cai_thien;

	public GVNhapDiemAction() {
	}

	public String postProcessSave() {
		this.session = ActionContext.getContext().getSession();
		if (!this.Prefix_Check("", this.session))
			return ERROR;
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
			if (Float.parseFloat(getDiem_10()) >= ds_mcd.get(i).getDiem10()) {
				setDiem_4(ds_mcd.get(i).getDiem4() + "");
				setDiem_chu(ds_mcd.get(i).getDiemChu() + "");
				break;
			}
		}

		this.conn = new Connect();
		String procedure = "call update_gv_diem_hp(?,?,?,?,?,?);";
		CallableStatement pstmt = null;
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			// Gán tham số id_hp
			pstmt.setInt(1, Integer.parseInt(getId_hp()));
			// Gán tham số id_sv
			pstmt.setInt(2, Integer.parseInt(getId_sv()));
			// Gán tham số diem_10
			pstmt.setFloat(3, Float.parseFloat(getDiem_10()));
			// Gán tham số diem_chu
			pstmt.setString(4, getDiem_chu());
			// Gán tham số diem_4
			pstmt.setFloat(5, Float.parseFloat(getDiem_4()));
			// Gán tham số cai_thien
			pstmt.setInt(6, Integer.parseInt(getCai_thien()));
			// Thực thi procedure
			pstmt.execute();
			pstmt.close();

		} catch (Exception e) {
			addActionError("Cập nhật điểm thất bại!");
			e.printStackTrace();
		}
		this.conn.Close();
		addActionMessage("Cập nhật điểm hoàn tất!");
		return SUCCESS;
	}

	public boolean Prefix_Check(String title, Map<String, Object> session) {
		if (!Home.isRole(session, 1) && !Home.isRole(session, 2)) {
			if (!session.isEmpty()) {
				session.clear();
				addActionError("Truy xuất sai nhóm quyền!");
				addActionMessage("Tự động đăng xuất để đăng nhập nhóm quyền phù hợp!");
			}
			return false;
		}
		session.put("title", title);
		return true;
	}

	public String getId_hp() {
		return id_hp;
	}

	public String getId_sv() {
		return id_sv;
	}

	public String getDiem_10() {
		return diem_10;
	}

	public String getDiem_4() {
		return diem_4;
	}

	public String getDiem_chu() {
		return diem_chu;
	}

	public String getCai_thien() {
		return cai_thien;
	}

	public void setId_hp(String id_hp) {
		this.id_hp = id_hp;
	}

	public void setId_sv(String id_sv) {
		this.id_sv = id_sv;
	}

	public void setDiem_10(String diem_10) {
		this.diem_10 = diem_10;
	}

	public void setDiem_4(String diem_4) {
		this.diem_4 = diem_4;
	}

	public void setDiem_chu(String diem_chu) {
		this.diem_chu = diem_chu;
	}

	public void setCai_thien(String cai_thien) {
		this.cai_thien = cai_thien;
	}

}
