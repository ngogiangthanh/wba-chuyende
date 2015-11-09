package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class LogoutAction extends ActionSupport {
	
	private static final long serialVersionUID = 1L;

	public String logout() {
		Map<String, Object> session = ActionContext.getContext().getSession();
		session.clear();
		return "success";
	}
}
