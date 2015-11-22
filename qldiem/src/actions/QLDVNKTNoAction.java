package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class QLDVNKTNoAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;
	private QLDVNAction qlnAction = null;

	public QLDVNKTNoAction() {
	}
	
	public String execute(){
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		if(!this.qlnAction.Prefix_Check("Kiểm tra sinh viên nợ điểm I",this.session))
			return ERROR;
		return SUCCESS;
	}
}
