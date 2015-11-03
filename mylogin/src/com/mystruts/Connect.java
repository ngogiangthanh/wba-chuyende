package com.mystruts;

import java.sql.DriverManager;
import java.sql.SQLException;
import com.mysql.jdbc.Connection;
import com.mysql.jdbc.ResultSet;
import com.mysql.jdbc.Statement;

public class Connect {
	private Connection conn = null;
	private String hostname = "jdbc:mysql://localhost:3306/";
	private String database = "login_test";
	private String username = "morte";
	private String password = "morte";
	private Statement stmt = null;

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
			this.conn = (Connection) DriverManager.getConnection(this.hostname
					+ this.database, this.username, this.password);
			System.out.println("Kết nối thành công!");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public Connection getConn() {
		return this.conn;
	}

	public ResultSet excuteQuery(String sql) throws SQLException {
		this.stmt = (Statement) this.conn.createStatement();
		ResultSet rs = (ResultSet) this.stmt.executeQuery(sql);
		//this.stmt.close();
		return rs;
	}

	public int executeUpdate(String sql) throws SQLException {
		this.stmt = (Statement) this.conn.createStatement();
		// Returns: either (1) the row count for SQL Data Manipulation Language
		// (DML) statements or (2) 0 for SQL statements that return nothing
		//An int that indicates the number of rows affected, or 0 if using a DDL statement.
		int results = this.stmt.executeUpdate(sql);
		//this.stmt.close();
		return results;
	}

	public void Close() {
		try {
			this.stmt.close();
			this.conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
