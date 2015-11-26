package actions;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import connection.Connect;
import models.ke_hoach;

public class QLDVNTKAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNAction qlnAction = null;
	private boolean thongKeCCHV = false;
	private boolean thongKeBuocThoiHoc = false;
	private boolean thongKeNoHP = false;
	private boolean thongKeHB = false;
	private boolean thongKeKhenThuong = false;

	public QLDVNTKAction() {
	}
	
	public String execute(){
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.assignHKNKValues(this.session);
		}
		// Kiểm tra xem nêu ke hoach đã có thì khỏi tạo và ngược lại
		if (!session.containsKey("ke_hoach_thong_ke")) {
			System.out.println("Gán kế hoạch thống kê lần đầu lần đầu");
			this.assignKHThongKeValues(this.session);
		}
		
		if(!this.qlnAction.Prefix_Check("Trang chủ thống kê của đơn vị quản lý ngành",this.session))
			return ERROR;

		this.kt_tg_thong_ke(this.session);
		
		return SUCCESS;
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
	
	public void kt_tg_thong_ke(Map<String, Object> session) {
		ke_hoach kh = (ke_hoach) session.get("ke_hoach_thong_ke");
		String current_hk = session.get("current_hk").toString().trim();
		String current_nk = session.get("current_nk").toString().trim();
		// Kiểm tra học kỳ - niên khóa có phù hợp
		// Nếu không hợp mặc định không cho nhập
		if (!current_nk.equals(kh.getNk())) {
			System.out.println("nien khoa k Bằng nhau "+ kh.getNk());
			this.setThongKeBuocThoiHoc(false);
			this.setThongKeCCHV(false);
			this.setThongKeHB(false);
			this.setThongKeKhenThuong(false);
			this.setThongKeNoHP(false);
		}

		if (Integer.parseInt(current_hk) != kh.getHk()) {
			this.setThongKeBuocThoiHoc(false);
			this.setThongKeCCHV(false);
			this.setThongKeHB(false);
			this.setThongKeKhenThuong(false);
			this.setThongKeNoHP(false);
		}
		// Nếu là học kỳ hiện tại
		// Lấy ngày hiện tại
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		Calendar cal = Calendar.getInstance();
		try {
			Date current_Day = removeTime(dateFormat.parse(dateFormat.format(cal.getTime())));
			System.out.println("Ngày hien tai "+current_Day.toString());
			System.out.println("Ngày bat dau "+kh.getNgay_bd());
			System.out.println("Ngày ngay ket thuc "+kh.getNgay_kt());
			
			if ((current_Day.compareTo(kh.getNgay_bd()) == 0 
					|| current_Day.compareTo(kh.getNgay_kt()) == 0)) {
				System.out.println("Bằng nhau ");
				// Bằng nhau
				this.setThongKeBuocThoiHoc(false);
				this.setThongKeCCHV(false);
				this.setThongKeHB(false);
				this.setThongKeKhenThuong(false);
				this.setThongKeNoHP(false);
			}
			// So khớp ngày hiện tại khác khoảng bắt đầu và kết thúc.
			if (!(current_Day.compareTo(kh.getNgay_bd()) > 0 
					&& current_Day.compareTo(kh.getNgay_kt()) < 0)) {
				System.out.println("Khong phu hop ");
				// Không phù hợp
				this.setThongKeBuocThoiHoc(false);
				this.setThongKeCCHV(false);
				this.setThongKeHB(false);
				this.setThongKeKhenThuong(false);
				this.setThongKeNoHP(false);
			}

		} catch (Exception e) {
			e.printStackTrace();
			// Không phù hợp
			this.setThongKeBuocThoiHoc(false);
			this.setThongKeCCHV(false);
			this.setThongKeHB(false);
			this.setThongKeKhenThuong(false);
			this.setThongKeNoHP(false);
		}
		// Phù hợp
		if(Integer.parseInt(current_hk) == 1 || Integer.parseInt(current_hk) == 2){
			this.setThongKeBuocThoiHoc(true);
			this.setThongKeCCHV(true);
			this.setThongKeNoHP(true);
			this.setThongKeHB(true);
		}
		if(Integer.parseInt(current_hk) == 2){
			this.setThongKeKhenThuong(true);
		}
		if(Integer.parseInt(current_hk) == 3){
			this.setThongKeNoHP(true);
		}
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
	
	public void assignKHThongKeValues(Map<String, Object> session) {
		this.conn = new Connect();
		String procedure = "call get_tt_kh_thong_ke();";
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
		session.put("ke_hoach_thong_ke", khtk);
	}
	
	
	public boolean isThongKeBuocThoiHoc() {
		return thongKeBuocThoiHoc;
	}
	
	public boolean isThongKeCCHV() {
		return thongKeCCHV;
	}
	
	public boolean isThongKeHB() {
		return thongKeHB;
	}
	
	public boolean isThongKeKhenThuong() {
		return thongKeKhenThuong;
	}
	
	public boolean isThongKeNoHP() {
		return thongKeNoHP;
	}
	
	public void setThongKeBuocThoiHoc(boolean thongKeBuocThoiHoc) {
		this.thongKeBuocThoiHoc = thongKeBuocThoiHoc;
	}
	
	public void setThongKeCCHV(boolean thongKeCCHV) {
		this.thongKeCCHV = thongKeCCHV;
	}
	
	public void setThongKeHB(boolean thongKeHB) {
		this.thongKeHB = thongKeHB;
	}
	
	public void setThongKeKhenThuong(boolean thongKeKhenThuong) {
		this.thongKeKhenThuong = thongKeKhenThuong;
	}
	
	public void setThongKeNoHP(boolean thongKeNoHP) {
		this.thongKeNoHP = thongKeNoHP;
	}
}
