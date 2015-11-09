package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;

public class SVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;

	public SVAction() {
	}
	
	public String getIndex(){
		return "index";
	}
	
	public String getViewProfile(){
		Map<String, Object> session = ActionContext.getContext().getSession();
		session.put("title", "Xem thông tin sinh viên");
		return "view-profile";
	}
	
	public String getViewMark(){
		Map<String, Object> session = ActionContext.getContext().getSession();
		session.put("title", "Xem kết quả học tập");
		return "view-mark";
	}
}
