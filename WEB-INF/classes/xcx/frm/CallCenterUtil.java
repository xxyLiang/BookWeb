package xcx.frm;


import java.util.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

import xcx.frm.data.*;

public class CallCenterUtil {
	public static DataSource getDataSource(String dsName) throws Exception {
		Context initContext = new InitialContext();
		Context envContext  = (Context)initContext.lookup("java:/comp/env");
		return (DataSource)envContext.lookup(dsName); 
	}
	
	public static DataSource getDataSource() throws Exception {
		Context initContext = new InitialContext();
		Context envContext  = (Context)initContext.lookup("java:/comp/env");
		return (DataSource)envContext.lookup("jdbc/callcenter"); 
	}
	
	public static boolean isAuthorized(HttpSession session, String jspCode) {
		Boolean authorized = false;
		String nickName = (String)session.getAttribute("nick_name");
		if (nickName != null && nickName.length() > 0) {
			HashMap menus = (HashMap)session.getAttribute("menus");
			Iterator it = menus.keySet().iterator();
			String menu;
			List jsps;
			JspBean jsp;
			while (it.hasNext()) {
				menu = (String)it.next();
				jsps =  (List)menus.get(menu);
				for (int i = 0; i < jsps.size(); i++) {		
					jsp = (JspBean)jsps.get(i);
					if (jsp.getJspCode().equals(jspCode)) {
						authorized = true;
						break;
					}
				}
				if (authorized) break;
			}
		}
		return authorized;
	}
	
	public static JspBean getJSPByCode(HttpSession session, String jspCode) {
		JspBean result = null;
		Boolean authorized = false;
		String nickName = (String)session.getAttribute("nick_name");
		if (nickName != null && nickName.length() > 0) {
			HashMap menus = (HashMap)session.getAttribute("menus");
			Iterator it = menus.keySet().iterator();
			String menu;
			List jsps;
			JspBean jsp;
			while (it.hasNext()) {
				menu = (String)it.next();
				jsps =  (List)menus.get(menu);
				for (int i = 0; i < jsps.size(); i++) {		
					jsp = (JspBean)jsps.get(i);
					if (jsp.getJspCode().equals(jspCode)) {
						result = jsp;
						authorized = true;
						break;
					}
				}
				if (authorized) break;
			}
		}
		return result;
	}
}
