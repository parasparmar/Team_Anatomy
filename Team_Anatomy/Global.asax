<%@ Application Language="C#" %>

<script RunAt="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup

    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs
        if (HttpContext.Current.Server.GetLastError() != null)
        {
            // Get the exception object.
            Exception exc = Server.GetLastError().GetBaseException();
            string urlPath = Request.Url.ToString();                       
            string id = ExceptionUtility.LogException(exc, urlPath);
            Server.ClearError();
            Server.Transfer("~/404.aspx?ex=" + id);
        }
    }

    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }



</script>
