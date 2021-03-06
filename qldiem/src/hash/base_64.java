package hash;

import org.apache.tomcat.util.codec.binary.Base64;

public class base_64 {
	private String base_64_string_input;
	private String base_64_string_encode;
	private String base_64_string_decode;

	public base_64(String base_64_string_input, String base_64_string_decode) {
		this.base_64_string_input = base_64_string_input;
		this.base_64_string_encode = null;
		this.base_64_string_decode = base_64_string_decode;
	}

	public base_64() {
		this.base_64_string_input = null;
		this.base_64_string_encode = null;
		this.base_64_string_decode = null;
	}

	public void encode() {
		try {
			byte[] encodedBytes = Base64.encodeBase64(getBase_64_string_input().getBytes("UTF-8"));
			this.setBase_64_string_encode(new String(encodedBytes));

		} catch (Exception e) {
			this.setBase_64_string_encode(null);
			e.printStackTrace();
		}
	}
	
	public boolean decode(){
		try {
			byte[] decodedBytes  = Base64.decodeBase64(getBase_64_string_encode());
			this.setBase_64_string_decode(new String(decodedBytes, "UTF-8"));
			return true;
		} catch (Exception e) {
			this.setBase_64_string_decode(null);
			e.printStackTrace();
			return false;
		}
	}

	public String getBase_64_string_decode() {
		return base_64_string_decode;
	}
	
	public String getBase_64_string_encode() {
		return base_64_string_encode;
	}
	
	public String getBase_64_string_input() {
		return base_64_string_input;
	}
	
	public void setBase_64_string_decode(String base_64_string_decode) {
		this.base_64_string_decode = base_64_string_decode;
	}
	
	public void setBase_64_string_encode(String base_64_string_encode) {
		this.base_64_string_encode = base_64_string_encode;
	}
	
	public void setBase_64_string_input(String base_64_string_input) {
		this.base_64_string_input = base_64_string_input;
	}
}
