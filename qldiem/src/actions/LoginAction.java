package actions;

import java.sql.ResultSetMetaData;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import hash.md5;
import models.role;

public class LoginAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private String username;
	private String password;
	private Connect conn;
	private md5 hash;
	private String pageDirect = null;

	public LoginAction() {
	}

	public String login() {
		try {
			Map<String, Object> session = ActionContext.getContext().getSession();

			Home home = new Home();
			if (home.isLogin(session)) {
				String result = home.getIndex();
				this.setPageDirect(home.getPageDirect());
				System.out.println("Không phải login lại! " + result);
				return result;
			}

			this.conn = new Connect();
			hash = new md5(this.getPassword());
			hash.generator();

			String procedure = "call authenticating('" + this.getUsername() + "','" + hash.getMd5_string_result()
					+ "');";
			ResultSet rs = this.conn.call_procedure(procedure);
			if (rs.next()) {
				DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
				Calendar cal = Calendar.getInstance();
				long id_cb = rs.getInt("ID_CB");
				if (!rs.wasNull()) {
					// Lấy thông tin cán bộ đăng nhập
					procedure = "call get_tt_cb_login(" + id_cb + ");";
				} else {
					// Lấy thông tin sinh viên đăng nhập
					long id_sv = rs.getInt("ID_SV");
					procedure = "call get_tt_sv_login(" + id_sv + ");";
				}

				ResultSet information = this.conn.call_procedure(procedure);
				Map<String, String> infor_user = new TreeMap<String, String>();
				ResultSetMetaData meta = information.getMetaData();

				if (information.next()) {
					int columns = meta.getColumnCount();
					for (int i = 1; i <= columns; i++) {
						String key = meta.getColumnName(i);
						String value = information.getString(key);
						infor_user.put(key, value);
					}
				}

				session.put("information", infor_user);

				String[] rl = rs.getString("ROLE").split(",");

				Map<String, role> infor_roles = new HashMap<String, role>();

				for (int i = 0; i < rl.length; i++)
					infor_roles.put(Home.roles[Integer.parseInt(rl[i])],
							new role(Home.names[Integer.parseInt(rl[i])], Home.indexes[Integer.parseInt(rl[i])]));

				session.put("logined", "true");
				session.put("roles", infor_roles);
				session.put("username", this.getUsername());
				session.put("time", dateFormat.format(cal.getTime()));
				session.put("title", "");

				addActionMessage("Đăng nhập thành công!");
				rs.close();
				this.conn.Close();
				System.out.println("Phải login lại!");

				if (rl.length == 1) {
					setPageDirect(Home.indexes[Integer.parseInt(rl[0])]);
					return "directing_page";
				} else
					return "welcome";
			} else {
				addActionError("Tài khoản hoặc mật khẩu không chính xác!");
				return "error";
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			return "error";
		}
	}

	public void validate() {
		try {
			System.out.println("Kiểm tra các biến!");
			if (getUsername().length() <= 0 | getUsername().length() > 8) {
				addActionError("Tài khoản không chính xác!");
			}

			if (getPassword().length() <= 0) {
				addActionError("Mật khẩu không chính xác!");
			}
		} catch (Exception ex) {
			System.out.println("Lỗi kiểm tra các biến!");
			ex.printStackTrace();
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

	public String getPageDirect() {
		return pageDirect;
	}

	public void setPageDirect(String pageDirect) {
		this.pageDirect = pageDirect;
	}
}
