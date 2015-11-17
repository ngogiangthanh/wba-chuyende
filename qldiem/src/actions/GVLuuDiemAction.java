package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class GVLuuDiemAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;
	private GVAction gvAction = null;
	private String ma_hp;
	private String ten_mh;
	private String hk;
	private String nk;
	private String ho_ten;
	private String mssv;
	private String id_hp;
	private String id_sv;
	private String diem_10;
	private String diem_chu;
	private String diem_4;
	private String cai_thien;
	
	public GVLuuDiemAction() {
	}
	
	public String postIndex(){
		this.gvAction = new GVAction();
		this.session = ActionContext.getContext().getSession();
		if(!gvAction.Prefix_Check("Nhập điểm cho sinh viên "+getMssv(), this.session))
			return "error";
		System.out.println(getMssv());
		return "view-nhapdiem";
	}
	
	public String getMa_hp() {
		return ma_hp;
	}
	
	public String getTen_mh() {
		return ten_mh;
	}
	
	public String getHk() {
		return hk;
	}
	
	public String getNk() {
		return nk;
	}
	
	public String getHo_ten() {
		return ho_ten;
	}
	
	public String getMssv() {
		return mssv;
	}
	
	public String getId_hp() {
		return id_hp;
	}
	
	public String getId_sv() {
		return id_sv;
	}
	
	public String getDiem_10() {
		return diem_10;
	}
	
	public String getDiem_4() {
		return diem_4;
	}
	
	public String getDiem_chu() {
		return diem_chu;
	}
	
	public String getCai_thien() {
		return cai_thien;
	}
	
	public void setMa_hp(String ma_hp) {
		this.ma_hp = ma_hp;
	}
	
	public void setTen_mh(String ten_mh) {
		this.ten_mh = ten_mh;
	}
	
	public void setHk(String hk) {
		this.hk = hk;
	}
	
	public void setNk(String nk) {
		this.nk = nk;
	}
	
	public void setHo_ten(String ho_ten) {
		this.ho_ten = ho_ten;
	}
	
	public void setMssv(String mssv) {
		this.mssv = mssv;
	}
	
	public void setId_hp(String id_hp) {
		this.id_hp = id_hp;
	}
	
	public void setId_sv(String id_sv) {
		this.id_sv = id_sv;
	}
	
	public void setDiem_10(String diem_10) {
		this.diem_10 = diem_10;
	}
	
	public void setDiem_4(String diem_4) {
		this.diem_4 = diem_4;
	}
	
	public void setDiem_chu(String diem_chu) {
		this.diem_chu = diem_chu;
	}
	
	public void setCai_thien(String cai_thien) {
		this.cai_thien = cai_thien;
	}
}
