<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*, java.net.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<% 
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	String author = request.getParameter("author");
	String press = request.getParameter("press");
	String b_cate = request.getParameter("b_cate");
	String s_cate = request.getParameter("s_cate");
    String discription = request.getParameter("disc");

    Context initContext = new InitialContext();
	Context envContext  = (Context)initContext.lookup("java:/comp/env");
	DataSource ds = (DataSource)envContext.lookup("jdbc/book"); 
	Connection conn = null;
    PreparedStatement psmt = null;
	ResultSet rs = null;
	int update = 0;

	try {
		conn = ds.getConnection();
		psmt = conn.prepareStatement("select count(*) from books where id=?");
		psmt.setString(1, id);
		rs = psmt.executeQuery();
		if (rs.next()){
			update = rs.getInt(1);
		}
		rs.close();

		if(update == 0){
			psmt = conn.prepareStatement("insert into books values(?, ?, ?, ?, ?, ?, ?, './img/default-book.jpg', '#', 1, CURRENT_TIMESTAMP)");
			psmt.setString(1, id);
			psmt.setString(2, b_cate);
			psmt.setString(3, s_cate);
			psmt.setString(4, name);
			psmt.setString(5, author);
			psmt.setString(6, discription);
			psmt.setString(7, press);
		}
		else{
			psmt = conn.prepareStatement("update books set b_cate=?, s_cate=?, book_name=?, author=?, discription=?, press=? where id=?");
			psmt.setString(1, b_cate);
			psmt.setString(2, s_cate);
			psmt.setString(3, name);
			psmt.setString(4, author);
			psmt.setString(5, discription);
			psmt.setString(6, press);
			psmt.setString(7, id);
		}
        psmt.execute();
		b_cate = URLEncoder.encode(b_cate.toString(),"utf8"); 
		s_cate = URLEncoder.encode(s_cate.toString(),"utf8"); 
        response.sendRedirect("list.jsp?b_cate="+ b_cate +"&s_cate="+ s_cate);


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