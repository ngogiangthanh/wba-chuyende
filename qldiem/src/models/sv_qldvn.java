package models;

public class sv_qldvn {
	private int id_sv;
	private String mssv;
	private String ho_ten;
	private String lop;
	private String ten_lop;
	private String ma_mh;
	private String ten_mh;
	private int so_tc;
	private String dieu_kien;
	private int id_hp;
	private String diem_chu;
	private float diem_4;
	private float diem_10;
	
	public sv_qldvn() {
		// TODO Auto-generated constructor stub
	}
	
	public float getDiem_10() {
		return diem_10;
	}
	
	public float getDiem_4() {
		return diem_4;
	}
	
	public String getDiem_chu() {
		return diem_chu;
	}
	
	public String getDieu_kien() {
		return dieu_kien;
	}
	
	public int getId_hp() {
		return id_hp;
	}
	
	public String getMa_mh() {
		return ma_mh;
	}
	
	public int getSo_tc() {
		return so_tc;
	}
	
	public String getTen_mh() {
		return ten_mh;
	}

	public String getHo_ten() {
		return ho_ten;
	}
	
	public int getId_sv() {
		return id_sv;
	}
	
	public String getLop() {
		return lop;
	}
	
	public String getMssv() {
		return mssv;
	}
	
	public String getTen_lop() {
		return ten_lop;
	}
	
	public void setHo_ten(String ho_ten) {
		this.ho_ten = ho_ten;
	}
	
	public void setId_sv(int id_sv) {
		this.id_sv = id_sv;
	}
	
	public void setLop(String lop) {
		this.lop = lop;
	}
	
	public void setMssv(String mssv) {
		this.mssv = mssv;
	}
	
	public void setTen_lop(String ten_lop) {
		this.ten_lop = ten_lop;
	}
	
	public void setDiem_10(float diem_10) {
		this.diem_10 = diem_10;
	}
	
	public void setDiem_4(float diem_4) {
		this.diem_4 = diem_4;
	}
	
	public void setDiem_chu(String diem_chu) {
		this.diem_chu = diem_chu;
	}
	
	public void setDieu_kien(String dieu_kien) {
		this.dieu_kien = dieu_kien;
	}
	
	public void setId_hp(int id_hp) {
		this.id_hp = id_hp;
	}
	
	public void setMa_mh(String ma_mh) {
		this.ma_mh = ma_mh;
	}
	
	public void setSo_tc(int so_tc) {
		this.so_tc = so_tc;
	}
	
	public void setTen_mh(String ten_mh) {
		this.ten_mh = ten_mh;
	}
}