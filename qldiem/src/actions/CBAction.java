package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class CBAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;

	public CBAction() {
	}

	public String getViewProfile() {
		this.session = ActionContext.getContext().getSession();
		if (!(Home.isRole(session, 1) | Home.isRole(session, 2) | Home.isRole(session, 3) | Home.isRole(session, 4))) {
			if (!session.isEmpty()) {
				session.clear();
				addActionError("Truy xuất sai nhóm quyền!");
				addActionMessage("Tự động đăng xuất để đăng nhập nhóm quyền phù hợp!");
			}
			return "error";
		}
		session.put("title", "Xem thông tin cán bộ");
		return "view-profile-cb";
	}
}
