package actions;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;
import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import connection.Connect;
import models.quy_dinh;
import models.sv_khen_thuong;

public class QLDVNTKHocBongAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNTKAction qlntkAction = null;
	private QLDVNAction qlnAction = null;
	private Map<String, ArrayList<sv_khen_thuong>> dsSVNhanHB = null;
	private String tenKhoa = null;

	public QLDVNTKHocBongAction() {
		
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

		if (!this.qlnAction.Prefix_Check("Thống kê danh sách sinh viên nhận học bổng", this.session))
			return ERROR;

		this.assignDSSVNhanHB(this.session);

		return SUCCESS;
	}

	public void assignDSSVNhanHB(Map<String, Object> session) {
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure_nhan_hb = "call get_tt_qldvn_ds_sv_hb(?,?,?);";
		String procedure_hb_tren_lop = "call get_tt_qldvn_so_hb_tren_lop(?);";
		CallableStatement pstmt_nhan_hb = null;
		CallableStatement pstmt_hb_tren_lop = null;

		try {
			pstmt_nhan_hb = (CallableStatement) this.conn.getConn().prepareCall(procedure_nhan_hb);
			pstmt_hb_tren_lop = (CallableStatement) this.conn.getConn().prepareCall(procedure_hb_tren_lop);
			//
			pstmt_nhan_hb.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			pstmt_nhan_hb.setInt(2, Integer.parseInt(session.get("current_hk").toString()));
			pstmt_nhan_hb.setString(3, session.get("current_nk").toString());
			System.out.println("Gán ten khoa");
			setTenKhoa(infor_user.get("6_KHOA"));
			//
			pstmt_hb_tren_lop.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			// Thực thi procedure
			pstmt_nhan_hb.execute();
			ResultSet rs_nhan_hb = (ResultSet) pstmt_nhan_hb.getResultSet();
			pstmt_hb_tren_lop.execute();
			ResultSet rs_tren_lop = (ResultSet) pstmt_hb_tren_lop.getResultSet();
			// Lấy ra ds quy định só hb trên lớp
			ArrayList<quy_dinh> quyDinh = new ArrayList<>();
			while (rs_tren_lop.next()) {
				// Khi hàng đó không null
				if (!rs_tren_lop.wasNull()) {
					quy_dinh qd = new quy_dinh();
					qd.setLop(rs_tren_lop.getString("LOP").trim());
					qd.setSo_sv(rs_tren_lop.getInt("SO_SV"));

					quyDinh.add(qd);
				}
			}
			// Duyệt kết quả ds sv đủ điều kiện nhận học bổng
			int sizeQD = quyDinh.size();
			this.dsSVNhanHB = new LinkedHashMap<String, ArrayList<sv_khen_thuong>>();
			while (rs_nhan_hb.next()) {
				// Khi hàng đó không null
				if (!rs_nhan_hb.wasNull()) {
					String current_lop = rs_nhan_hb.getString("LOP").trim();
					int index = 0;
					quy_dinh qd = null;
					for (index = 0; index < sizeQD; index++) {
						qd = quyDinh.get(index);
						if (qd.getLop().equals(current_lop)) {
							break;
						}
					}

					ArrayList<sv_khen_thuong> dssv;
					if (this.dsSVNhanHB.containsKey(qd.getLop())) {
						// Thêm cũ
						dssv = this.dsSVNhanHB.get(qd.getLop());
					} else {
						// Thêm mới
						dssv = new ArrayList<>();
					}
					int stt = dssv.size();
					if (stt < qd.getSo_sv()) {
						sv_khen_thuong sv = new sv_khen_thuong();
						sv.setStt(++stt);
						sv.setMssv(rs_nhan_hb.getString("MSSV"));
						sv.setHo_ten(rs_nhan_hb.getString("HO_TEN"));
						sv.setNgay_sinh(rs_nhan_hb.getString("NGAY_SINH"));
						sv.setGioi_tinh((rs_nhan_hb.getString("GIOI_TINH").equals("0")) ? "Nam" : "Nữ");
						sv.setLop(rs_nhan_hb.getString("LOP"));
						sv.setTen_lop(rs_nhan_hb.getString("TEN_LOP"));
						sv.setChuyen_nganh(rs_nhan_hb.getString("CHUYEN_NGANH"));
						sv.setDtb(rs_nhan_hb.getFloat("DTBHK"));
						//
						dssv.add(sv);
					} else {
						continue;
					}

					this.dsSVNhanHB.put(current_lop, dssv);
				}
			}
			// Đóng kết nối
			pstmt_nhan_hb.close();
			pstmt_hb_tren_lop.close();
			rs_nhan_hb.close();
			rs_tren_lop.close();
			this.conn.Close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public Map<String, ArrayList<sv_khen_thuong>> getDsSVNhanHB() {
		return dsSVNhanHB;
	}

	public String getTenKhoa() {
		return tenKhoa;
	}

	public void setDsSVNhanHB(Map<String, ArrayList<sv_khen_thuong>> dsSVNhanHB) {
		this.dsSVNhanHB = dsSVNhanHB;
	}

	public void setTenKhoa(String tenKhoa) {
		this.tenKhoa = tenKhoa;
	}
}
