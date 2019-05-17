package xcx.util;

import java.io.*;
import java.util.*; 
import java.sql.*;
import jxl.*; 
import jxl.write.*; 


public class ExcelUtil {
	public static void main(String[] args) throws Exception {
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/callcenter", "root", "admin");
		
		//exportPatientInfo(conn, "d:", true);
		//exportFirst(conn, "d:", true);
		//exportBoth(conn, "d:", true);\
		exportAll(conn, "d:");
		
	}
	
	public static String createExcel(String columns[], Connection conn, String sql, String path) throws Exception {	
		Random r = new Random();
		String file = Long.toString(r.nextLong()) + ".xls";
				
		return createExcel(columns, conn, sql, path, file);
	}
	
	public static String createExcel(String columns[], Connection conn, String sql, String path, String file) throws Exception {	
		File f = new File(path, file);		
		WritableWorkbook workbook = Workbook.createWorkbook(f); 
		WritableSheet sheet = workbook.createSheet("Report", 0); 
		
		Label label;
		for (int i = 0; i < columns.length; i++) {
			label = new Label(i, 0, columns[i]);		 
			sheet.addCell(label); 
		}
		
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(sql);
		int j = 1;
		while (rs.next()) {
			for (int i = 0; i < columns.length; i++) {
				label = new Label(i, j, rs.getString(i+1));		 
				sheet.addCell(label); 
			}
			j++;
		}
		rs.close();
		
		workbook.write(); 
		workbook.close(); 
		
		return file;
	}
	
