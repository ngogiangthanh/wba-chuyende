package models;


public class lop_cv{
	private int stt;
	private int id_lop;
	private String lop;
	private String ten_lop;
	private String ten_lop_base_64;
	
	public lop_cv() {
		// TODO Auto-generated constructor stub
	}
	
	public int getId_lop() {
		return id_lop;
	}
	
	public String getLop() {
		return lop;
	}
	
	public int getStt() {
		return stt;
	}
	
	public String getTen_lop_base_64() {
		return ten_lop_base_64;
	}
	
	public String getTen_lop() {
		return ten_lop;
	}
	
	public void setId_lop(int id_lop) {
		this.id_lop = id_lop;
	}
	
	public void setLop(String lop) {
		this.lop = lop;
	}
	
	public void setStt(int stt) {
		this.stt = stt;
	}
	
	public void setTen_lop(String ten_lop) {
		this.ten_lop = ten_lop;
	}
	
	public void setTen_lop_base_64(String ten_lop_base_64) {
		this.ten_lop_base_64 = ten_lop_base_64;
	}
}
