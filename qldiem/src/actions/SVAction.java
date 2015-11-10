package actions;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.interceptor.ServletRequestAware;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.hk_nk;
import models.sv_diem_hp;

public class SVAction extends ActionSupport implements ServletRequestAware{

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private String hk;
	private String nk;
	private Map<hk_nk, List<sv_diem_hp>> dsDiemHP = new LinkedHashMap<hk_nk, List<sv_diem_hp>>();
	private HttpServletRequest httpRequest;
	
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
		session.put("title", "Xem kết quả học tập");
		if(!session.containsKey("hknk"))
		{
			System.out.println("Gán hknk lần đầu");
			this.assignHKNKValues(session);
		}
		//Kiểm tra xem năm chọn có mở chưa, nếu chưa mở thì báo học kỳ chưa mở không thực hiện các bước phía dưới
		if(!this.isOpenHKNK(session)){
			System.out.println("hknk k ton tai " + this.getHk() +" - "+ this.getNk());
			return "view-mark";
		}
		
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_sv_diem_hp(?,?,?);";
		CallableStatement pstmt = null;
		
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
		    pstmt.setString(3, infor_user.get("9_ID"));
		    if(this.getNk() == null){
				this.setNk(session.get("current_nk").toString());
		    	pstmt.setString(1, getNk());
		    }
		    else if(this.getNk().equals("0"))
		    	pstmt.setNull(1, java.sql.Types.CHAR);
		    else
		    	pstmt.setString(1, getNk());
		    
		    if(this.getHk() == null){
				this.setHk(session.get("current_hk").toString());
		    	pstmt.setInt(2, Integer.parseInt(getHk()));
		    }
		    else if(this.getHk().equals("0"))
			    pstmt.setNull(2, java.sql.Types.TINYINT);
		    else
		    	pstmt.setInt(2, Integer.parseInt(getHk()));
		    
		    pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int stt = 1;
			while(rs.next()){
				if(!rs.wasNull()){
					hk_nk key_hknk = new hk_nk(rs.getString("NK"),rs.getInt("HK"));
					List<sv_diem_hp> list_ds_diem_hp;
					System.out.println("Học ki hien tai: "+ key_hknk.getHk() + "- " + key_hknk.getNk());
					if(this.dsDiemHP.containsKey(key_hknk)){
						//Trường hợp thêm cũ
						System.out.println("Đã tồn tại thêm cũ "+ key_hknk.getHk() + "- " + key_hknk.getNk());
						list_ds_diem_hp = this.dsDiemHP.get(key_hknk);
					}
					else{
						//Trường hợp thêm mới
						System.out.println("Chưa tồn tại thêm mới");
						list_ds_diem_hp = new ArrayList<>();
						//Reset stt lại 1;
						stt = 1;
					}
					
					sv_diem_hp hp = new sv_diem_hp();
					hp.setStt(stt++);
					hp.setMaMH(rs.getString("MA_MH"));
					hp.setTenHP(rs.getString("TEN_MH"));
					hp.setHpDieuKien(rs.getString("DIEU_KIEN"));
					hp.setMaHP(rs.getString("MA_HP"));
					hp.setSoTC(rs.getInt("SO_TC"));
					hp.setDiemChu(rs.getString("DIEM_CHU"));
					hp.setDiem10(rs.getFloat("DIEM_10"));
					hp.setTichLuy(rs.getString("TL"));
					hp.setCaiThien(rs.getString("CAI_THIEN"));
					
					list_ds_diem_hp.add(hp);
					this.dsDiemHP.put(key_hknk, list_ds_diem_hp);
					}
			}

			rs.close();
			this.conn.Close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "view-mark";
	}
	
	public boolean isOpenHKNK(Map<String, Object> session){
		Map<String, ArrayList<Integer>> hknk = (Map<String, ArrayList<Integer>>) session.get("hknk");
		if(this.getNk() != "0" & hknk.containsKey(this.getNk())){
			if(!this.getHk().equals("0")){
				ArrayList<Integer> list_hk = hknk.get(this.getNk());
				return list_hk.contains(Integer.parseInt(this.getHk()));
			}
		}
		return true;
	}
	
	public void assignHKNKValues(Map<String, Object> session){
		this.conn = new Connect();
		String procedure = "call get_tt_hk_nk();";
		Map<String, ArrayList<Integer>> hknk = new HashMap<String, ArrayList<Integer>>();
		int first = 1;
		try {
			ResultSet rs = this.conn.call_procedure(procedure);
			while(rs.next()){
				String nk = rs.getString("NK");
				ArrayList<Integer> list_hk;
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
	
	public void setDsDiemHP(Map<hk_nk, List<sv_diem_hp>> dsDiemHP) {
		this.dsDiemHP = dsDiemHP;
	}
	
	public Map<hk_nk, List<sv_diem_hp>> getDsDiemHP() {
		return dsDiemHP;
	}

	@Override
	public void setServletRequest(HttpServletRequest request) {
		this.httpRequest = request;
		
	}
}
