package models;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class sv_lop_cv{
	private int stt;
	private int id_sv;
	private String mssv;
	private String ho_ten;
	private String gioi_tinh;
	private Date ngay_sinh;
	private String khoa;
	private String chuyen_nganh;
	private DateFormat dateFormat;
	
	public sv_lop_cv() {
		this.dateFormat = new SimpleDateFormat("dd/MM/yyyy");
	}
	
	public int getStt() {
		return stt;
	}
	
	public String getChuyen_nganh() {
		return chuyen_nganh;
	}
	
	public String getGioi_tinh() {
		return gioi_tinh;
	}
	
	public String getHo_ten() {
		return ho_ten;
	}
	
	public int getId_sv() {
		return id_sv;
	}
	
	public String getKhoa() {
		return khoa;
	}
	
	public String getMssv() {
		return mssv;
	}
	
	public Date getNgay_sinh() {
		return ngay_sinh;
	}
	
	public void setChuyen_nganh(String chuyen_nganh) {
		this.chuyen_nganh = chuyen_nganh;
	}
	
	public void setGioi_tinh(String gioi_tinh) {
		this.gioi_tinh = gioi_tinh;
	}
	
	public void setHo_ten(String ho_ten) {
		this.ho_ten = ho_ten;
	}
	
	public void setId_sv(int id_sv) {
		this.id_sv = id_sv;
	}
	
	public void setKhoa(String khoa) {
		this.khoa = khoa;
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
	
}
