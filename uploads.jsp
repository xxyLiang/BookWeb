<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*, java.sql.*, javax.sql.*, javax.naming.*, javax.servlet.*"%>
<%@ page import="java.io.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<% 
	request.setCharacterEncoding("UTF-8"); 
    // file less than 10kb will be store in memory, otherwise in file system. 
    final int threshold = 10240; 
    final File tmpDir = new File(getServletContext().getRealPath("/") + "tmp"); 
    final int maxRequestSize = 1024 * 1024 * 4; // 4MB 
    // Check that we have a file upload request 
    if(ServletFileUpload.isMultipartContent(request)) 
    { 
        // Create a factory for disk-based file items. 
        FileItemFactory factory = new DiskFileItemFactory(threshold, tmpDir); 
        // Create a new file upload handler 
        ServletFileUpload upload = new ServletFileUpload(factory); 
        // Set overall request size constraint. 
        upload.setSizeMax(maxRequestSize); 
        List<FileItem> items = upload.parseRequest(request); // FileUploadException 
        for(FileItem item : items) 
        { 
            if(!item.isFormField()) //regular form field 
            { 
                String fileName = item.getName(); 
                File uploadedFile = new File(getServletContext().getRealPath("/img") + 
                File.separator + fileName); 
                item.write(uploadedFile); 
                %> 
                <h1>upload file ./img/<%=uploadedFile.getName()%> done!</h1> 
                <% 
            } 
        } 
} 
%>