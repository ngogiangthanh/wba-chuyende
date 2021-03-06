package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class AdminAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;

	public AdminAction() {
	}

	public String getIndex() {
		this.session = ActionContext.getContext().getSession();
		if (!Home.isRole(session, 4)) {
			if (!session.isEmpty()) {
				session.clear();
				addActionError("Truy xuất sai nhóm quyền!");
				addActionMessage("Tự động đăng xuất để đăng nhập nhóm quyền phù hợp!");
			}
			return "error";
		}
		session.put("title", "Trang chủ administrator");
		return "index";
	}

	public String wattingPage() {
		this.session = ActionContext.getContext().getSession();
		if (!Home.isRole(session, 4)) {
			if (!session.isEmpty()) {
				session.clear();
				addActionError("Truy xuất sai nhóm quyền!");
				addActionMessage("Tự động đăng xuất để đăng nhập nhóm quyền phù hợp!");
			}
			return "error";
		}
		session.put("title", "Chức năng đang xây dựng");
		return "index";
	}
}