	public static String exportFirst(Connection conn, String path, boolean asText) throws Exception {			
		Random rd = new Random();
		String file = Long.toString(rd.nextLong()) + ".xls";
		
		File f = new File(path, file);		
		WritableWorkbook workbook = Workbook.createWorkbook(f); 
		WritableSheet sheet = workbook.createSheet("Report", 0); 
		
		
		
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery("select patient_code, patient_name, area_name, province_name, city_name, patient_id from patient_v where first_result = 1 order by patient_code");
		Statement stmt1 = conn.createStatement();
		ResultSet rs1;

		List ids = getQuestionIds(conn, 4);
		String columns[] = new String[5+ids.size()];
		columns[0] = "patient_code";
		columns[1] = "name";
		columns[2] = "area";
		columns[3] = "province";
		columns[4] = "city";
		int qid;
		for (int i = 0; i < ids.size(); i++) {
			qid = ((Integer)ids.get(i)).intValue();
			columns[i+5] = "f" + (i+1);
		}
		Label label;
		for (int i = 0; i < columns.length; i++) {
			label = new Label(i, 0, columns[i]);		 
			sheet.addCell(label); 
		}
		
		String field = null;
		if (asText) field = "answer_text";
		else field = "answer_sequence";
		int j = 1, m;
		int pid;
		String r, tmp;
		while (rs.next()) {
			pid = rs.getInt("patient_id");
			for (int i = 0; i < 5; i++) {
				label = new Label(i, j, rs.getString(i+1));	
				sheet.addCell(label); 
			}
			
			for (int k = 0; k < ids.size(); k++) {
				qid = ((Integer)ids.get(k)).intValue();
				rs1 = stmt1.executeQuery("select cr.answer_id, cr.answer_text, a." + field + " from call_result cr left join answer a on cr.answer_id = a.answer_id where patient_id = " + pid + " and cr.question_id = " + qid);
				r = "";
				m = 0;
				while (rs1.next()) {
					if (rs1.getInt(1) > 0) tmp = rs1.getString(3);
					else tmp = rs1.getString(2);
					if (m > 0) r += ";";
					r += tmp;
					m++;
				} 
				rs1.close();
				label = new Label(k+5, j, r);	
				sheet.addCell(label);
			}
			j++;
		}
		rs.close();
		
		workbook.write(); 
		workbook.close(); 
		
		return file; 
		
	}
	
	
	public static String exportBoth(Connection conn, String path, boolean asText) throws Exception {			
		Random rd = new Random();
		String file = Long.toString(rd.nextLong()) + ".xls";
		
		File f = new File(path, file);
		WritableWorkbook workbook = Workbook.createWorkbook(f); 
		WritableSheet sheet = workbook.createSheet("Report", 0); 
		
			
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery("select patient_code, patient_name, area_name, province_name, city_name, patient_id from patient_v where first_result = 1 and second_result = 1 order by patient_code");
		Statement stmt1 = conn.createStatement();
		ResultSet rs1;
		
		List ids = getQuestionIds(conn, 4);
		List ids2 = getQuestionIds(conn, 5);
		String columns[] = new String[5+ids.size()+ids2.size()];
		columns[0] = "patient_code";
		columns[1] = "name";
		columns[2] = "area";
		columns[3] = "province";
		columns[4] = "city";
		int qid;
		for (int i = 0; i < ids.size(); i++) {
			qid = ((Integer)ids.get(i)).intValue();
			columns[i+5] = "f" + (i+1);
		}
		for (int i = 0; i < ids2.size(); i++) {
			qid = ((Integer)ids2.get(i)).intValue();
			columns[i+5+ids.size()] = "s" + (i+1);
		}
		Label label;
		for (int i = 0; i < columns.length; i++) {
			label = new Label(i, 0, columns[i]);		 
			sheet.addCell(label); 
		}
		
		String field = null;
		if (asText) field = "answer_text";
		else field = "answer_sequence";
		int j = 1, m;
		int pid;
		String r, tmp;
		while (rs.next()) {
			pid = rs.getInt("patient_id");
			//System.out.println(pid);
			for (int i = 0; i < 5; i++) {
				label = new Label(i, j, rs.getString(i+1));	
				sheet.addCell(label); 
			}
			for (int k = 0; k < ids.size(); k++) {
				qid = ((Integer)ids.get(k)).intValue();
				rs1 = stmt1.executeQuery("select cr.answer_id, cr.answer_text, a." + field + " from call_result cr left join answer a on cr.answer_id = a.answer_id where patient_id = " + pid + " and cr.question_id = " + qid);
				r = "";
				m = 0;
				while (rs1.next()) {
					if (rs1.getInt(1) > 0) tmp = rs1.getString(3);
					else tmp = rs1.getString(2);
					if (m > 0) r += ";";
					r += tmp;
					m++;
				} 
				rs1.close();
				label = new Label(k+5, j, r);	
				sheet.addCell(label);
			}

			for (int k = 0; k < ids2.size(); k++) {
				qid = ((Integer)ids2.get(k)).intValue();
				rs1 = stmt1.executeQuery("select cr.answer_id, cr.answer_text, a." + field + " from call_result cr left join answer a on cr.answer_id = a.answer_id where patient_id = " + pid + " and cr.question_id = " + qid);
				r = "";
				m = 0;
				while (rs1.next()) {
					if (rs1.getInt(1) > 0) tmp = rs1.getString(3);
					else tmp = rs1.getString(2);
					if (m > 0) r += ";";
					r += tmp;
					m++;
				} 
				rs1.close();
				label = new Label(k+ids.size()+5, j, r);	
				sheet.addCell(label);
			}
			j++;
		}
		rs.close();
		
		workbook.write(); 
		workbook.close(); 
		
		return file;
		
	}
	
