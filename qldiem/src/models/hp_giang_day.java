package models;

public class hp_giang_day {
	private int stt;
	private int id_mh;
	private int id_hp;
	private String ma_mh;
	private String ma_hp;
	private String ten_mh;
	private int so_tc;
	private int lt;
	private int th;
	
	public hp_giang_day() {
		// TODO Auto-generated constructor stub
	}
	
	public int getId_hp() {
		return id_hp;
	}
	
	public int getId_mh() {
		return id_mh;
	}
	
	public int getLt() {
		return lt;
	}
	
	public String getMa_hp() {
		return ma_hp;
	}
	
	public String getMa_mh() {
		return ma_mh;
	}
	
	public int getSo_tc() {
		return so_tc;
	}
	
	public int getStt() {
		return stt;
	}
	
	public String getTen_mh() {
		return ten_mh;
	}
	
	public int getTh() {
		return th;
	}
	
	public void setId_hp(int id_hp) {
		this.id_hp = id_hp;
	}
	
	public void setId_mh(int id_mh) {
		this.id_mh = id_mh;
	}
	
	public void setLt(int lt) {
		this.lt = lt;
	}
	
	public void setMa_hp(String ma_hp) {
		this.ma_hp = ma_hp;
	}
	
	public void setMa_mh(String ma_mh) {
		this.ma_mh = ma_mh;
	}
	
	public void setSo_tc(int so_tc) {
		this.so_tc = so_tc;
	}
	
	public void setStt(int stt) {
		this.stt = stt;
	}
	
	public void setTen_mh(String ten_mh) {
		this.ten_mh = ten_mh;
	}
	
	public void setTh(int th) {
		this.th = th;
	}
}
