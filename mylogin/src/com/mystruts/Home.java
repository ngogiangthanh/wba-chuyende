package com.mystruts;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;

public class Home {
	public String getIndex() {

		if(this.checkLogin())
			return "welcome";
		else
			return "login";
	}
	
	public boolean checkLogin(){
		Map<String, Object> session = ActionContext.getContext().getSession();
		if (!session.containsKey("logined"))
			return false;
		else
			return true;
	}
}
