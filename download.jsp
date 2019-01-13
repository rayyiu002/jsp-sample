<%@ page import= "java.io.*" %>
<%!
     private static final int BUFSIZE = 2048;
	  /**
     *  Sends a file to the ServletResponse output stream.  Typically
     *  you want the browser to receive a different name than the
     *  name the file has been saved in your local database, since
     *  your local names need to be unique.
     *
     *  @param request The request
     *  @param response The response
     *  @param filename The name of the file you want to download.
     *  @param original_filename The name the browser should receive.
     */
    private void doDownload( HttpServletRequest request, HttpServletResponse response,
                             String filename, String original_filename )
        throws IOException
    {
        File                f        = new File(filename);
        int                 length   = 0;
        ServletOutputStream op       = response.getOutputStream();
        ServletContext      context  = getServletConfig().getServletContext();
        String              mimetype = context.getMimeType( filename );

        //
        //  Set the response and go!
        //
        //
        response.setContentType( (mimetype != null) ? mimetype : "application/octet-stream" );
        response.setContentLength( (int)f.length() );
        response.setHeader( "Content-Disposition", "attachment; filename=\"" + original_filename + "\"" );

        //
        //  Stream to the requester.
        //
        byte[] bbuf = new byte[BUFSIZE];
        DataInputStream in = new DataInputStream(new FileInputStream(f));

        while ((in != null) && ((length = in.read(bbuf)) != -1))
        {
            op.write(bbuf,0,length);
        }

        in.close();
        op.flush();
        op.close();
    }
%>
<%
	//String original_filename = request.getParameter("filename");
    String target_filename = "";
    
    // Chrome will auto escape the URL characters
    String userAgent = request.getHeader("user-agent");
    System.out.println(userAgent);
    String charset = "MS950";
    if (userAgent.indexOf("Chrome") != -1) {
    	charset = "UTF-8";
    }

    // Security Isuue: User can type file=../WEB-INF/web.xml
    //String filename = application.getRealPath(original_filename);
    boolean error = false;
		
		String path = "C:\\xampp\\tomcat\\webapps\\examples\\servlets\\testing.pdf";
		String javaPath = path.replace("\\", "/");
		
		out.println("javaPath=" + javaPath);

    	File file = new File(javaPath);	
    	if (file.exists()) {
    	  //  doDownload(request, response, javaPath, original_filename);
		  doDownload(request, response, javaPath, file.getName());
    	    // delete the file after download
    	    //boolean deleted = file.delete();
    	    //System.out.println("File " + target_filename + " deleted: " + deleted);
    	} else {
			error = true;
    	}
    
    if (error) {
    	response.setContentType("text/html; charset=UTF-8");
		out.println("File not found: " + target_filename);
    }
%>