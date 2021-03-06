package models;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class sv_cc_hv{
	private int stt;
	private String mssv;
	private String ho_ten;
	private String gioi_tinh;
	private Date ngay_sinh;
	private String ten_lop;
	private String chuyen_nganh;
	private float dtb;
	private DateFormat dateFormat;
	
	public sv_cc_hv() {
		this.dateFormat = new SimpleDateFormat("dd/MM/yyyy");
	}
	
	public String getChuyen_nganh() {
		return chuyen_nganh;
	}
	
	public float getDtb() {
		return dtb;
	}
	
	public String getGioi_tinh() {
		return gioi_tinh;
	}
	
	public String getHo_ten() {
		return ho_ten;
	}
	
	public String getMssv() {
		return mssv;
	}
	
	public Date getNgay_sinh() {
		return ngay_sinh;
	}
	
	public int getStt() {
		return stt;
	}
	
	public String getTen_lop() {
		return ten_lop;
	}
	
	public void setChuyen_nganh(String chuyen_nganh) {
		this.chuyen_nganh = chuyen_nganh;
	}
	
	public void setDtb(float dtb) {
		this.dtb = dtb;
	}
	
	public void setGioi_tinh(String gioi_tinh) {
		this.gioi_tinh = gioi_tinh;
	}
	
	public void setHo_ten(String ho_ten) {
		this.ho_ten = ho_ten;
	}
	
	public void setMssv(String mssv) {
		this.mssv = mssv;
	}
	
	public void setNgay_sinh(String ngay_sinh) {
		try {
			this.ngay_sinh = dateFormat.parse(ngay_sinh);
		} catch (ParseException e) {
			this.ngay_sinh = null;
			e.printStackTrace();
		}
	}
	
	public void setStt(int stt) {
		this.stt = stt;
	}
	
	public void setTen_lop(String ten_lop) {
		this.ten_lop = ten_lop;
	}
}
