package actions;

import java.util.Map;

import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;

public class CVHTViewCTSVLopCVAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Map<String, Object> session = null;
	private GVAction gvAction = null;
	private Connect conn;
	
	public CVHTViewCTSVLopCVAction() {
	}

	public String execute() {
		
		return SUCCESS;
	}
	
}
