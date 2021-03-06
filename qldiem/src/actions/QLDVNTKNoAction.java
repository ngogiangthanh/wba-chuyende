package actions;

import java.util.ArrayList;
import java.util.Map;
import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import connection.Connect;
import models.sv_no_hp;
import models.tk_theo_diem;

public class QLDVNTKNoAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNTKAction qlntkAction = null;
	private QLDVNAction qlnAction = null;
	private ArrayList<sv_no_hp> dsSVNoHp = null;
	private ArrayList<tk_theo_diem> dsTSSVNo = null;
	private String tenKhoa;
	private int tsDiem = 0;

	public QLDVNTKNoAction() {
	}

	public String execute() {
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		if (!this.qlnAction.Prefix_Check("Thống kê danh sách sinh viên nợ học phần", this.session))
			return ERROR;
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		this.qlntkAction = new QLDVNTKAction();
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.qlntkAction.assignHKNKValues(this.session);
		}
		this.assignDSSVNoHp(this.session);
		if(this.dsSVNoHp.size() > 0)
			this.assignTSSVNo(this.session);

		return SUCCESS;
	}

	public void assignDSSVNoHp(Map<String, Object> session) {
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_sv_no_hp(?,?,?);";
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
			this.dsSVNoHp = new ArrayList<sv_no_hp>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					sv_no_hp sv = new sv_no_hp();
					sv.setStt(stt++);
					sv.setMssv(rs.getString("MSSV"));
					sv.setHo_ten(rs.getString("HO_TEN"));
					sv.setLop(rs.getString("LOP"));
					sv.setTen_lop(rs.getString("TEN_LOP"));
					sv.setTen_mh(rs.getString("TEN_MH"));
					sv.setMa_hp(rs.getString("MA_HP"));
					sv.setDiem_chu(rs.getString("DIEM_CHU"));

					this.dsSVNoHp.add(sv);
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
	
	public void assignTSSVNo(Map<String, Object> session) {
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_qldvn_tk_sv_no_hp(?,?,?);";
		CallableStatement pstmt = null;

		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			pstmt.setInt(1, Integer.parseInt(infor_user.get("8_ID_KHOA")));
			pstmt.setInt(2, Integer.parseInt(session.get("current_hk").toString()));
			pstmt.setString(3, session.get("current_nk").toString());
			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();

			// Duyệt kết quả
			this.dsTSSVNo = new ArrayList<tk_theo_diem>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					tk_theo_diem sv = new tk_theo_diem();
					sv.setDiem_chu(rs.getString("DIEM_CHU"));
					sv.setSo_diem(rs.getInt("SO_DIEM"));
					this.addTsDiem(rs.getInt("SO_DIEM"));
					this.dsTSSVNo.add(sv);
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
	
	public int getTsDiem() {
		return tsDiem;
	}

	public String getTenKhoa() {
		return tenKhoa;
	}
	
	public ArrayList<tk_theo_diem> getDsTSSVNo() {
		return dsTSSVNo;
	}

	public ArrayList<sv_no_hp> getDsSVNoHp() {
		return dsSVNoHp;
	}

	public void setDsSVNoHp(ArrayList<sv_no_hp> dsSVNoHp) {
		this.dsSVNoHp = dsSVNoHp;
	}

	public void setTenKhoa(String tenKhoa) {
		this.tenKhoa = tenKhoa;
	}
	
	public void setDsTSSVNo(ArrayList<tk_theo_diem> dsTSSVNo) {
		this.dsTSSVNo = dsTSSVNo;
	}
	
	public void setTsDiem(int tsDiem) {
		this.tsDiem = tsDiem;
	}
	
	public void addTsDiem(int so_diem){
		this.tsDiem += so_diem;
	}
}

