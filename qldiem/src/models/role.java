package models;

public class role {
	private String name;
	private String freemarker_page;

	public role() {
		this.name = null;
		this.freemarker_page = null;
	}

	public role(String name, String freemarker_page) {
		this.name = name;
		this.freemarker_page = freemarker_page;
	}

	public String getFreemarker_page() {
		return freemarker_page;
	}

	public String getName() {
		return name;
	}

	public void setFreemarker_page(String freemarker_page) {
		this.freemarker_page = freemarker_page;
	}

	public void setName(String name) {
		this.name = name;
	}
}
