package actions;

import java.util.ArrayList;
import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.sv_cc_hv;
import models.tk_theo_lop;

public class QLDVNTKCCHVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNTKAction qlntkAction = null;
	private QLDVNAction qlnAction = null;
	private ArrayList<sv_cc_hv> dsSVCCHV = null;
	private ArrayList<tk_theo_lop> dsSVTrongLop = null;
	private String tenKhoa;
	private int tsLop = 0;

	public QLDVNTKCCHVAction() {
	}

	public String execute() {
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		this.qlntkAction = new QLDVNTKAction();
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.qlntkAction.assignHKNKValues(this.session);
		}

		if (!this.qlnAction.Prefix_Check("Thống kê danh sách sinh viên bị cảnh cáo học vụ", this.session))
			return ERROR;
		this.assignDSSVCCHV(this.session);
		if (this.dsSVCCHV.size() > 0)
			this.assignDSSVTrongLop(this.session);

		return SUCCESS;
	}

	public void assignDSSVCCHV(Map<String, Object> session) {
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_sv_cc_hv(?,?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			pstmt.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			pstmt.setInt(2, Integer.parseInt(session.get("current_hk").toString()));
			pstmt.setString(3, session.get("current_nk").toString());
			setTenKhoa(infor_user.get("6_KHOA"));
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int stt = 1;

			// Duyệt kết quả
			this.dsSVCCHV = new ArrayList<sv_cc_hv>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					sv_cc_hv sv = new sv_cc_hv();
					sv.setStt(stt++);
					sv.setMssv(rs.getString("MSSV"));
					sv.setHo_ten(rs.getString("HO_TEN"));
					sv.setNgay_sinh(rs.getString("NGAY_SINH"));
					sv.setGioi_tinh((rs.getString("GIOI_TINH").equals("0")) ? "Nam" : "Nữ");
					sv.setTen_lop(rs.getString("TEN_LOP"));
					sv.setChuyen_nganh(rs.getString("CHUYEN_NGANH"));
					sv.setDtb(rs.getFloat("DTBHK"));

					this.dsSVCCHV.add(sv);
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

	public void assignDSSVTrongLop(Map<String, Object> session) {
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_tk_sv_cc_hv(?,?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			pstmt.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			pstmt.setInt(2, Integer.parseInt(session.get("current_hk").toString()));
			pstmt.setString(3, session.get("current_nk").toString());
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int ts = 0;

			// Duyệt kết quả
			this.dsSVTrongLop = new ArrayList<tk_theo_lop>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					tk_theo_lop sv = new tk_theo_lop();
					sv.setTen_lop(rs.getString("TEN_LOP"));
					sv.setSo_sv(rs.getInt("SO_SV"));
					ts++;
					this.dsSVTrongLop.add(sv);
				}
			}
			// Đóng kết nối
			this.setTsLop(ts);
			pstmt.close();
			rs.close();
			this.conn.Close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public ArrayList<sv_cc_hv> getDsSVCCHV() {
		return dsSVCCHV;
	}

	public String getTenKhoa() {
		return tenKhoa;
	}

	public ArrayList<tk_theo_lop> getDsSVTrongLop() {
		return dsSVTrongLop;
	}

	public int getTsLop() {
		return tsLop;
	}

	public void setDsSVCCHV(ArrayList<sv_cc_hv> dsSVCCHV) {
		this.dsSVCCHV = dsSVCCHV;
	}

	public void setTenKhoa(String tenKhoa) {
		this.tenKhoa = tenKhoa;
	}

	public void setDsSVTrongLop(ArrayList<tk_theo_lop> dsSVTrongLop) {
		this.dsSVTrongLop = dsSVTrongLop;
	}

	public void setTsLop(int tsLop) {
		this.tsLop = tsLop;
	}
}
