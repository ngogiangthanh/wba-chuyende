package models;
import java.util.Objects;

public class hk_nk implements Comparable<hk_nk>{
	private String nk;
	private int hk;
	
	public hk_nk(String nk, int hk) {
		this.nk = nk;
		this.hk = hk;
	}
	
	public void setHk(int hk) {
		this.hk = hk;
	}
	
	public void setNk(String nk) {
		this.nk = nk;
	}
	
	public int getHk() {
		return hk;
	}
	
	public String getNk() {
		return nk;
	}

	@Override
	public int compareTo(hk_nk o) {
		 return this.nk.compareTo(o.getNk()) + this.hk - o.getHk();
	}
	
    @Override
    public boolean equals(Object object) {
        boolean same = false;

        if (object != null && object instanceof hk_nk) {
            same = ((hk_nk) object).nk.equals(this.getNk()) & ((hk_nk) object).hk == this.getHk();
        }
        return same;
    }
    
    @Override
    public int hashCode() {
        int hash = 7;
        hash = 29 * hash + Objects.hashCode(this.nk) + Objects.hashCode(this.hk);
        return hash;
    }
}