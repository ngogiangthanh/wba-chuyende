package models;

public class tk {
	private long id;
	private long id_sv;
	private long id_cb;
	private String username;
	private String password;
	private boolean status;
	private String roles;

	public tk() {
		// TODO Auto-generated constructor stub
	}

	public long getId() {
		return id;
	}

	public long getId_cb() {
		return id_cb;
	}

	public long getId_sv() {
		return id_sv;
	}

	public String getPassword() {
		return password;
	}

	public String getRoles() {
		return roles;
	}

	public boolean getStatus() {
		return status;
	}

	public String getUsername() {
		return username;
	}

	public void setId(long id) {
		this.id = id;
	}

	public void setId_cb(long id_cb) {
		this.id_cb = id_cb;
	}

	public void setId_sv(long id_sv) {
		this.id_sv = id_sv;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setRoles(String roles) {
		this.roles = roles;
	}

	public void setStatus(boolean status) {
		this.status = status;
	}

	public void setUsername(String username) {
		this.username = username;
	}
}