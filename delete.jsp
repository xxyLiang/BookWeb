<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*, java.net.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<% 
	String id = request.getParameter("id");

    Context initContext = new InitialContext();
	Context envContext  = (Context)initContext.lookup("java:/comp/env");
	DataSource ds = (DataSource)envContext.lookup("jdbc/book"); 
	Connection conn = null;
    PreparedStatement psmt = null;

	try {
		conn = ds.getConnection();			
		psmt = conn.prepareStatement("delete from books where id=?");
        psmt.setString(1, id);
        psmt.execute();
        response.sendRedirect(request.getHeader("referer"));

	} catch (Exception e) {
		throw e;
	} finally {
		try {
			if (psmt != null) psmt.close();
			if (conn != null) conn.close();
		} catch (Exception e) {
			throw e;
		}
	}
%>