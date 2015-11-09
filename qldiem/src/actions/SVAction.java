package actions;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.sv_diem_hp;

public class SVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private String hk;
	private String nk;
	private Map<Integer, sv_diem_hp> dsDiemHP = new TreeMap<Integer, sv_diem_hp>();
	
	public SVAction() {
	}
	
	public String getIndex(){
		return "index";
	}
	
	public String getViewProfile(){
		//Sử dụng lại session thông tin về người dùng đã đăng nhập
		Map<String, Object> session = ActionContext.getContext().getSession();
		session.put("title", "Xem thông tin sinh viên");
		return "view-profile";
	}
	
	public String getViewMark(){
		//Lấy thông tin học kỳ niên khóa trong CSDL bỏ vào session tên hknk kiểu map <key=2014-2015,value=List<1,2,3>
		Map<String, Object> session = ActionContext.getContext().getSession();
		if(!session.containsKey("hknk"))
		{
			System.out.println("Gán hknk lần đầu");
			this.assignHKNKValues(session);
		}
		

		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_sv_diem_hp(?,?,?);";
		CallableStatement pstmt = null;
		
		try {
			pstmt = (CallableStatement ) this.conn.getConn().prepareCall(procedure);
		    pstmt.setString(3, infor_user.get("9_ID"));
		    if(this.getNk().equals("0"))
		    	pstmt.setNull(1, java.sql.Types.CHAR);
		    else
		    	pstmt.setString(1, getNk());
		    
		    if(this.getHk().equals("0"))
			    pstmt.setNull(2, java.sql.Types.TINYINT);
		    else
		    	pstmt.setInt(2, Integer.parseInt(getHk()));
		    
		    pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int stt = 1;
			while(rs.next()){
				if(!rs.wasNull()){
				sv_diem_hp hp = new sv_diem_hp();
				hp.setMaMH(rs.getString("MA_MH"));
				hp.setTenHP(rs.getString("TEN_MH"));
				hp.setHpDieuKien(rs.getString("DIEU_KIEN"));
				hp.setMaHP(rs.getString("MA_HP"));
				hp.setSoTC(rs.getInt("SO_TC"));
				hp.setDiemChu(rs.getString("DIEM_CHU"));
				hp.setDiem10(rs.getFloat("DIEM_10"));
				hp.setTichLuy(rs.getString("TL"));
				hp.setCaiThien(rs.getString("CAI_THIEN"));
				
				this.dsDiemHP.put(stt++, hp);
				}
			}
			
			rs.close();
			this.conn.Close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		session.put("title", "Xem kết quả học tập");
		return "view-mark";
	}
	
	public void assignHKNKValues(Map<String, Object> session){
		this.conn = new Connect();
		String procedure = "call get_tt_hk_nk();";
		Map<String, List<Integer>> hknk = new HashMap<String, List<Integer>>();
		int first = 1;
		try {
			ResultSet rs = this.conn.call_procedure(procedure);
			while(rs.next()){
				String nk = rs.getString("NK");
				List<Integer> list_hk;
				if(hknk.containsKey(nk)){
					//Thêm cũ
					System.out.println("Thêm cũ hknk");
					list_hk = hknk.get(nk);
				}
				else{
					//Thêm mới
					System.out.println("Thêm mới hknk");
					list_hk = new ArrayList<Integer>();
				}
				Integer hk = rs.getInt("HK");
				list_hk.add(hk);
				hknk.put(nk,list_hk);
				
				if(first == 1){
					session.put("current_hk", hk);
					session.put("current_nk", nk);
					this.setHk(hk+"");
					this.setNk(nk);
					first++;
				}
			}
			rs.close();
			this.conn.Close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		session.put("hknk", hknk);
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
	
	public void setDsDiemHP(Map<Integer, sv_diem_hp> dsDiemHP) {
		this.dsDiemHP = dsDiemHP;
	}
	
	public Map<Integer, sv_diem_hp> getDsDiemHP() {
		return dsDiemHP;
	}
}
