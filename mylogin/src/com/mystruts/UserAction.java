package com.mystruts;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionSupport;

public class UserAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private List<User> userList = new ArrayList<User>();
	private User user;
	private Connect conn;
	private Home home;

	public UserAction() {
		this.home = new Home();
	}

	public String list() {
		if (!this.home.checkLogin())
			return "login";
			return this.getUsersFromDB();
	}

	private String getUsersFromDB() {
		try {
			this.conn = new Connect();
			String sql = "SELECT * FROM users";
			ResultSet rs = this.conn.excuteQuery(sql);
			while (rs.next()) {
				// Hiển thị kết quả câu lệnh Select
				String username = rs.getString("username");
				String password = rs.getString("password");
				userList.add(this.user = new User(username, password));
			}// while
			rs.close();
			this.conn.Close();
			return "success";
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
	}

	public String add() {
		if (!this.home.checkLogin())
			return "login";
		try {
			this.conn = new Connect();
			String sql = "INSERT INTO users VALUES('" + this.user.getUsername()
					+ "','" + this.user.getPassword() + "')";
			this.conn.executeUpdate(sql);
			this.conn.Close();
			addActionMessage("Thêm mới người dùng thành công!");

			return this.getUsersFromDB();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			this.getUsersFromDB();
			addActionError("Thêm mới người dùng thất bại!");
			return "error";
		}
	}

	public String edit() {
		if (!this.home.checkLogin())
			return "login";
			try {
				this.conn = new Connect();
				String sql = "SELECT * FROM users WHERE username = '"
						+ user.getUsername() + "'";
				ResultSet rs = this.conn.excuteQuery(sql);
				if (rs.next()) {
					String username = rs.getString("username");
					String password = rs.getString("password");
					user = new User(username, password);
					rs.close();
					this.conn.Close();

					return "success";
				}

				rs.close();
				this.conn.Close();
				this.getUsersFromDB();

				return "error";
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();

				this.getUsersFromDB();
				return "error";
			}
	}

	public String editexecute() {
		if (!this.home.checkLogin())
			return "login";
		try {
			this.conn = new Connect();
			String sql = " UPDATE users SET password='" + user.getPassword()
					+ "' WHERE username='" + user.getUsername() + "'";
			this.conn.executeUpdate(sql);
			this.conn.Close();

			this.getUsersFromDB();
			addActionMessage("Sửa người dùng thành công!");

			return "success";
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

			addActionError("Sửa người dùng thất bại!");
			return "error";
		}
	}

	public String delete() {
		if (!this.home.checkLogin())
			return "login";
		try {
			this.conn = new Connect();
			String sql = "DELETE FROM users WHERE username ='"
					+ user.getUsername() + "'";
			this.conn.executeUpdate(sql);
			this.conn.Close();

			this.getUsersFromDB();
			addActionMessage("Xóa mới người dùng thành công!");

			return "success";
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

			this.getUsersFromDB();
			addActionError("Xóa người dùng thất bại!");
			return "error";
		}
	}

	public void setUser(User user) {
		this.user = user;
	}

	public void setUserList(List<User> userList) {
		this.userList = userList;
	}

	public User getUser() {
		return user;
	}

	public List<User> getUserList() {
		return userList;
	}
}
