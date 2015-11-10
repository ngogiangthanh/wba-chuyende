package connection;

import java.sql.DriverManager;
import java.sql.SQLException;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.Connection;
import com.mysql.jdbc.ResultSet;
import com.mysql.jdbc.Statement;

public class Connect {
	private Connection conn = null;
	private String hostname = "jdbc:mysql://localhost:3306/";
	private String database = "qldiem";
	private String username = "morte";
	private String password = "morte";
	// private Statement stmt = null;

	public Connect() {
		this.Create();
	}

	public void Create() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			System.out.println("Không tìm thấy jdbc Driver!");
			e.printStackTrace();
		}
		try {
			this.conn = (Connection) DriverManager.getConnection(this.hostname + this.database, this.username,
					this.password);
			System.out.println("Kết nối thành công đến Server MySQL!");
		} catch (SQLException e) {
			System.out.println("Kết nối đến Server MySQL thất bại!");
			e.printStackTrace();
		}
	}

	public Connection getConn() {
		return this.conn;
	}

	public ResultSet excuteQuery(String sql) throws SQLException {
		Statement stmt = (Statement) this.conn.createStatement();
		ResultSet rs = (ResultSet) stmt.executeQuery(sql);
		// this.stmt.close();
		return rs;
	}

	public int executeUpdate(String sql) throws SQLException {
		Statement stmt = (Statement) this.conn.createStatement();
		// Returns: either (1) the row count for SQL Data Manipulation Language
		// (DML) statements or (2) 0 for SQL statements that return nothing
		// An int that indicates the number of rows affected, or 0 if using a
		// DDL statement.
		int results = stmt.executeUpdate(sql);
		// this.stmt.close();
		return results;
	}

	public ResultSet call_procedure(String name_procedure) throws SQLException {
		CallableStatement cs = (CallableStatement) this.conn.prepareCall(name_procedure);
		cs.execute();
		return (ResultSet) cs.getResultSet();
	}

	public void Close() {
		try {
			// this.stmt.close();
			this.conn.close();
			System.out.println("Đóng kết nối thành công Server MySQL!");
		} catch (SQLException e) {
			System.out.println("Đóng kết nối thất bại Server MySQL!");
			e.printStackTrace();
		}
	}
}