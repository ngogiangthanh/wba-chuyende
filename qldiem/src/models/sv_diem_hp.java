package models;

import java.util.ArrayList;

public class sv_diem_hp {
	private int stt;
	private String maMH;
	private String tenHP;
	private String hpDieuKien;
	private String maHP;
	private Integer soTC;
	private String diemChu;
	private float diem10;
	private float diem4;
	private String tichLuy;
	private String caiThien;
	private float tichDiem;
	private thang_diem thang_diem_qd;
	private String tichLuyTC;
	private String tichLuyDiem;

	public sv_diem_hp() {
		stt = -1;
		maMH = "";
		tenHP = "";
		hpDieuKien = "";
		maHP = "";
		soTC = null;
		diemChu = null;
		diem10 = -1;
		diem4 = -1;
		tichLuy = "";
		caiThien = "";
		tichLuyDiem = "0";
		tichLuyTC = "0";
	}

	public void tinhTichDiem() {
		ArrayList<muc_chuyen_doi> ds_mcd = this.thang_diem_qd.getDs_muc_chuyen_doi();
		int size_ds = ds_mcd.size();

		for (int i = 0; i < size_ds; i++) {
			if (ds_mcd.get(i).getDiemChu().equals(this.diemChu)) {
				System.out.println("Diem " + diemChu + " | tl tc " + ds_mcd.get(i).isTichLuyTC() + "| tl diem "
						+ ds_mcd.get(i).isTichLuyDiem());
				this.setTichLuyTC((ds_mcd.get(i).isTichLuyTC()) ? "1" : "0");
				this.setTichLuyDiem((ds_mcd.get(i).isTichLuyDiem()) ? "1" : "0");
				break;
			}
		}
		this.tichDiem = diem4 * this.soTC;
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

	public float getTichDiem() {
		return tichDiem;
	}

	public float getDiem4() {
		return diem4;
	}

	public String getTichLuyDiem() {
		return tichLuyDiem;
	}

	public String getTichLuyTC() {
		return tichLuyTC;
	}

	public thang_diem getThang_diem_qd() {
		return thang_diem_qd;
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

	public void setTichDiem(float tichDiem) {
		this.tichDiem = tichDiem;
	}

	public void setDiem4(float diem4) {
		this.diem4 = diem4;
	}

	public void setThang_diem_qd(thang_diem thang_diem_qd) {
		this.thang_diem_qd = thang_diem_qd;
	}

	public void setTichLuyDiem(String tichLuyDiem) {
		this.tichLuyDiem = tichLuyDiem;
	}

	public void setTichLuyTC(String tichLuyTC) {
		this.tichLuyTC = tichLuyTC;
	}
}
