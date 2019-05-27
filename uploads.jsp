<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*, javax.servlet.*"%>
<%@ page import="java.io.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*"%>
<!DOCTYPE html>
<% 
	request.setCharacterEncoding("UTF-8"); 
    String img = null;
    // file less than 10kb will be store in memory, otherwise in file system. 
    final int threshold = 10240; 
    final File tmpDir = new File(getServletContext().getRealPath("/") + "tmp"); 
    // Check that we have a file upload request 
    if(ServletFileUpload.isMultipartContent(request)) 
    { 
        FileItemFactory factory = new DiskFileItemFactory(threshold, tmpDir); 
        // Create a new file upload handler 
        ServletFileUpload upload = new ServletFileUpload(factory); 
        List<FileItem> items = upload.parseRequest(request); // FileUploadException 
        for(FileItem item : items) 
        { 
            if(!item.isFormField()) //regular form field 
            { 
                String fileName = item.getName(); 
                File uploadedFile = new File(getServletContext().getRealPath("/img") + 
                File.separator + fileName); 
                item.write(uploadedFile); 
                img = "./img/" + fileName;
                response.addHeader("img", img);
            } 
        } 
} 
%>