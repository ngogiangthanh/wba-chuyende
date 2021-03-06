package actions;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.mysql.jdbc.CallableStatement;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import connection.Connect;
import models.muc_chuyen_doi;
import models.sv_hp;
import models.thang_diem;

public class GVNhapDiemExcelAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private GVAction gvAction = null;
	private List<sv_hp> dsSVHP;

	public GVNhapDiemExcelAction() {
	}

	public String execute() {
		this.gvAction = new GVAction();
		this.session = ActionContext.getContext().getSession();
		if (!gvAction.Prefix_Check("", this.session))
			return ERROR;

		if (!session.containsKey("thang_diem")) {
			System.out.println("Gán thang điểm lần đầu");
			ThangDiemAction thangDiemAction = new ThangDiemAction();
			thangDiemAction.assignTDValues(this.session);
		}

		thang_diem thang_diem_qd = (thang_diem) session.get("thang_diem");
		ArrayList<muc_chuyen_doi> ds_mcd = thang_diem_qd.getDs_muc_chuyen_doi();
		int size_ds = ds_mcd.size();

		int sizeDSSVHP = this.dsSVHP.size();
		for (int index = 0; index < sizeDSSVHP; index++) {
			float diem_10 = this.dsSVHP.get(index).getDiem_10();
			for (int i = 0; i < size_ds; i++) {
				if (diem_10 >= ds_mcd.get(i).getDiem10()) {
					this.dsSVHP.get(index).setDiem_4(ds_mcd.get(i).getDiem4());
					this.dsSVHP.get(index).setDiem_chu(ds_mcd.get(i).getDiemChu() + "");
					break;
				}
			}
		}

		this.conn = new Connect();
		String procedure = "call update_gv_diem_hp(?,?,?,?,?,?);";

		for (int index = 0; index < sizeDSSVHP; index++) {
			CallableStatement pstmt = null;
			try {
				pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
				// Gán tham số id_hp
				pstmt.setInt(1, this.dsSVHP.get(index).getId_hp());
				// Gán tham số id_sv
				pstmt.setInt(2, this.dsSVHP.get(index).getId_sv());
				// Gán tham số diem_10
				pstmt.setFloat(3, this.dsSVHP.get(index).getDiem_10());
				// Gán tham số diem_chu
				pstmt.setString(4, this.dsSVHP.get(index).getDiem_chu());
				// Gán tham số diem_4
				pstmt.setFloat(5, this.dsSVHP.get(index).getDiem_4());
				// Gán tham số cai_thien
				pstmt.setInt(6, Integer.parseInt(this.dsSVHP.get(index).getCai_thien()));
				// Thực thi procedure
				pstmt.execute();
				pstmt.close();

			} catch (Exception e) {
				addActionError("Cập nhật điểm thất bại, id sv= " + this.dsSVHP.get(index).getId_sv() + "!");
				e.printStackTrace();
			}
		}
		this.conn.Close();

		addActionMessage("Cập nhật điểm hoàn tất!");

		return SUCCESS;
	}

	public List<sv_hp> getDsSVHP() {
		return dsSVHP;
	}

	public void setDsSVHP(List<sv_hp> dsSVHP) {
		this.dsSVHP = dsSVHP;
	}
}
