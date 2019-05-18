<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*" %>
<%@ page import="java.io.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <title>查询结果</title>
        <meta charset="utf-8">
        <link rel="stylesheet" href="./css/layui.css">
        <script src="./layui.js"></script>
        <style type="text/css">
            #result_table {
                width: 60%;
                margin-left: auto;
                margin-right: auto;
            }
        </style>
    </head>
    <body>
        <table class="layui-table" id="result_table">
            <thead>
                <tr>
                    <th width="30%">书名</th>
                    <th width="12%">作者</th>
                    <th width="18%">出版社</th>
                </tr>
            </thead>
<% 
	String c = request.getParameter("choose");
    int choose = Integer.parseInt(c);	
	String value = request.getParameter("value");	
	
	Context initContext = new InitialContext();
	Context envContext  = (Context)initContext.lookup("java:/comp/env");
	DataSource ds = (DataSource)envContext.lookup("jdbc/book"); 
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	String[] choice = {"book_name", "author", "press"};
    String name = null;
    String author = null;
    String press = null;
	try {
		conn = ds.getConnection();			
		stmt = conn.createStatement();
        rs = stmt.executeQuery("select book_name, author, press from books where "+ choice[choose] +" like '%" + value +"%'");		
        while (rs.next()) {
            name = rs.getString("book_name");
            author = rs.getString("author");
            press = rs.getString("press");
%>
            <tr>
                <td><%=name%></td>
                <td><%=author%></td>
                <td><%=press%></td>
            </tr>
<%      }
        rs.close();

	} catch (Exception e) {
		throw e;
	} finally {
		try {
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		} catch (Exception e) {
			throw e;
		}
	}
%>
        </table>
    </body>
</html>