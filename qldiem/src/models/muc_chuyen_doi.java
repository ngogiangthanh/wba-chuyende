package models;

public class muc_chuyen_doi {
	private float diem10;
	private String diemChu;
	private float diem4;
	private boolean tichLuyTC;
	private boolean tichLuyDiem;

	public muc_chuyen_doi() {
		// TODO Auto-generated constructor stub
	}
	
	public float getDiem10() {
		return diem10;
	}

	public float getDiem4() {
		return diem4;
	}

	public String getDiemChu() {
		return diemChu;
	}

	public void setDiem10(float diem10) {
		this.diem10 = diem10;
	}

	public void setDiem4(float diem4) {
		this.diem4 = diem4;
	}

	public void setDiemChu(String diemChu) {
		this.diemChu = diemChu;
	}

	public void setTichLuyTC(boolean tichLuyTC) {
		this.tichLuyTC = tichLuyTC;
	}

	public boolean isTichLuyTC() {
		return tichLuyTC;
	}
	
	public void setTichLuyDiem(boolean tichLuyDiem) {
		this.tichLuyDiem = tichLuyDiem;
	}
	
	public boolean isTichLuyDiem() {
		return tichLuyDiem;
	}
}
