package com.mystruts;
import java.sql.DriverManager;
import java.sql.SQLException;
import com.mysql.jdbc.Connection;

public class Connect {
	private Connection conn = null;
	private String hostname = "jdbc:mysql://localhost:3306/";
	private String database = "login_test";
	private String username = "testuser";
	private String password = "admin123";
	public Connect() {
		this.Create();
	}
	
	public void Create() {
		        try {
					Class.forName("com.mysql.jdbc.Driver");
				} catch (ClassNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		        try {
					this.conn = (Connection) DriverManager
							.getConnection(this.hostname+this.database, this.username, this.password);
				System.out.println("Kết nối thành công!");
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} 
	}
	
	public Connection getConn() {
		return conn;
	}
	
	public void Close(){
		try {
			this.conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
