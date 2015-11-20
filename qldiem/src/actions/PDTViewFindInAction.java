package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class PDTViewFindInAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;
	private PDTAction pdtAction = null;
	public PDTViewFindInAction() {
	}
	
	public String execute(){
		this.pdtAction = new PDTAction();
		this.session = ActionContext.getContext().getSession();
		if(!this.pdtAction.Prefix_Check("Trang chủ phòng đào tạo",this.session))
			return ERROR;

		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			GVAction gvAction = new GVAction();
			gvAction.assignHKNKValues(this.session);
		}
		
		return "index";
	}
}
