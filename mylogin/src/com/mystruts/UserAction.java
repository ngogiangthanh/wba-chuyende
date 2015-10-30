package com.mystruts;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import com.mysql.jdbc.ResultSet;
import com.mysql.jdbc.Statement;
import com.opensymphony.xwork2.ActionSupport;

public class UserAction extends ActionSupport {

	private static final long serialVersionUID = -8366209797454396351L;
	private List<User> userList = new ArrayList<User>();
	private User user;
	private Connect conn;

	public String list() {
		return this.getUsersFromDB();
	}
	
	private String getUsersFromDB(){
		try {
			Statement stmt = null;
			this.conn = new Connect();
			stmt = (Statement) this.conn.getConn().createStatement();	
			String sql;
			sql = "SELECT * FROM users";
			ResultSet rs = (ResultSet) stmt.executeQuery(sql);
			while(rs.next()){
				//Hiển thị kết quả câu lệnh Select
				String username = rs.getString("username");
				String password = rs.getString("password");
				userList.add(this.user = new User(username, password));
				}//while

			rs.close();
			stmt.close();
			this.conn.Close();

			return "success";
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
	}

	public String add() {
		try {
			Statement stmt = null;
			this.conn = new Connect();
			stmt = (Statement) this.conn.getConn().createStatement();	
			String sql;
			sql = "INSERT INTO users VALUES('"+this.user.getUsername()+"','"+this.user.getPassword()+"')";
			stmt.executeUpdate(sql);
			stmt.close();
			this.conn.Close();
			addActionMessage("Thêm mới người dùng thành công!");
			
			return this.getUsersFromDB();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			addActionError("Thêm mới người dùng thất bại!");
			e.printStackTrace();
			this.getUsersFromDB();
			return "error";
		}
	}

	public String edit(){
		try {
			Statement stmt = null;
			this.conn = new Connect();
			stmt = (Statement) this.conn.getConn().createStatement();	
			String sql;
			sql = "SELECT * FROM users WHERE username = '"
					+ user.getUsername() + "'";
			ResultSet rs = (ResultSet) stmt.executeQuery(sql);
			if (rs.next()) {
				String username = rs.getString("username");
				String password = rs.getString("password");
				user = new User(username, password);
				rs.close();
				stmt.close();
				this.conn.Close();
				
				return "success";
			}

			rs.close();
			stmt.close();
			this.conn.Close();
			
			this.getUsersFromDB();
		
			return "error";
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			this.getUsersFromDB();
			e.printStackTrace();
			this.getUsersFromDB();
			return "error";
		}
	}
	
	public String editexecute(){
		try {
			Statement stmt = null;
			this.conn = new Connect();
			stmt = (Statement) this.conn.getConn().createStatement();	
			String sql;
			sql = " UPDATE users SET password='"+user.getPassword()+"' WHERE username='"
					+ user.getUsername() + "'";
			stmt.executeUpdate(sql);
			stmt.close();
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
	
	public String delete(){
		try {
			Statement stmt = null;
			this.conn = new Connect();
			stmt = (Statement) this.conn.getConn().createStatement();	
			String sql;
			sql = "DELETE FROM users WHERE username ='"+user.getUsername()+"'";
			stmt.executeUpdate(sql);
			stmt.close();
			this.conn.Close();
			addActionMessage("Xóa mới người dùng thành công!");
			
			return this.getUsersFromDB();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			addActionError("Xóa người dùng thất bại!");
			e.printStackTrace();
			this.getUsersFromDB();
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