	public static String exportPatientInfo(Connection conn, String path, boolean asText) throws Exception {			
		Random rd = new Random();
		String file = Long.toString(rd.nextLong()) + ".xls";
		
		File f = new File(path, file);		
		WritableWorkbook workbook = Workbook.createWorkbook(f); 
		WritableSheet sheet = workbook.createSheet("Report", 0); 
		
		
		
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery("select patient_code, patient_name, area_name, province_name, city_name, patient_id from patient_v order by patient_code");
		Statement stmt1 = conn.createStatement();
		ResultSet rs1;
		
		List ids = getQuestionIds(conn, 6);
		String columns[] = new String[5+ids.size()];
		columns[0] = "patient_code";
		columns[1] = "name";
		columns[2] = "area";
		columns[3] = "province";
		columns[4] = "city";
		int qid;
		for (int i = 0; i < ids.size(); i++) {
			qid = ((Integer)ids.get(i)).intValue();
			columns[i+5] = "f" + (i+1);
		}
		Label label;
		for (int i = 0; i < columns.length; i++) {
			label = new Label(i, 0, columns[i]);		 
			sheet.addCell(label); 
		}
		
		String field = null;
		if (asText) field = "answer_text";
		else field = "answer_sequence";
		int j = 1, m;
		int pid;
		String r,tmp;
		while (rs.next()) {
			pid = rs.getInt("patient_id");
			for (int i = 0; i < 5; i++) {
				label = new Label(i, j, rs.getString(i+1));	
				sheet.addCell(label); 
			}
			for (int k = 0; k < ids.size(); k++) {
				qid = ((Integer)ids.get(k)).intValue();
				rs1 = stmt1.executeQuery("select cr.answer_id, cr.answer_text, a." + field + " from call_result cr left join answer a on cr.answer_id = a.answer_id where patient_id = " + pid + " and cr.question_id = " + qid);
				r = "";
				m = 0;
				while (rs1.next()) {
					if (rs1.getInt(1) > 0) tmp = rs1.getString(3);
					else tmp = rs1.getString(2);
					if (m > 0) r += ";";
					r += tmp;
					m++;
				} 
				rs1.close();
				label = new Label(k+5, j, r);	
				sheet.addCell(label);
			}
			j++;
		}
		rs.close();
		
		workbook.write(); 
		workbook.close();  
		
		return file;
		
	}
	
	public static String exportAll(Connection conn, String path) throws Exception {			
		Random rd = new Random();
		String file = Long.toString(rd.nextLong()) + ".xls";
		
		File f = new File(path, file);		
		WritableWorkbook workbook = Workbook.createWorkbook(f); 
		WritableSheet sheet = workbook.createSheet("Report", 0); 
		
		Label label;
		String columns[] = {"patient_code","enrolled_date","input_date","area", "province","hospital", "doctor", "telephone","name","telephone","address","zipcode","call_1","call_2","call_3","first_result","success_rate", "bank", "account", "remarks", "second_result"};
		for (int i = 0; i < columns.length; i++) {
			label = new Label(i, 0, columns[i]);		 
			sheet.addCell(label); 
		}
		
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery("select patient_code, enrolled_date, input_date, area_name, province_name, hospital_name, doctor_name, doctor_telephone, patient_name, telephone, address, zip_code, call_1_result, call_2_result, call_3_result, first_result, second_result, first_time, doctor_id from patient_v where not(first_result is null) group by patient_id order by patient_code");
		Statement stmt1 = conn.createStatement();
		ResultSet rs1;
		
		String ft = null;
		int j = 1;
		int did;
		while (rs.next()) {
			ft = rs.getString("first_time");
			did = rs.getInt("doctor_id");
			for (int i = 0; i < 16; i++) {
				label = new Label(i, j, rs.getString(i+1));	
				sheet.addCell(label); 
			}
			label = new Label(20, j, rs.getString("second_result"));	
			sheet.addCell(label);
			
			rs1 = stmt1.executeQuery("select p.success_rate, d.bank, d.account, p.remarks from payment p, doctor d where p.doctor_id = d.doctor_id and p.doctor_id = " + did + " and result = 2 and paying_date > '" + ft + "' order by paying_date");
			if (rs1.next()) {
				for (int i = 1; i < 4; i++) {
					label = new Label(i+15, j, rs1.getString(i));	
					sheet.addCell(label); 
				}
			}
			rs1.close();
			
			
			j++;
		}
		rs.close();
		
		WritableCell cell;
		String tmp;
		int r;
		for (int i = 1; i < j; i++) {
			for (int k = 12; k < 15; k++) {
				cell = sheet.getWritableCell(k, i);				
				tmp = cell.getContents();
				r = 0;
				if (tmp != null && tmp.length() > 0) r = Integer.parseInt(tmp);
				switch(r) {
					case -1:
						tmp = "号码错误";
						break;
					case -2:
						tmp = "停机";
						break;
					case -3:
						tmp = "完全不配合";
						break;
					case -4:
						tmp = "住院等其他意外情况";
						break;
					case -11:
						tmp = "无人接听";
						break;
					case -12:
						tmp = "挂机";
						break;
					case -13:
						tmp = "关机";
						break;
					case -21:
						tmp = "要求在特定时间呼叫";
						break;
					case 1:
						tmp = "成功";
						break;
					default:
						tmp = "";
				}
				label = (Label)cell;
				label.setString(tmp);
			}
		}
		
		for (int i = 1; i < j; i++) {
			updateCallResult(sheet, 15, i);
			updateCallResult(sheet, 20, i);
		}
		
		workbook.write(); 
		workbook.close();  
		
		return file;
		
	}
	
