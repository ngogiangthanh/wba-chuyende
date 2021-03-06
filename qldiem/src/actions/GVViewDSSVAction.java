package actions;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import hash.base_64;
import models.ke_hoach;
import models.sv_hp;

public class GVViewDSSVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private String id_hp;
	private String ten_mh;
	private String ma_hp;
	private String hk;
	private String nk;
	private Map<String, Object> session = null;
	private GVAction gvAction = null;
	private ArrayList<sv_hp> dsSVHP = null;
	private boolean nhapDiem = false;
	// add new
	private String id_gv;

	public GVViewDSSVAction() {
	}

	public String getViewDSSVLopHP() {
		this.gvAction = new GVAction();
		this.session = ActionContext.getContext().getSession();
		if (!gvAction.Prefix_Check("Trang chủ xem danh sách sinh viên trong lớp học phần", this.session))
			return "error";

		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.gvAction.assignHKNKValues(this.session);
		}

		// Kiểm tra xem nêý ke hoach đã có thì khỏi tạo và ngược lại
		if (!session.containsKey("ke_hoach_nhap_diem")) {
			System.out.println("Gán kế hoạch nhập điểm lần đầu lần đầu");
			this.assignKHNhapDiemValues(this.session);
		}

		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_gv_day_hp_ds_sv(?,?,?,?);";
		CallableStatement pstmt = null;
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			// Gán tham số id_hp
			pstmt.setInt(1, Integer.parseInt(getId_hp()));
			// Gán tham số id gv
			setId_gv(infor_user.get("7_ID"));
			pstmt.setInt(2, Integer.parseInt(infor_user.get("7_ID")));
			// Gán tham số nk
			pstmt.setString(3, getNk());
			// Gán tham số hk
			pstmt.setInt(4, Integer.parseInt(getHk()));

			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int stt = 1;

			// Duyệt kết quả
			this.dsSVHP = new ArrayList<sv_hp>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					sv_hp sv = new sv_hp();
					sv.setStt(stt++);
					sv.setId_sv(rs.getInt("ID_SV"));
					sv.setId_hp(Integer.parseInt(getId_hp()));
					sv.setMssv(rs.getString("MSSV"));
					sv.setHo_ten(rs.getString("HO_TEN"));
					sv.setDiem_chu(rs.getString("DIEM_CHU"));
					sv.setDiem_10(rs.getFloat("DIEM_10"));
					sv.setDiem_4(rs.getFloat("DIEM_4"));
					sv.setCai_thien(rs.getString("CAI_THIEN"));
					setMa_hp(rs.getString("MA_HP"));

					this.dsSVHP.add(sv);
				}
			}
			this.nhapDiem = this.kt_tg_nhap_diem(this.session);
			// Đóng kết nối
			pstmt.close();
			rs.close();
			this.conn.Close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (this.dsSVHP.size() == 0) {
			addActionMessage("Lớp học phần không tồn tại!");
			return "null-ds";
		}

		return "view-dssvlophp";
	}

	public void validate() {
		try {
			System.out.println("Kiểm tra các biến!");
			int id_hp_check = Integer.parseInt(getId_hp());

			if (id_hp_check <= 0) {
				addActionError("Học phần không hợp lệ!");
			}

			base_64 decode_base_64 = new base_64();
			this.setTen_mh(getTen_mh().replaceAll(" ", "+"));
			decode_base_64.setBase_64_string_encode(getTen_mh());
			if (getTen_mh() == "" | !decode_base_64.decode()) {
				addActionError("Tên học phần không chính xác!");
			}
			System.out.println("Tên hp base 64 " + getTen_mh());
			setTen_mh(decode_base_64.getBase_64_string_decode());

			if (getHk() == "") {
				addActionError("Học kỳ không hợp lệ!");
			}

			if (getNk() == "" | getNk() == "0") {
				addActionError("Niên khóa không hợp lệ!");
			}

			this.session = ActionContext.getContext().getSession();
			Map<String, ArrayList<Integer>> hknk = (Map<String, ArrayList<Integer>>) session.get("hknk");
			if (!hknk.containsKey(getNk())) {
				addActionError("Niên khóa không hợp lệ!");
			} else {
				ArrayList<Integer> list_hk = hknk.get(getNk());
				int hk_int = Integer.parseInt(getHk());
				if (list_hk == null | !list_hk.contains(hk_int)) {
					addActionError("Học kỳ không hợp lệ!");
				}
			}

		} catch (Exception ex) {
			System.out.println("Lỗi kiểm tra các biến!");
			addActionError("Truy cập vào đường dẫn không hợp lệ!");
			ex.printStackTrace();
		}
	}

	public boolean kt_tg_nhap_diem(Map<String, Object> session) {
		ke_hoach kh = (ke_hoach) session.get("ke_hoach_nhap_diem");
		// Kiểm tra học kỳ - niên khóa có phù hợp
		// Nếu không hợp mặc định không cho nhập
		if (!getNk().equals(kh.getNk())) {
			return false;
		}

		if (Integer.parseInt(getHk()) != kh.getHk()) {
			return false;
		}
		// Nếu là học kỳ hiện tại
		// Lấy ngày hiện tại
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		Calendar cal = Calendar.getInstance();
		try {
			Date current_Day = dateFormat.parse(dateFormat.format(cal.getTime()));
			System.out.println(current_Day.toString());

			if ((current_Day.compareTo(kh.getNgay_bd()) == 0 || current_Day.compareTo(kh.getNgay_kt()) == 0)) {
				System.out.println("Bằng nhau ");
				// Bằng nhau
				return true;
			}

			// So khớp ngày hiện tại khác khoảng bắt đầu và kết thúc.
			if (!(current_Day.compareTo(kh.getNgay_bd()) > 0 && current_Day.compareTo(kh.getNgay_kt()) < 0)) {
				// Không phù hợp
				return false;
			}

		} catch (Exception e) {
			e.printStackTrace();
			// Không phù hợp
			return false;
		}
		// Phù hợp
		return true;
	}

	public Date removeTime(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		return cal.getTime();
	}

	public void assignKHNhapDiemValues(Map<String, Object> session) {
		this.conn = new Connect();
		String procedure = "call get_tt_kh_nhap_diem();";
		ke_hoach khnd = new ke_hoach();
		try {
			ResultSet rs = this.conn.call_procedure(procedure);
			if (rs.next()) {
				khnd.setNk(rs.getString("NK"));
				khnd.setHk(rs.getInt("HK"));
				khnd.setLoai(rs.getInt("LOAI"));
				khnd.setNgay_bd(rs.getString("BD"));
				khnd.setNgay_kt(rs.getString("KT"));
			}
			// Đóng kết nối
			rs.close();
			this.conn.Close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// Thêm vào session
		session.put("ke_hoach_nhap_diem", khnd);
	}

	public boolean isNhapDiem() {
		return nhapDiem;
	}

	public String getMa_hp() {
		return ma_hp;
	}

	public String getHk() {
		return hk;
	}

	public String getNk() {
		return nk;
	}

	public String getId_hp() {
		return id_hp;
	}

	public ArrayList<sv_hp> getDsSVHP() {
		return dsSVHP;
	}

	public String getTen_mh() {
		return ten_mh;
	}

	public String getId_gv() {
		return id_gv;
	}

	public void setId_hp(String id_hp) {
		this.id_hp = id_hp;
	}

	public void setDsSVHP(ArrayList<sv_hp> dsSVHP) {
		this.dsSVHP = dsSVHP;
	}

	public void setTen_mh(String ten_mh) {
		this.ten_mh = ten_mh;
	}

	public void setNk(String nk) {
		this.nk = nk;
	}

	public void setHk(String hk) {
		this.hk = hk;
	}

	public void setMa_hp(String ma_hp) {
		this.ma_hp = ma_hp;
	}

	public void setNhapDiem(boolean nhapDiem) {
		this.nhapDiem = nhapDiem;
	}

	public void setId_gv(String id_gv) {
		this.id_gv = id_gv;
	}
}
