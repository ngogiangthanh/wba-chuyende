package com.mystruts;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

import com.opensymphony.xwork2.ActionSupport;

public class FileUploadAction extends ActionSupport{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private File userImage;
	
	private String userImageContentType;
	
	private String userImageFileName;
	private Map<String,ArrayList<String>> dataOfFile = null;
		
	public String execute()
	{
		this.dataOfFile = new HashMap<String, ArrayList<String>>();
		try {
	    POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(userImage));
	    HSSFWorkbook wb = new HSSFWorkbook(fs);
	    HSSFSheet sheet = wb.getSheetAt(0);
	    HSSFRow row;
	    HSSFCell cell;

	    int rows; // No of rows
	    rows = sheet.getPhysicalNumberOfRows();

	    int cols = 0; // No of columns
	    int tmp = 0;

	    // This trick ensures that we get the data properly even if it doesn't start from first few rows
	    for(int i = 0; i < 10 || i < rows; i++) {
	        row = sheet.getRow(i);
	        if(row != null) {
	            tmp = sheet.getRow(i).getPhysicalNumberOfCells();
	            if(tmp > cols) cols = tmp;
	        }
	    }

        for(int c = 0; c < cols; c++) {
    		String key = "";
    		ArrayList<String> noi_dung = new ArrayList<String>();
        		noi_dung.clear();
       		 key = "";
        	for(int r = 0; r < rows; r++) {
	        row = sheet.getRow(r);
	        if(row != null) {
	                cell = row.getCell((int)c);
	                if(cell != null) {
	                	if(r == 0){
	                		key = cell.toString();
	                	}
	                	else
	                		noi_dung.add(cell.toString());
	                	//System.out.print(cell+" - ");
	                }
	            }
	        }
        	this.dataOfFile.put(key, noi_dung);
            //System.out.println("");
	    }
	} catch(Exception ioe) {
	    ioe.printStackTrace();
	}
		return SUCCESS;
	}

	public File getUserImage() {
		return userImage;
	}

	public void setUserImage(File userImage) {
		this.userImage = userImage;
	}

	public String getUserImageContentType() {
		return userImageContentType;
	}

	public void setUserImageContentType(String userImageContentType) {
		this.userImageContentType = userImageContentType;
	}

	public String getUserImageFileName() {
		return userImageFileName;
	}

	public void setUserImageFileName(String userImageFileName) {
		this.userImageFileName = userImageFileName;
	}
	
	public Map<String, ArrayList<String>> getDataOfFile() {
		return dataOfFile;
	}
	
	public void setDataOfFile(Map<String, ArrayList<String>> dataOfFile) {
		this.dataOfFile = dataOfFile;
	}
	
}
