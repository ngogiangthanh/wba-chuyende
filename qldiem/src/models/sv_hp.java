package models;

public class sv_hp {
	private int stt;
	private int id_sv;
	private int id_hp;
	private String mssv;
	private String ho_ten;
	private String diem_chu;
	private float diem_10;
	private float diem_4;
	private String cai_thien;
	
	public sv_hp() {
		// TODO Auto-generated constructor stub
	}
	
	public int getId_hp() {
		return id_hp;
	}
	
	public String getCai_thien() {
		return cai_thien;
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
	
	public String getHo_ten() {
		return ho_ten;
	}
	
	public int getId_sv() {
		return id_sv;
	}
	
	public String getMssv() {
		return mssv;
	}
	
	public void setId_hp(int id_hp) {
		this.id_hp = id_hp;
	}
	
	public int getStt() {
		return stt;
	}
	
	public void setCai_thien(String cai_thien) {
		this.cai_thien = cai_thien;
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
	
	public void setHo_ten(String ho_ten) {
		this.ho_ten = ho_ten;
	}
	
	public void setId_sv(int id_sv) {
		this.id_sv = id_sv;
	}
	
	public void setMssv(String mssv) {
		this.mssv = mssv;
	}
	
	public void setStt(int stt) {
		this.stt = stt;
	}
}
