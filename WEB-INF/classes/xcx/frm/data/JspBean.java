package xcx.frm.data;

import java.util.*;


public class JspBean {
	private int menu_id;
	private String jsp_code;
	private String jsp_name;
	private String jsp_url;
	private int show_in_menu;
	
	public int getMenuId() {
		return menu_id;
	}
	
	public String getJspCode() {
		return jsp_code;
	}
	
	public String getJspName() {
		return jsp_name;
	}
	
	public String getJspUrl() {
		return jsp_url;
	}
	
	public int getShowInMenu() {
		return show_in_menu;
	}
	
	public static JspBean recordsetToData(java.sql.ResultSet rs) throws Exception {
		JspBean data = new JspBean();
	    data.menu_id = rs.getInt("menu_id");
	    data.jsp_code = rs.getString("jsp_code");
	    data.jsp_name = rs.getString("jsp_name");
	    data.jsp_url = rs.getString("jsp_url"); 
	    data.show_in_menu = rs.getInt("show_in_menu");
        return data;
	}
	
	public static List recordsetToList(java.sql.ResultSet rs) throws Exception {
	    List result = new ArrayList();

	    while (rs.next()) {
	       result.add(recordsetToData(rs));
	    }
	    return result;
	}
}