	public static void updateCallResult(WritableSheet sheet, int k, int i) {
		WritableCell cell;
		String tmp;
		int r;
		Label label;
		cell = sheet.getWritableCell(k, i);				
		tmp = cell.getContents();
		r = 0;
		if (tmp != null && tmp.length() > 0) r = Integer.parseInt(tmp);
		switch(r) {
			case -1:
				tmp = "失败";
				break;
			case -2:
				tmp = "无效";
				break;
			case 1:
				tmp = "成功";
				break;
			default:
				tmp = "";
		}
		label = (Label)cell;
		label.setString(tmp);
	}
	
	public static List getQuestionIds(Connection conn, int paperId) throws Exception {
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery("select question_id from question where paper_id = " + paperId + " order by question_sequence");
		List ids = new ArrayList(); 
		while(rs.next()) {
			ids.add(rs.getInt(1));
		}
		rs.close();
		return ids;
	}
	
	public static String quantify(Connection conn, String path) throws Exception {			
		Random rd = new Random();
		String file = Long.toString(rd.nextLong()) + ".xls";
		
		File f = new File(path, file);
		WritableWorkbook workbook = Workbook.createWorkbook(f); 
		WritableSheet sheet = workbook.createSheet("Report", 0); 
		
			
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery("select patient_code, patient_name, area_name, province_name, city_name, patient_id from patient_v where first_result = 1 and second_result = 1 order by patient_code");
		Statement stmt1 = conn.createStatement();
		ResultSet rs1;
		
		String columns[] = new String[25];
		int qids1[] = {18, 20, 21, 19, 22};
		int qids2[] = {35, 36, 37, 38, 39};
		columns[0] = "patient_code";
		columns[1] = "name";
		columns[2] = "area";
		columns[3] = "province";
		columns[4] = "city";
		columns[5] = "空腹血糖-1";
		columns[6] = "餐后血糖-1";
		columns[7] = "糖化血红蛋白-1";
		columns[8] = "治疗方案-1";
		columns[9] = "剂量-1";
		columns[10] = "(空腹血糖-1)";
		columns[11] = "(餐后血糖-1)";
		columns[12] = "(糖化血红蛋白-1)";
		columns[13] = "(治疗方案-1)";
		columns[14] = "(剂量-1)";
		columns[15] = "空腹血糖-2";
		columns[16] = "餐后血糖-2";
		columns[17] = "糖化血红蛋白-2";
		columns[18] = "治疗方案-2";
		columns[19] = "剂量-2";
		columns[20] = "(空腹血糖-2)";
		columns[21] = "(餐后血糖-2)";
		columns[22] = "(糖化血红蛋白-2)";
		columns[23] = "(治疗方案-2)";
		columns[24] = "(剂量-2)";
		int qid;


		Label label;
		for (int i = 0; i < columns.length; i++) {
			label = new Label(i, 0, columns[i]);		 
			sheet.addCell(label); 
		}
		
		int j = 1;
		int pid;
		String tmp, s = null;
		String r[];
		while (rs.next()) {
			pid = rs.getInt("patient_id");
			//System.out.println(pid);
			for (int i = 0; i < 5; i++) {
				label = new Label(i, j, rs.getString(i+1));	
				sheet.addCell(label); 
			}

			for (int k = 0; k < qids1.length; k++) {
				qid = qids1[k];
				rs1 = stmt1.executeQuery("select answer_text from call_result where patient_id = " + pid + " and question_id = " + qid);
				tmp = null;
				if (rs1.next()) {
					tmp = rs1.getString(1);
				} 
				if (tmp != null && tmp.length() > 0) {
					label = new Label(k+5, j, tmp);	
					sheet.addCell(label);
				}
				if (tmp != null && tmp.length() > 0 && k <= 2) {
					r = handleSomeValues(tmp);
					for (int i = 0; i < r.length; i++) {
						label = new Label(k+10+i, j, r[i]);	
						sheet.addCell(label);
					}
				}
				if (k == 3) s = tmp;
				if (k == 4 && s != null && s.length() > 0) {
					r = handleInsulins(s, tmp);
					label = new Label(13, j, r[0]);	
					sheet.addCell(label);		
					label = new Label(14, j, r[1]);	
					sheet.addCell(label);					
				}
			}
			
			for (int k = 0; k < qids2.length; k++) {
				qid = qids2[k];
				rs1 = stmt1.executeQuery("select answer_text from call_result where patient_id = " + pid + " and question_id = " + qid);
				tmp = null;
				if (rs1.next()) {
					tmp = rs1.getString(1);
				} 
				if (tmp != null && tmp.length() > 0) {
					label = new Label(k+15, j, tmp);	
					sheet.addCell(label);
				}
				if (tmp != null && tmp.length() > 0 && k <= 2) {
					r = handleSomeValues(tmp);
					for (int i = 0; i < r.length; i++) {
						label = new Label(k+20+i, j, r[i]);	
						sheet.addCell(label);
					}
				}
				if (k == 3) s = tmp;
				if (k == 4 && s != null && s.length() > 0) {
					r = handleInsulins(s, tmp);
					label = new Label(23, j, r[0]);	
					sheet.addCell(label);		
					label = new Label(24, j, r[1]);	
					sheet.addCell(label);					
				}
			}
			j++;
		}
		rs.close();
		
		workbook.write(); 
		workbook.close(); 
		
		return file;
		
	}
	
