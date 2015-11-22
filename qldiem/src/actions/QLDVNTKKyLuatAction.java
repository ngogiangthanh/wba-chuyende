package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class QLDVNTKKyLuatAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;
	private QLDVNAction qlnAction = null;

	public QLDVNTKKyLuatAction() {
	}
	
	public String execute(){
		this.qlnAction = new QLDVNAction();
		this.session = ActionContext.getContext().getSession();
		if(!this.qlnAction.Prefix_Check("Thống kê danh sách sinh viên bị kỉ luật",this.session))
			return ERROR;
		return SUCCESS;
	}
}
