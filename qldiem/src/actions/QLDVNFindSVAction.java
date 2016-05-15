package actions;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.ke_hoach;

public class QLDVNFindSVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNTKAction qlntkAction = null;
	private QLDVNAction qlnAction = null;
	private boolean nhapDiemNo = false;

	public QLDVNFindSVAction() {
	}

	public String execute() {
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		if (!this.qlnAction.Prefix_Check("Tìm sinh viên cần nhập điểm", this.session))
			return ERROR;
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		this.qlntkAction = new QLDVNTKAction();
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.qlntkAction.assignHKNKValues(this.session);
		}

		// Kiểm tra xem nêu ke hoach đã có thì khỏi tạo và ngược lại
		if (!session.containsKey("ke_hoach_nhap_diem_no")) {
			this.assignKHNhapDiemNoValues(this.session);
		}
		this.kt_tg_nhap_diem_no(this.session);

		return SUCCESS;
	}

	public void assignKHNhapDiemNoValues(Map<String, Object> session) {
		this.conn = new Connect();
		String procedure = "call get_tt_kh_nhap_diem_no();";
		ke_hoach khtk = new ke_hoach();
		try {
			ResultSet rs = this.conn.call_procedure(procedure);
			if (rs.next()) {
				khtk.setNk(rs.getString("NK"));
				khtk.setHk(rs.getInt("HK"));
				khtk.setLoai(rs.getInt("LOAI"));
				khtk.setNgay_bd(rs.getString("BD"));
				khtk.setNgay_kt(rs.getString("KT"));
			}
			// Đóng kết nối
			rs.close();
			this.conn.Close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// Thêm vào session
		session.put("ke_hoach_nhap_diem_no", khtk);
	}

	public void kt_tg_nhap_diem_no(Map<String, Object> session) {
		ke_hoach kh = (ke_hoach) session.get("ke_hoach_nhap_diem_no");
		String current_hk = session.get("current_hk").toString().trim();
		String current_nk = session.get("current_nk").toString().trim();
		// Kiểm tra học kỳ - niên khóa có phù hợp
		// Nếu không hợp mặc định không cho nhập
		if (!current_nk.equals(kh.getNk())) {
			this.setNhapDiemNo(false);
			return;
		}

		if (Integer.parseInt(current_hk) != kh.getHk()) {
			this.setNhapDiemNo(false);
			return;
		}
		// Nếu là học kỳ hiện tại
		// Lấy ngày hiện tại
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		Calendar cal = Calendar.getInstance();
		try {
			Date current_Day = removeTime(dateFormat.parse(dateFormat.format(cal.getTime())));

			if ((current_Day.compareTo(kh.getNgay_bd()) == 0 || current_Day.compareTo(kh.getNgay_kt()) == 0)) {
				// Bằng nhau
				this.setNhapDiemNo(true);
				return;
			}
			// So khớp ngày hiện tại khác khoảng bắt đầu và kết thúc.
			if (!(current_Day.compareTo(kh.getNgay_bd()) > 0 && current_Day.compareTo(kh.getNgay_kt()) < 0)) {
				System.out.println("Khong phu hop ");
				this.setNhapDiemNo(false);
				return;
			}

		} catch (Exception e) {
			e.printStackTrace();
			// Không phù hợp
			this.setNhapDiemNo(false);
			return;
		}
		// Phù hợp

		this.setNhapDiemNo(true);
		return;
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

	public boolean isNhapDiemNo() {
		return nhapDiemNo;
	}

	public void setNhapDiemNo(boolean nhapDiemNo) {
		this.nhapDiemNo = nhapDiemNo;
	}

}
