package hash;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class md5 {
	private String md5_string_encode;
	private String md5_string_result;

	public md5(String md5_string_encode) {
		this.md5_string_encode = md5_string_encode;
		this.md5_string_result = null;
	}
	
	public md5() {
		this.md5_string_encode = null;
		this.md5_string_result = null;
	}

	public void generator() {
		MessageDigest md;
		try {
			md = MessageDigest.getInstance("MD5");
			md.update(md5_string_encode.getBytes());
			byte byteData[] = md.digest();

			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < byteData.length; i++) {
				sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
			}
			this.setMd5_string_result(sb.toString());
			
		} catch (NoSuchAlgorithmException e) {
			this.setMd5_string_result(null);
			e.printStackTrace();
		}
	}

	public String getMd5_string_encode() {
		return md5_string_encode;
	}

	public String getMd5_string_result() {
		return md5_string_result;
	}

	public void setMd5_string_encode(String md5_string_encode) {
		this.md5_string_encode = md5_string_encode;
	}

	public void setMd5_string_result(String md5_string_result) {
		this.md5_string_result = md5_string_result;
	}
}
