<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.*, java.net.*"%>
<%@ page import="java.io.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*"%>
<!DOCTYPE html>

<% 
	request.setCharacterEncoding("UTF-8"); 

	String id = null;
	String name = null;
	String author = null;
	String press = null;
	String b_cate = null;
	String s_cate = null;
    String discription = null;
	String img = "./img/default-book.jpg";
	String pn,v;

    final int threshold = 102400; 
    final File tmpDir = new File(getServletContext().getRealPath("/img/") + "tmp"); 
    if(ServletFileUpload.isMultipartContent(request)) 
    { 
        FileItemFactory factory = new DiskFileItemFactory(threshold, tmpDir); 
        ServletFileUpload upload = new ServletFileUpload(factory); 
        List<FileItem> items = upload.parseRequest(request); // FileUploadException 
        for(FileItem item : items) 
        { 
			pn = (String)item.getFieldName();
            if(item.isFormField()) //regular form field 
            {
				v = item.getString("utf-8");
				if (pn.equals("id")) {id = v;} 
				else if (pn.equals("name")) {name = v;}
				else if (pn.equals("author")) {author = v;}
				else if (pn.equals("press")) {press = v;}
				else if (pn.equals("b_cate")) {b_cate = v;}
				else if (pn.equals("s_cate")) {s_cate = v;}
				else if (pn.equals("discription")) {discription = v;}
			}
			else { 
				if(item.getSize() > 0){
					String LETTERCHAR = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
					StringBuffer sb = new StringBuffer();
					Random random = new Random();
					for (int i = 0; i < 10; i++) {
						sb.append(LETTERCHAR.charAt(random.nextInt(LETTERCHAR.length())));
					}
					String fileName = sb.toString() + item.getName(); 
					File uploadedFile = new File(getServletContext().getRealPath("/img/upload") + File.separator + fileName); 
					item.write(uploadedFile); 
					img = "./img/upload/" + fileName;
				}
            } 
        }
	}

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
			psmt = conn.prepareStatement("insert into books values(?, ?, ?, ?, ?, ?, ?, ?, '#', 1, CURRENT_TIMESTAMP)");
			psmt.setString(1, id);
			psmt.setString(2, b_cate);
			psmt.setString(3, s_cate);
			psmt.setString(4, name);
			psmt.setString(5, author);
			psmt.setString(6, discription);
			psmt.setString(7, press);
			psmt.setString(8, img);
		}
		else{
			if(img.equals("./img/default-book.jpg")){
				psmt = conn.prepareStatement("update books set b_cate=?, s_cate=?, book_name=?, author=?, discription=?, press=?, user_define=1 where id=?");
				psmt.setString(7, id);
			}
			else{
				psmt = conn.prepareStatement("update books set b_cate=?, s_cate=?, book_name=?, author=?, discription=?, press=?, image=?, user_define=1 where id=?");
				psmt.setString(7, img);
				psmt.setString(8, id);
			}
			psmt.setString(1, b_cate);
			psmt.setString(2, s_cate);
			psmt.setString(3, name);
			psmt.setString(4, author);
			psmt.setString(5, discription);
			psmt.setString(6, press);
			
		}
        psmt.execute();
		b_cate = URLEncoder.encode(b_cate.toString(),"utf8"); 
		s_cate = URLEncoder.encode(s_cate.toString(),"utf8"); 
        response.sendRedirect("mybook.jsp");


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