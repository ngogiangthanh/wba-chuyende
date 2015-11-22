package actions;

import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.hk_nk;
import models.sv_diem_hp;
import models.sv_pdt_in;
import models.thang_diem;

public class PDTPrintedMarkAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private PDTAction pdtAction = null;
	private String hk;
	private String nk;
	private String id_sv;
	private Map<hk_nk, List<sv_diem_hp>> dsDiemHP = new LinkedHashMap<hk_nk, List<sv_diem_hp>>();
	private sv_pdt_in sv_print_mark;

	public PDTPrintedMarkAction() {
	}

	public String execute() {
		this.pdtAction = new PDTAction();
		this.session = ActionContext.getContext().getSession();
		if (!this.pdtAction.Prefix_Check("In điểm cho sinh viên", this.session))
			return ERROR;

		// Kiểm tra xem nếu session thang_diem đã có thì khởi tạo lại và ngược
		// lại
		if (!session.containsKey("thang_diem")) {
			System.out.println("Gán thang điểm lần đầu");
			ThangDiemAction thangDiemAction = new ThangDiemAction();
			thangDiemAction.assignTDValues(session);
		}

		// Kiểm tra xem năm chọn có mở chưa, nếu chưa mở thì báo học kỳ chưa mở
		// không thực hiện các bước phía dưới
		if (!this.isOpenHKNK(this.session)) {
			addActionError("Học kỳ " + this.getHk() + " - " + this.getNk()+" chưa mở!");
			return "print-mark";
		}

		// Gọi procedure lấy thông tin điểm hp dựa trên 3 tham số năm học - học
		// kỳ - id sv
		this.conn = new Connect();
		String procedure = "call get_tt_sv_diem_hp(?,?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);

			// Gán tham số id sv
			pstmt.setInt(3, Integer.parseInt(getId_sv()));
			// Gán tham số năm học (niên khóa)
			if (this.getNk().equals("0")) {
				// Trường hợp chọn xem tất cả
				pstmt.setNull(1, java.sql.Types.CHAR);
			} else {
				// Trường hợp xem một niên khóa nào đó
				pstmt.setString(1, getNk());
			}

			// Gán tham số cho học kỳ
			if (this.getHk().equals("0")) {
				// Trường hợp chọn xem tất cả
				pstmt.setNull(2, java.sql.Types.TINYINT);
			} else {
				// Trường hợp xem một học kỳ nào đó
				pstmt.setInt(2, Integer.parseInt(getHk()));
			}

			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int stt = 1;

			// Duyệt kết quả
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					// Cập nhật dữ liệu ban đầu
					hk_nk key_hknk = new hk_nk(rs.getString("NK"), rs.getInt("HK"));
					List<sv_diem_hp> list_ds_diem_hp;

					System.out.println("Học kỳ hiện tại: " + key_hknk.getHk() + "- " + key_hknk.getNk());
					if (this.dsDiemHP.containsKey(key_hknk)) {
						// Trường hợp thêm cũ
						System.out.println("Đã tồn tại thêm cũ " + key_hknk.getHk() + "- " + key_hknk.getNk());
						list_ds_diem_hp = this.dsDiemHP.get(key_hknk);
					} else {
						// Trường hợp thêm mới
						System.out.println("Chưa tồn tại thêm mới");
						list_ds_diem_hp = new ArrayList<>();
						// Reset stt lại 1;
						stt = 1;
					}

					// Tạo đối tượng điểm hp sv và gán giá trị lần lượt vào
					// thuộc tính của đối tượng này
					sv_diem_hp hp = new sv_diem_hp();
					hp.setStt(stt++);
					hp.setMaMH(rs.getString("MA_MH"));
					hp.setTenHP(rs.getString("TEN_MH"));
					hp.setHpDieuKien(rs.getString("DIEU_KIEN"));
					hp.setMaHP(rs.getString("MA_HP"));
					hp.setSoTC(rs.getInt("SO_TC"));
					hp.setDiemChu(rs.getString("DIEM_CHU"));
					hp.setDiem10(rs.getFloat("DIEM_10"));
					hp.setDiem4(rs.getFloat("DIEM_4"));
					hp.setTichLuy(rs.getString("TL"));
					hp.setCaiThien(rs.getString("CAI_THIEN"));
					// Tính tích điểm
					thang_diem thang_diem_qd = (thang_diem) session.get("thang_diem");
					hp.setThang_diem_qd(thang_diem_qd);
					hp.tinhTichDiem();
					// Thêm vào list ds điểm học phần
					list_ds_diem_hp.add(hp);

					// Cập nhật dữ liệu tbtlc
					CallableStatement pstat = (CallableStatement) this.conn.getConn()
							.prepareCall("{ ? = call get_tt_sv_diem_hp_tl(?,?,?)}");
					float tbtlc = 0;
					pstat.registerOutParameter(1, Types.FLOAT);
					pstat.setString(2, rs.getString("NK"));
					pstat.setInt(3, rs.getInt("HK"));
					pstat.setInt(4, Integer.parseInt(getId_sv()));

					pstat.execute();
					tbtlc = pstat.getFloat(1);
					// Cập nhật dữ liệu tstctl
					pstat = (CallableStatement) this.conn.getConn()
							.prepareCall("{ ? = call get_tt_sv_diem_hp_tc_tl(?,?,?)}");
					int tstctl = 0;
					pstat.registerOutParameter(1, Types.INTEGER);
					pstat.setString(2, rs.getString("NK"));
					pstat.setInt(3, rs.getInt("HK"));
					pstat.setInt(4, Integer.parseInt(getId_sv()));

					pstat.execute();
					tstctl = pstat.getInt(1);

					// Thêm toàn bộ vào ds điểm học phần
					key_hknk.setTbctl(tbtlc);
					key_hknk.setTstctl(tstctl);
					this.dsDiemHP.put(key_hknk, list_ds_diem_hp);
				}
			}

			// Đóng kết nối
			pstmt.close();
			rs.close();
			this.conn.Close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		this.assignSVPrintMark();

		return "printed-mark";
	}
	
	public void assignSVPrintMark(){
		this.conn = new Connect();
		String procedure = "call get_tt_pdt_tt_sv(?);";
		CallableStatement pstmt = null;
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			// Gán tham số id sv
			pstmt.setInt(1, Integer.parseInt(getId_sv()));
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			// Duyệt kết quả
			if (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					this.sv_print_mark = new sv_pdt_in();
					this.sv_print_mark.setStt(0);
					this.sv_print_mark.setId_sv(rs.getInt("ID_SV"));
					this.sv_print_mark.setMssv(rs.getString("MSSV"));
					this.sv_print_mark.setHo_ten(rs.getString("HO_TEN"));
					this.sv_print_mark.setGioi_tinh((rs.getString("GIOI_TINH").equals("0")) ? "Nam" : "Nữ");
					this.sv_print_mark.setNgay_sinh(rs.getString("NGAY_SINH"));
					this.sv_print_mark.setKhoa(rs.getString("KHOA"));
					this.sv_print_mark.setChuyen_nganh(rs.getString("CHUYEN_NGANH"));
					this.sv_print_mark.setLop(rs.getString("LOP"));
					this.sv_print_mark.setTen_lop(rs.getString("TEN_LOP"));
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

	public boolean isOpenHKNK(Map<String, Object> session) {
		Map<String, ArrayList<Integer>> hknk = (Map<String, ArrayList<Integer>>) session.get("hknk");
		// Kiểm tra xem học kì người dùng chọn có trong session hknk không? nếu
		// có thì kết luật là hk có mở và ngược lại
		if (this.getNk() != "0" & hknk.containsKey(this.getNk())) {
			if (!this.getHk().equals("0")) {
				ArrayList<Integer> list_hk = hknk.get(this.getNk());
				return list_hk.contains(Integer.parseInt(this.getHk()));
			}
		}
		return true;
	}
	
	public void validate(){
		try {
			int test_id_sv = Integer.parseInt(getId_sv());
			if (test_id_sv <= 0)
				addActionError("Sinh viên không hợp lệ!");
			
			int test_hk = Integer.parseInt(getHk());
			if (test_hk < 0 || test_hk > 3)
				addActionError("Học kỳ không hợp lệ!");
			
			if (getNk().length() > 9 || getNk().length() < 0)
				addActionError("Niên khóa không hợp lệ!");

		} catch (Exception ex) {
			addActionError("Sinh viên không hợp lệ!");
		}
	}

	public String getHk() {
		return hk;
	}

	public String getNk() {
		return nk;
	}

	public String getId_sv() {
		return id_sv;
	}
	
	public Map<hk_nk, List<sv_diem_hp>> getDsDiemHP() {
		return dsDiemHP;
	}
	
	public sv_pdt_in getSv_print_mark() {
		return sv_print_mark;
	}

	public void setHk(String hk) {
		this.hk = hk;
	}

	public void setNk(String nk) {
		this.nk = nk;
	}

	public void setId_sv(String id_sv) {
		this.id_sv = id_sv;
	}
	
	public void setDsDiemHP(Map<hk_nk, List<sv_diem_hp>> dsDiemHP) {
		this.dsDiemHP = dsDiemHP;
	}
	
	public void setSv_print_mark(sv_pdt_in sv_print_mark) {
		this.sv_print_mark = sv_print_mark;
	}
}
