package com.mystruts;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Map;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class LoginAction extends ActionSupport {
	
	private static final long serialVersionUID = 1L;
	private String username;
	private String password;
	private Connect conn;

	public String authenticate() {
		try {
			this.conn = new Connect();

			String sql = "SELECT count(*) as dem FROM users WHERE username = '"
					+ this.getUsername() + "' and password ='"
					+ this.getPassword() + "'";
			ResultSet rs = this.conn.excuteQuery(sql);

			Map<String, Object> session = ActionContext.getContext()
					.getSession();
			if (rs.next() && rs.getInt("dem") == 1) {
				if (!session.containsKey("logined")) {
					// Lay ngay thoi diem hien tai
					DateFormat dateFormat = new SimpleDateFormat(
							"dd/MM/yyyy HH:mm:ss");
					Calendar cal = Calendar.getInstance();
					// Tao ra mot danh sach kieu map de luu tru session
					// HttpSession session =
					// ServletActionContext.getRequest().getSession();
					// session.setAttribute("logined","true");
					// session.setAttribute("context", new Date());

					session.put("logined", "true");
					session.put("name", this.getUsername());
					session.put("time", dateFormat.format(cal.getTime()));
					addActionMessage("Đăng nhập thành công!");
				}
				rs.close();
				this.conn.Close();
				return "success";
			} else {
				addActionError("Tài khoản và mật khẩu không chính xác!");
				return "error";
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			return "switch";
		}
	}

	public String logout() {
		// HttpSession session = ServletActionContext.getRequest().getSession();
		// session.removeAttribute("logined");
		// session.removeAttribute("context");
		Map<String, Object> session = ActionContext.getContext().getSession();
		session.remove("logined");
		session.remove("name");
		session.remove("time");
		addActionMessage("Đăng xuất thành công!");
		return "success";
	}
	
	 public void validate() {
	        if (getUsername().length() <= 1) {
				addActionError("Tài khoản không hợp lệ!");
	        } 
	        
	        if (getPassword().length() <= 1) {
				addActionError("Mật khẩu không hợp lệ!");
	        }
	    }

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}
