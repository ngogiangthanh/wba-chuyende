package com.mystruts;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class LogoutAction extends ActionSupport {
	
	private static final long serialVersionUID = 1L;

	public String logout() {
		// HttpSession session = ServletActionContext.getRequest().getSession();
		// session.removeAttribute("logined");
		// session.removeAttribute("context");
		Map<String, Object> session = ActionContext.getContext().getSession();
		session.remove("logined");
		session.remove("name");
		session.remove("time");
		addActionMessage("Đăng xuất thành công!");
		return "success";
	}
}
