package actions;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;

import com.mysql.jdbc.CallableStatement;
import com.mysql.jdbc.ResultSet;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

import connection.Connect;
import models.sv_hp;

public class GVExcelUploadAction extends ActionSupport {

	private static final long serialVersionUID = 1L;
	private Connect conn;
	private Map<String, Object> session = null;
	private GVAction gvAction = null;
	private File excelFile;
	private String excelFileContentType;
	private String excelFileFileName;
	private Map<String, sv_hp> dataOfFile = null;
	private ArrayList<sv_hp> dsSVHP = null;
	private ArrayList<String> msvv_name = null;
	private ArrayList<String> ho_ten_name = null;
	private ArrayList<String> diem_name = null;
	// add new
	private String hk;
	private String nk;
	private String id_gv;
	private String id_hp;

	public GVExcelUploadAction() {
	}

	public void init() {
		this.msvv_name = new ArrayList<>();
		this.msvv_name.add("mssv");
		this.msvv_name.add("mã số sinh viên");

		this.ho_ten_name = new ArrayList<>();
		this.ho_ten_name.add("họ tên");
		this.ho_ten_name.add("họ và tên");
		this.ho_ten_name.add("tên");

		this.diem_name = new ArrayList<>();
		this.diem_name.add("điểm");
		this.diem_name.add("điểm 10");
		this.diem_name.add("điểm số");
	}

	public String execute() {
		this.gvAction = new GVAction();
		this.session = ActionContext.getContext().getSession();
		if (!gvAction.Prefix_Check("", this.session))
			return ERROR;
		// Đọc thông tin từ file
		this.dataOfFile = new LinkedHashMap<String, sv_hp>();
		try {
			this.init();
			POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(excelFile));
			HSSFWorkbook wb = new HSSFWorkbook(fs);
			HSSFSheet sheet = wb.getSheetAt(0);
			HSSFRow row;
			HSSFCell cell = null;
			int rows; // No of rows
			rows = sheet.getPhysicalNumberOfRows();

			int cols = 0; // No of columns
			int tmp = 0;

			// This trick ensures that we get the data properly even if it
			// doesn't start from first few rows
			for (int i = 0; i < 10 || i < rows; i++) {
				row = sheet.getRow(i);
				if (row != null) {
					tmp = sheet.getRow(i).getPhysicalNumberOfCells();
					if (tmp > cols)
						cols = tmp;
				}
			}

			HSSFRow header = sheet.getRow(0);
			for (int r = 1; r < rows; r++) {
				sv_hp sv = null;
				String mssv = null;
				sv = new sv_hp();
				for (int c = 0; c < cols; c++) {
					row = sheet.getRow(r);

					String nameOfThisColumn = (header.getCell((int) c)).toString().toLowerCase().trim();
					// Thực hiện thêm cột này

					try {
						if (row != null) {
							cell = row.getCell((int) c);
							cell.setCellType(Cell.CELL_TYPE_STRING);
							if (cell != null) {
								if (msvv_name.contains(nameOfThisColumn)) {
									mssv = cell.toString();
									sv.setMssv(cell.toString());
								} else if (ho_ten_name.contains(nameOfThisColumn)) {
									sv.setHo_ten(cell.toString());
								} else if (diem_name.contains(nameOfThisColumn)) {
									try {
										sv.setDiem_10(Float.parseFloat(cell.toString()));
									} catch (Exception ex) {
										sv.setDiem_10(0);
									}
								} else {
									continue;
								}
							}
						}
					} catch (Exception ex) {
						break;
					}
				}
				this.dataOfFile.put(mssv, sv);
			}
			addActionMessage("Upload tệp excel hoàn tất!");
		} catch (Exception ioe) {
			ioe.printStackTrace();
			addActionError("Lỗi upload tệp excel!");
			return SUCCESS;
		}

		// Lấy ds sv của gv đó dạy hp
		this.getDSSVHP();

		return SUCCESS;
	}

	public void getDSSVHP() {
		this.conn = new Connect();
		String procedure = "call get_tt_gv_day_hp_ds_sv(?,?,?,?);";
		CallableStatement pstmt = null;
		try {
			pstmt = (CallableStatement) this.conn.getConn().prepareCall(procedure);
			// Gán tham số id_hp
			pstmt.setInt(1, Integer.parseInt(getId_hp()));
			// Gán tham số id gv
			pstmt.setInt(2, Integer.parseInt(getId_gv()));
			// Gán tham số nk
			pstmt.setString(3, getNk());
			// Gán tham số hk
			pstmt.setInt(4, Integer.parseInt(getHk()));

			// Thực thi procedure
			pstmt.execute();
			ResultSet rs = (ResultSet) pstmt.getResultSet();
			int stt = 1;
			// Duyệt kết quả
			this.dsSVHP = new ArrayList<sv_hp>();
			while (rs.next()) {
				// Khi hàng đó không null
				if (!rs.wasNull()) {
					if (this.dataOfFile.containsKey(rs.getString("MSSV"))) {
						sv_hp sv_trung = this.dataOfFile.get(rs.getString("MSSV"));

						sv_hp sv = new sv_hp();
						sv.setStt(stt++);
						sv.setId_sv(rs.getInt("ID_SV"));
						sv.setId_hp(Integer.parseInt(getId_hp()));
						sv.setMssv(rs.getString("MSSV"));
						sv.setHo_ten(rs.getString("HO_TEN"));
						sv.setDiem_chu(rs.getString("DIEM_CHU"));
						sv.setDiem_10(sv_trung.getDiem_10());
						sv.setDiem_4(rs.getFloat("DIEM_4"));
						sv.setCai_thien(rs.getString("CAI_THIEN"));

						this.dsSVHP.add(sv);
					}
				}
			}
			// Đóng kết nối
			pstmt.close();
			rs.close();
			this.conn.Close();
			this.dataOfFile.clear();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public File getExcelFile() {
		return excelFile;
	}

	public String getExcelFileContentType() {
		return excelFileContentType;
	}

	public String getExcelFileFileName() {
		return excelFileFileName;
	}

	public Map<String, sv_hp> getDataOfFile() {
		return dataOfFile;
	}

	public String getId_gv() {
		return id_gv;
	}

	public String getId_hp() {
		return id_hp;
	}

	public String getHk() {
		return hk;
	}

	public String getNk() {
		return nk;
	}

	public ArrayList<sv_hp> getDsSVHP() {
		return dsSVHP;
	}

	public void setId_gv(String id_gv) {
		this.id_gv = id_gv;
	}

	public void setId_hp(String id_hp) {
		this.id_hp = id_hp;
	}

	public void setHk(String hk) {
		this.hk = hk;
	}

	public void setNk(String nk) {
		this.nk = nk;
	}

	public void setExcelFile(File excelFile) {
		this.excelFile = excelFile;
	}

	public void setExcelFileContentType(String excelFileContentType) {
		this.excelFileContentType = excelFileContentType;
	}

	public void setExcelFileFileName(String excelFileFileName) {
		this.excelFileFileName = excelFileFileName;
	}

	public void setDataOfFile(Map<String, sv_hp> dataOfFile) {
		this.dataOfFile = dataOfFile;
	}

	public void setDsSVHP(ArrayList<sv_hp> dsSVHP) {
		this.dsSVHP = dsSVHP;
	}
}
