package actions;

import java.util.ArrayList;
import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import connection.Connect;
import models.sv_khen_thuong;

public class QLDVNTKKhenThuongAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNTKAction qlntkAction = null;
	private QLDVNAction qlnAction = null;
	private ArrayList<sv_khen_thuong> dsSVNhanKhenThuong = null;
	private String tenKhoa = null;

	public QLDVNTKKhenThuongAction() {
	}
	
	public String execute(){
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		this.qlntkAction = new QLDVNTKAction();
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.qlntkAction.assignHKNKValues(this.session);
		}
		
		if(!this.qlnAction.Prefix_Check("Thống kê danh sách sinh viên được khen thưởng",this.session))
			return ERROR;
		
		this.assignDSSVKhenThuong(this.session);
		return SUCCESS;
	}
	
	public void assignDSSVKhenThuong(Map<String, Object> session){
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_ds_sv_khen_thuong(?,?);";
		CallableStatement pstmt = null;
		if(Integer.parseInt(session.get("current_hk").toString()) == 2){
			System.out.println("HOC KI 2");
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			//
			pstmt.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			pstmt.setString(2, session.get("current_nk").toString());
			setTenKhoa(infor_user.get("6_KHOA"));
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			// Duyệt kết quả ds sv
			this.dsSVNhanKhenThuong = new ArrayList<sv_khen_thuong>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					sv_khen_thuong sv = new sv_khen_thuong();
					sv.setStt(0);
					sv.setMssv(rs.getString("MSSV"));
					sv.setHo_ten(rs.getString("HO_TEN"));
					sv.setNgay_sinh(rs.getString("NGAY_SINH"));
					sv.setGioi_tinh((rs.getString("GIOI_TINH").equals("0")) ? "Nam" : "Nữ");
					sv.setLop(rs.getString("MA_LOP"));
					sv.setTen_lop(rs.getString("TEN_LOP"));
					sv.setChuyen_nganh(rs.getString("CHUYEN_NGANH"));
					sv.setDtb(rs.getFloat("DTBCN"));
					//
					this.dsSVNhanKhenThuong.add(sv);
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
	}
	
	public ArrayList<sv_khen_thuong> getDsSVNhanKhenThuong() {
		return dsSVNhanKhenThuong;
	}
	
	public String getTenKhoa() {
		return tenKhoa;
	}
	
	public void setDsSVNhanKhenThuong(ArrayList<sv_khen_thuong> dsSVNhanKhenThuong) {
		this.dsSVNhanKhenThuong = dsSVNhanKhenThuong;
	}
	
	public void setTenKhoa(String tenKhoa) {
		this.tenKhoa = tenKhoa;
	}
}
