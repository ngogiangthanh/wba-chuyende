package models;

import java.util.ArrayList;
import java.util.Date;

public class thang_diem {
	private Date td_ap_dung;
	private ArrayList<muc_chuyen_doi> ds_muc_chuyen_doi;
	
	public thang_diem() {
		this.td_ap_dung = new Date();
		this.ds_muc_chuyen_doi = new ArrayList<>();
	}
	
	public ArrayList<muc_chuyen_doi> getDs_muc_chuyen_doi() {
		return ds_muc_chuyen_doi;
	}
	
	public Date getTd_ap_dung() {
		return td_ap_dung;
	}
	
	public void setDs_muc_chuyen_doi(ArrayList<muc_chuyen_doi> ds_muc_chuyen_doi) {
		this.ds_muc_chuyen_doi = ds_muc_chuyen_doi;
	}
	
	public void setTd_ap_dung(Date td_ap_dung) {
		this.td_ap_dung = td_ap_dung;
	}
	
	public void addDs_muc_chuyen_doi(muc_chuyen_doi mcd){
		this.ds_muc_chuyen_doi.add(mcd);
	}
}
