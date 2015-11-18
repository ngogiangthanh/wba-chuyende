package actions;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.lop_cv;
import models.sv_hp;

public class CVHTViewLopCVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;
	private GVAction gvAction = null;
	private ArrayList<lop_cv> dsLopCV = null;
	private Connect conn;

	public CVHTViewLopCVAction() {
	}
	
	public String execute(){
		this.gvAction = new GVAction();
		this.session = ActionContext.getContext().getSession();
		if (!gvAction.Prefix_Check("Trang chủ xem danh sách các lớp cố vấn", this.session))
			return ERROR;
		
		this.conn = new Connect();
		Map<String, String> infor_user = (Map<String, String>) session.get("information");
		String procedure = "call get_tt_cvht_lop_cv(?);";
		CallableStatement pstmt = null;
		
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			pstmt.setInt(1, Integer.parseInt(infor_user.get("7_ID")));
			

			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int stt = 1;

			// Duyệt kết quả
			this.dsLopCV = new ArrayList<lop_cv>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					lop_cv lop = new lop_cv();
					lop.setStt(stt++);
					lop.setLop(rs.getString("LOP"));
					lop.setTen_lop(rs.getString("TEN_LOP"));
					
					this.dsLopCV.add(lop);
				}
			}
			
			// Đóng kết nối
			pstmt.close();
			rs.close();
			this.conn.Close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return SUCCESS;
	}
	
	public ArrayList<lop_cv> getDsLopCV() {
		return dsLopCV;
	}
	
	public void setDsLopCV(ArrayList<lop_cv> dsLopCV) {
		this.dsLopCV = dsLopCV;
	}
}