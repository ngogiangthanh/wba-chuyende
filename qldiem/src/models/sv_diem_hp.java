package models;

public class sv_diem_hp {
	private int stt;
	private String maMH;
	private String tenHP;
	private String hpDieuKien;
	private String maHP;
	private Integer soTC;
	private String diemChu;
	private float diem10;
	private String tichLuy;
	private String caiThien;
	
	
	public sv_diem_hp() {
		stt = -1;
		maMH = "";
		tenHP = "";
		hpDieuKien = "";
		maHP = "";
		soTC = null;
		diemChu = null;
		diem10 = -1;
		tichLuy = "";
		caiThien = "";
	}
	
	public int getStt() {
		return stt;
	}
	
	public float getDiem10() {
		return diem10;
	}
	
	public String getDiemChu() {
		return diemChu;
	}
	
	public String getMaHP() {
		return maHP;
	}
	
	public String getMaMH() {
		return maMH;
	}
	
	public Integer getSoTC() {
		return soTC;
	}
	
	public String getTenHP() {
		return tenHP;
	}
	
	public String getCaiThien() {
		return caiThien;
	}
	
	public String getHpDieuKien() {
		return hpDieuKien;
	}
	
	public String getTichLuy() {
		return tichLuy;
	}
	
	public void setStt(int stt) {
		this.stt = stt;
	}
	
	public void setCaiThien(String caiThien) {
		this.caiThien = caiThien;
	}
	
	public void setDiem10(float diem10) {
		this.diem10 = diem10;
	}
	
	public void setDiemChu(String diemChu) {
		this.diemChu = diemChu;
	}
	
	public void setHpDieuKien(String hpDieuKien) {
		this.hpDieuKien = hpDieuKien;
	}
	
	public void setMaHP(String maHP) {
		this.maHP = maHP;
	}
	
	public void setMaMH(String maMH) {
		this.maMH = maMH;
	}
	
	public void setSoTC(Integer soTC) {
		this.soTC = soTC;
	}
	
	public void setTenHP(String tenHP) {
		this.tenHP = tenHP;
	}
	
	public void setTichLuy(String tichLuy) {
		this.tichLuy = tichLuy;
	}
}