	private static String[] handleSomeValues(String s) {
		String r[] = s.split("\\d+(\\.\\d+){0,1}");
    	double d1, d2;
    	int from = 0, to, len = 0;
    	List vs = new ArrayList();
    	for (int i = 0; i < r.length; i++) {
    		len += r[i].length();
    	}
    	for (int i = 1; i < r.length; i++) {
  			from = s.indexOf(r[i-1], from) + r[i-1].length();
  			to = s.indexOf(r[i], from);
  			len += to-from;
  			d1 = Double.parseDouble(s.substring(from, to));
  			vs.add(d1);
    	}    	
    	if (len < s.length()) {
    		d1 = Double.parseDouble(s.substring(len, s.length()));
  			vs.add(d1);
    	}
    	
    	int j = 0;
    	for (int i = 1; i < r.length; i++) {
    		if (r[i].trim().equals("-") && i-j < vs.size()) {
    			d1 = ((Double)vs.get(i-j-1)).doubleValue();
    			d2 = ((Double)vs.remove(i-j)).doubleValue();
    			d1 = (d1 + d2)/2;
    			vs.set(i-j-1, d1);
    			j++;
    		}
    	}
    	
    	String result[] = new String[vs.size()];
    	for (int i = 0; i < vs.size(); i++) {    		
    		result[i] =  ((Double)vs.get(i)).toString();
    	}
    	return result;
	}
	
	private static String[] handleInsulins(String s, String s2) {
		System.out.print(s);
		
		String result[] = new String[2];
		
		int from0 = s.indexOf("诺和平");
    	int from1 = s.indexOf("平");
    	int from2 = s.indexOf("地特");
    	int seq = 0;
    	if (from0 == 0 || from1 == 0 || from2 == 0) {
    		seq = 1;
    	}	else if (from0 > 0 || from1 > 0 || from2 > 0) {
    		if (from0 > 0) seq = from0;
	    	else if (from1 > 0) seq = from1;
	    	else if (from2 > 0) seq = from2;
	    	seq++;
    	}
    	if (seq < s.length()) s = s.substring(seq);
    	String r[] = handleSomeValues(s);
    	
    	if (seq > 0) {
    		result[0] = "诺和平";
    		if (r.length > 0) result[1] = r[0];
    		if (s2 != null && s2.length() > 0) {
    			r = handleSomeValues(s2);
    			if (r.length > 0) {
	    			if (seq == 1) result[1] = r[0];
	    			else result[1] = r.length > 0 ? r[r.length - 1] : r[0];
    			}
    		}
    	}
    	
    	System.out.println(":" + result[0] + "," + result[1]);
    	return result;
	}
}
