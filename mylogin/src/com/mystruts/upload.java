package com.mystruts;

import java.io.File;
import org.apache.commons.io.FileUtils;
import java.io.IOException; 

import com.opensymphony.xwork2.ActionSupport;

public class upload extends ActionSupport{
	   /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		private File myFile;
	   private String myFileContentType;
	   private String myFileFileName;
	   private String destPath;

	   public String execute()
	   {
	      /* Copy file to a safe location */
	      destPath = "D:/Struts2/apache-tomcat-7.0.65/work/";

	      try{
	     	 System.out.println("Dst File name: " + myFileFileName);
	     	    	 
	     	 File destFile  = new File(destPath, myFileFileName);
	    	 FileUtils.copyFile(myFile, destFile);
	  
	      }catch(IOException e){
	         e.printStackTrace();
	         return ERROR;
	      }

	      return SUCCESS;
	   }
	 
	   public File getMyFile() {
		return myFile;
	}
	   
	   public String getMyFileContentType() {
		return myFileContentType;
	}
	   
	   public String getMyFileFileName() {
		return myFileFileName;
	}
	   
	   public String getDestPath() {
		return destPath;
	}
	   
	   public void setMyFile(File myFile) {
		this.myFile = myFile;
	}
	   
	   public void setMyFileContentType(String myFileContentType) {
		this.myFileContentType = myFileContentType;
	}
	   public void setMyFileFileName(String myFileFileName) {
		this.myFileFileName = myFileFileName;
	}
	   
	   public void setDestPath(String destPath) {
		this.destPath = destPath;
	}
	   
	}