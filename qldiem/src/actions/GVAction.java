package actions;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import hash.base_64;
import models.hp_giang_day;

public class GVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private String hk;
	private String nk;
	private ArrayList<hp_giang_day> dsHPDay = null;
	private Map<String, Object> session = null;

	public GVAction() {
	}

	public String getIndex() {
		this.session = ActionContext.getContext().getSession();
		if (!Prefix_Check("Trang chủ giảng viên", this.session))
			return "error";
		return "index";
	}

	public String getViewLopHP() {
		this.session = ActionContext.getContext().getSession();
		if (!Prefix_Check("Trang chủ xem danh sách học phần giảng dạy theo học kỳ niên khóa", this.session))
			return "error";
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.assignHKNKValues(this.session);
		}

		// Kiểm tra xem năm chọn có mở chưa, nếu chưa mở thì báo học kỳ chưa mở
		// không thực hiện các bước phía dưới
		if (!this.isOpenHKNK()) {
			System.out.println("Học kỳ chưa mở " + this.getHk() + " - " + this.getNk());
			return "view-lophp";
		}

		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_gv_day_hp(?,?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);

			// Gán tham số id cb
			pstmt.setInt(3, Integer.parseInt(infor_user.get("7_ID")));
			// Gán tham số năm học (niên khóa)
			if (this.getNk() == null) {
				// Trường hợp chưa chọn hoặc resend lại thì mặc định chọn niên
				// khóa hiện tại
				this.setNk(session.get("current_nk").toString());
				pstmt.setString(1, getNk());
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
			} else {
				// Trường hợp xem một học kỳ nào đó
				pstmt.setInt(2, Integer.parseInt(getHk()));
			}

			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			base_64 hash_base_64 = new base_64();
			int stt = 1;

			// Duyệt kết quả
			this.dsHPDay = new ArrayList<hp_giang_day>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					hp_giang_day hp_gd = new hp_giang_day();
					hp_gd.setStt(stt++);
					hp_gd.setId_mh(rs.getInt("ID_MH"));
					hp_gd.setId_hp(rs.getInt("ID_HP"));
					hp_gd.setMa_mh(rs.getString("MA_MH"));
					hp_gd.setMa_hp(rs.getString("MA_HP"));
					hp_gd.setTen_mh(rs.getString("TEN_MH"));
					hp_gd.setSo_tc(rs.getInt("SO_TC"));
					hp_gd.setLthuyet(rs.getInt("LT"));
					hp_gd.setTh(rs.getInt("TH"));

					hash_base_64.setBase_64_string_input(rs.getString("TEN_MH"));
					hash_base_64.encode();
					hp_gd.setTen_mh_base_64(hash_base_64.getBase_64_string_encode());

					this.dsHPDay.add(hp_gd);
				}
			}
			// Đóng kết nối
			rs.close();
			this.conn.Close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return "view-lophp";
	}

	public boolean Prefix_Check(String title, Map<String, Object> session) {
		if (!Home.isRole(session, 1)) {
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

	public boolean isOpenHKNK() {
		this.session = ActionContext.getContext().getSession();
		Map<String, ArrayList<Integer>> hknk = (Map<String, ArrayList<Integer>>) session.get("hknk");
		// Kiểm tra xem học kì người dùng chọn có trong session hknk không? nếu
		// có thì kết luật là hk có mở và ngược lại
		if (hknk.containsKey(this.getNk())) {
			ArrayList<Integer> list_hk = hknk.get(this.getNk());
			return list_hk.contains(Integer.parseInt(this.getHk()));
		}
		return true;
	}

	public String getNk() {
		return nk;
	}

	public String getHk() {
		return hk;
	}

	public ArrayList<hp_giang_day> getDsHPDay() {
		return dsHPDay;
	}

	public void setHk(String hk) {
		this.hk = hk;
	}

	public void setNk(String nk) {
		this.nk = nk;
	}

	public void setDsHPDay(ArrayList<hp_giang_day> dsHPDay) {
		this.dsHPDay = dsHPDay;
	}
}
