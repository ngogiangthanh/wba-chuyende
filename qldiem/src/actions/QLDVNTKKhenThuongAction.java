package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;

public class QLDVNTKKhenThuongAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private QLDVNTKAction qlntkAction = null;
	private QLDVNAction qlnAction = null;

	public QLDVNTKKhenThuongAction() {
	}
	
	public String execute(){
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		// Kiểm tra xem nếu session hknk đã có thì khỏi tạo lại và ngược lại
		this.qlntkAction = new QLDVNTKAction();
		if (!session.containsKey("hknk")) {
			System.out.println("Gán hknk lần đầu");
			this.qlntkAction.assignHKNKValues(this.session);
		}
		
		if(!this.qlnAction.Prefix_Check("Thống kê danh sách sinh viên được khen thưởng",this.session))
			return ERROR;
		return SUCCESS;
	}
}
