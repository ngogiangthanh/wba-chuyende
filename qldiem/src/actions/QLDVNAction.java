package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class QLDVNAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;

	public QLDVNAction() {
	}
	
	public String getIndex(){
		this.session = ActionContext.getContext().getSession();
		if(!Prefix_Check("Trang chủ cán bộ quản lý ngành",this.session))
			return ERROR;
		return "index";
	}
	
	public boolean Prefix_Check(String title, Map<String, Object> session)
	{
		if(!Home.isRole(session,2)){
			if(!session.isEmpty()){
				session.clear();
				addActionError("Truy xuất sai nhóm quyền!");
				addActionMessage("Tự động đăng xuất để đăng nhập nhóm quyền phù hợp!");
				}
			return false;
		}
		session.put("title", title);
		return true;
	}
}
