package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import models.role;

public class Home extends ActionSupport {
	private static final long serialVersionUID = 1L;
	private String pageDirect = null;

	@SuppressWarnings("unchecked")
	public String getIndex() {
		Map<String, Object> session = ActionContext.getContext().getSession();
		try {
			if (this.isLogin(session)) {
				Map<String, role> infor_roles = (Map<String, role>) session.get("roles");
				if (infor_roles.size() == 1) {
					System.out.println("Đã login đưa về trang login 1 nhóm quyền!");
					this.getFirstEntryInSession(infor_roles);
					return "directing_page";
				} else {
					System.out.println("Đã login đưa về trang login nhiều nhóm quyền!");
					return "welcome";
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			System.out.println("Lỗi! Xóa session hiện tại! Đưa về trang login!");
			session.clear();
			return "login";
		}
		
		System.out.println("Chưa login đưa về trang login!");
		return "login";
	}

	public void getFirstEntryInSession(Map<String, role> infor_roles) {
		Map.Entry<String, role> entry = infor_roles.entrySet().iterator().next();
		role value = entry.getValue();
		setPageDirect(value.getFreemarker_page());
	}

	public boolean isLogin(Map<String, Object> session) {
		try {
			String value = (String) session.get("logined");
			if (value != null) {
				return true;
			} else {
				if (session.containsKey("logined")) {
					return true;
					// Okay, there's a key but the value is null
				} else {
					// Definitely no such key
					return false;
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			return false;
		}
	}

	public String getPageDirect() {
		return pageDirect;
	}

	public void setPageDirect(String pageDirect) {
		this.pageDirect = pageDirect;
	}
}