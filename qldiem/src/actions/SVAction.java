package actions;

import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
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
import models.thang_diem;

public class SVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private String hk;
	private String nk;
	private Map<hk_nk, List<sv_diem_hp>> dsDiemHP = new LinkedHashMap<hk_nk, List<sv_diem_hp>>();
	private Map<String, Object> session = null;
	public SVAction() {
	}

	public String getIndex() {
		this.session = ActionContext.getContext().getSession();
		if(!Prefix_Check("Trang chủ sinh viên", this.session))
			return "error";
		return "index";
	}

	public String getViewProfile() {
		this.session = ActionContext.getContext().getSession();
		if(!Prefix_Check("Xem thông tin sinh viên", this.session))
			return "error";
		return "view-profile";
	}

	public String getViewMark() {
		this.session = ActionContext.getContext().getSession();
		if(!Prefix_Check("Xem kết quả học tập",this.session))
			return "error";
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.assignHKNKValues(this.session);
		}

		// Kiểm tra xem nếu session thang_diem đã có thì khởi tạo lại và ngược
		// lại
		if (!session.containsKey("thang_diem")) {
			System.out.println("Gán thang điểm lần đầu");
			ThangDiemAction thangDiemAction = new ThangDiemAction();
			thangDiemAction.assignTDValues(this.session);
		}

		// Kiểm tra xem năm chọn có mở chưa, nếu chưa mở thì báo học kỳ chưa mở
		// không thực hiện các bước phía dưới
		if (!this.isOpenHKNK(this.session)) {
			System.out.println("Học kỳ chưa mở " + this.getHk() + " - " + this.getNk());
			return "view-mark";
		}

		// Gọi procedure lấy thông tin điểm hp dựa trên 3 tham số năm học - học
		// kỳ - id sv
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_sv_diem_hp(?,?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			// Gán tham số id sv
			pstmt.setInt(3, Integer.parseInt(infor_user.get("9_ID")));
			// Gán tham số năm học (niên khóa)
			if (this.getNk() == null) {
				// Trường hợp chưa chọn hoặc resend lại thì mặc định chọn niên
				// khóa hiện tại
				this.setNk(session.get("current_nk").toString());
				pstmt.setString(1, getNk());
			} else if (this.getNk().equals("0")) {
				// Trường hợp chọn xem tất cả
				pstmt.setNull(1, java.sql.Types.CHAR);
			} else {
				// Trường hợp xem một niên khóa nào đó
				pstmt.setString(1, getNk());
			}

			// Gán tham số cho học kỳ
			if (this.getHk() == null) {
				// Trường hợp chưa chọn hoặc resend lại thì mặc định chọn học kỳ
				// hiện tại
				this.setHk(session.get("current_hk").toString());
				pstmt.setInt(2, Integer.parseInt(getHk()));
			} else if (this.getHk().equals("0")) {
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
					hp.setDiemChu(rs.getString("DIEM_CHU").trim());
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
					pstat.setInt(4, Integer.parseInt(infor_user.get("9_ID")));

					pstat.execute();
					tbtlc = pstat.getFloat(1);
					// Cập nhật dữ liệu tstctl
					pstat = (CallableStatement) this.conn.getConn()
							.prepareCall("{ ? = call get_tt_sv_diem_hp_tc_tl(?,?,?)}");
					int tstctl = 0;
					pstat.registerOutParameter(1, Types.INTEGER);
					pstat.setString(2, rs.getString("NK"));
					pstat.setInt(3, rs.getInt("HK"));
					pstat.setInt(4, Integer.parseInt(infor_user.get("9_ID")));

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
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "view-mark";
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

	public void assignHKNKValues(Map<String, Object> session) {
		// Ý tưởng tạo ra 1 session chứa thông tin các hk nk. Chỉ tạo một lần
		// duy nhất lúc người dùng gọi lần đầu
		this.conn = new Connect();
		String procedure = "call get_tt_hk_nk();";
		Map<String, ArrayList<Integer>> hknk = new HashMap<String, ArrayList<Integer>>();
		int first = 1;
		try {
			ResultSet rs = this.conn.call_procedure(procedure);
			while (rs.next()) {
				String nk = rs.getString("NK");
				ArrayList<Integer> list_hk;
				if (hknk.containsKey(nk)) {
					// Thêm cũ
					System.out.println("Thêm cũ hknk");
					list_hk = hknk.get(nk);
				} else {
					// Thêm mới
					System.out.println("Thêm mới hknk");
					list_hk = new ArrayList<Integer>();
				}
				Integer hk = rs.getInt("HK");
				list_hk.add(hk);
				hknk.put(nk, list_hk);
				// Mặc định học kỳ hiện tại là học kỳ gần nhất, dòng đầu tiên
				// của kết quả truy vấn
				if (first == 1) {
					session.put("current_hk", hk);
					session.put("current_nk", nk);
					this.setHk(hk + "");
					this.setNk(nk);
					first++;
				}
			}
			// Đóng kết nối
			rs.close();
			this.conn.Close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		// Thêm vào session
		session.put("hknk", hknk);
	}

	public String getPrintMark() {
		this.session = ActionContext.getContext().getSession();
		if(!Prefix_Check("In bảng điểm theo học kỳ năm học", this.session))
			return "error";
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.assignHKNKValues(this.session);
		}
		this.setNk(session.get("current_nk").toString());
		this.setHk(session.get("current_hk").toString());

		return "print-mark";
	}

	public String getPrintedMark(){
		this.session = ActionContext.getContext().getSession();
		if(!Prefix_Check("In bảng điểm theo học kỳ năm học", this.session))
			return "error";
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
			System.out.println("Học kỳ chưa mở " + this.getHk() + " - " + this.getNk());
			return "print-mark";
		}

		// Gọi procedure lấy thông tin điểm hp dựa trên 3 tham số năm học - học
		// kỳ - id sv
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_sv_diem_hp(?,?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			// Gán tham số id sv
			pstmt.setInt(3, Integer.parseInt(infor_user.get("9_ID")));
			// Gán tham số năm học (niên khóa)
			if (this.getNk() == null) {
				// Trường hợp chưa chọn hoặc resend lại thì mặc định chọn niên
				// khóa hiện tại
				this.setNk(session.get("current_nk").toString());
				pstmt.setString(1, getNk());
			} else if (this.getNk().equals("0")) {
				// Trường hợp chọn xem tất cả
				pstmt.setNull(1, java.sql.Types.CHAR);
			} else {
				// Trường hợp xem một niên khóa nào đó
				pstmt.setString(1, getNk());
			}

			// Gán tham số cho học kỳ
			if (this.getHk() == null) {
				// Trường hợp chưa chọn hoặc resend lại thì mặc định chọn học kỳ
				// hiện tại
				this.setHk(session.get("current_hk").toString());
				pstmt.setInt(2, Integer.parseInt(getHk()));
			} else if (this.getHk().equals("0")) {
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
					hp.setDiemChu(rs.getString("DIEM_CHU").trim());
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
					pstat.setInt(4, Integer.parseInt(infor_user.get("9_ID")));

					pstat.execute();
					tbtlc = pstat.getFloat(1);
					// Cập nhật dữ liệu tstctl
					pstat = (CallableStatement) this.conn.getConn()
							.prepareCall("{ ? = call get_tt_sv_diem_hp_tc_tl(?,?,?)}");
					int tstctl = 0;
					pstat.registerOutParameter(1, Types.INTEGER);
					pstat.setString(2, rs.getString("NK"));
					pstat.setInt(3, rs.getInt("HK"));
					pstat.setInt(4, Integer.parseInt(infor_user.get("9_ID")));

					pstat.execute();
					tstctl = pstat.getInt(1);

					// Thêm toàn bộ vào ds điểm học phần
					key_hknk.setTbctl(tbtlc);
					key_hknk.setTstctl(tstctl);
					this.dsDiemHP.put(key_hknk, list_ds_diem_hp);
				}
			}
			// Đóng kết nối
			rs.close();
			this.conn.Close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "printed-mark";
		
	}
	
	public boolean Prefix_Check(String title, Map<String, Object> session)
	{
		if(!Home.isRole(session,0)){
			if(!session.isEmpty()){
				session.clear();
				addActionError("Truy xuất sai nhóm quyền!");
				addActionMessage("Tự động đăng xuất để đăng nhập nhóm quyền phù hợp!");
				}
			return false;
		}
		session.put("title", title);
		return true;
	}
	
	public String getHk() {
		return hk;
	}

	public String getNk() {
		return nk;
	}

	public void setHk(String hk) {
		this.hk = hk;
	}

	public void setNk(String nk) {
		this.nk = nk;
	}

	public void setDsDiemHP(Map<hk_nk, List<sv_diem_hp>> dsDiemHP) {
		this.dsDiemHP = dsDiemHP;
	}

	public Map<hk_nk, List<sv_diem_hp>> getDsDiemHP() {
		return dsDiemHP;
	}

}
