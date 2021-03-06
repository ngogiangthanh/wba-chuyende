package models;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class ke_hoach {
	private int hk;
	private String nk;
	private int loai;
	private Date ngay_bd;
	private Date ngay_kt;
	private DateFormat dateFormat;

	public ke_hoach() {
		this.dateFormat = new SimpleDateFormat("dd/MM/yyyy");
	}

	public int getHk() {
		return hk;
	}

	public int getLoai() {
		return loai;
	}

	public Date getNgay_bd() {
		return ngay_bd;
	}

	public Date getNgay_kt() {
		return ngay_kt;
	}

	public String getNk() {
		return nk;
	}

	public void setHk(int hk) {
		this.hk = hk;
	}

	public void setLoai(int loai) {
		this.loai = loai;
	}

	public void setNgay_bd(String ngay_bd) {
		try {
			this.ngay_bd = removeTime(dateFormat.parse(ngay_bd));
		} catch (ParseException e) {
			this.ngay_bd = null;
			e.printStackTrace();
		}
	}

	public void setNgay_kt(String ngay_kt) {
		try {
			this.ngay_kt = removeTime(dateFormat.parse(ngay_kt));
		} catch (ParseException e) {
			this.ngay_kt = null;
			e.printStackTrace();
		}
	}

	public void setNk(String nk) {
		this.nk = nk;
	}
	
	public Date removeTime(Date date) {    
	    Calendar cal = Calendar.getInstance();  
	    cal.setTime(date);  
	    cal.set(Calendar.HOUR_OF_DAY, 0);  
	    cal.set(Calendar.MINUTE, 0);  
	    cal.set(Calendar.SECOND, 0);  
	    cal.set(Calendar.MILLISECOND, 0);  
	    return cal.getTime(); 
	}
}
