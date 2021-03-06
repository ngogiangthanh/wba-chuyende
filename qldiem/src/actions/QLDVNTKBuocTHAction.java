package actions;

import java.util.ArrayList;
import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.sv_thoi_hoc;
import models.tk_theo_lop;

public class QLDVNTKBuocTHAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNTKAction qlntkAction = null;
	private QLDVNAction qlnAction = null;
	private ArrayList<sv_thoi_hoc> dsSVThoiHoc = null;
	private ArrayList<tk_theo_lop> dsSVTheoLop = null;
	private String tenKhoa;
	private int tsLop = 0;

	public QLDVNTKBuocTHAction() {
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

		if (!this.qlnAction.Prefix_Check("Thống kê danh sách sinh viên bị buộc thôi học", this.session))
			return ERROR;
		this.assignDSSVThoiHoc(this.session);
		if (this.dsSVThoiHoc.size() > 0)
			this.assignDSSVTheoLop(this.session);

		return SUCCESS;
	}

	public void assignDSSVThoiHoc(Map<String, Object> session) {
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_sv_thoi_hoc(?,?,?,?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			pstmt.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			pstmt.setInt(2, Integer.parseInt(session.get("current_hk").toString()));
			pstmt.setString(3, session.get("current_nk").toString());
			pstmt.setInt(4, Integer.parseInt(session.get("pre_hk").toString()));
			pstmt.setString(5, session.get("pre_nk").toString());
			setTenKhoa(infor_user.get("6_KHOA"));
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int stt = 1;

			// Duyệt kết quả
			this.dsSVThoiHoc = new ArrayList<sv_thoi_hoc>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					sv_thoi_hoc sv = new sv_thoi_hoc();
					sv.setStt(stt++);
					sv.setMssv(rs.getString("MSSV"));
					sv.setHo_ten(rs.getString("HO_TEN"));
					sv.setNgay_sinh(rs.getString("NGAY_SINH"));
					sv.setGioi_tinh((rs.getString("GIOI_TINH").equals("0")) ? "Nam" : "Nữ");
					sv.setTen_lop(rs.getString("TEN_LOP"));
					sv.setChuyen_nganh(rs.getString("CHUYEN_NGANH"));

					this.dsSVThoiHoc.add(sv);
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

	public void assignDSSVTheoLop(Map<String, Object> session) {
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_tk_thoi_hoc(?,?,?,?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			pstmt.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			pstmt.setInt(2, Integer.parseInt(session.get("current_hk").toString()));
			pstmt.setString(3, session.get("current_nk").toString());
			pstmt.setInt(4, Integer.parseInt(session.get("pre_hk").toString()));
			pstmt.setString(5, session.get("pre_nk").toString());
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int ts = 0;

			// Duyệt kết quả
			this.dsSVTheoLop = new ArrayList<tk_theo_lop>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					tk_theo_lop sv = new tk_theo_lop();
					sv.setTen_lop(rs.getString("TEN_LOP"));
					sv.setSo_sv(rs.getInt("SO_SV"));
					ts++;
					this.dsSVTheoLop.add(sv);
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

	public ArrayList<tk_theo_lop> getDsSVTheoLop() {
		return dsSVTheoLop;
	}

	public ArrayList<sv_thoi_hoc> getDsSVThoiHoc() {
		return dsSVThoiHoc;
	}

	public String getTenKhoa() {
		return tenKhoa;
	}

	public int getTsLop() {
		return tsLop;
	}

	public void setDsSVThoiHoc(ArrayList<sv_thoi_hoc> dsSVThoiHoc) {
		this.dsSVThoiHoc = dsSVThoiHoc;
	}

	public void setTenKhoa(String tenKhoa) {
		this.tenKhoa = tenKhoa;
	}

	public void setDsSVTheoLop(ArrayList<tk_theo_lop> dsSVTheoLop) {
		this.dsSVTheoLop = dsSVTheoLop;
	}

	public void setTsLop(int tsLop) {
		this.tsLop = tsLop;
	}
}
