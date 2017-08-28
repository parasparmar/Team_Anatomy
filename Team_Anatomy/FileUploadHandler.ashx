<%@ WebHandler Language="C#" Class="FileUploadHandler" %>

using System;
using System.Web;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;

public class FileUploadHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.Files.Count > 0)
        {
            HttpFileCollection files = context.Request.Files;

            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile file = files[i];
                string filesname = file.FileName;
                string NT_ID = filesname.Substring(0, filesname.IndexOf("_")).ToString();
                string fileOnServer = context.Server.MapPath("/Sitel/user_images/" + filesname);
                file.SaveAs(fileOnServer);
                string strSQL = "UPDATE [CWFM_Umang].[dbo].[WFM_Employee_List] SET [UserImage] = @UserImage WHERE NT_ID = @NT_ID";
                SqlCommand cmd = new SqlCommand(strSQL);                
                cmd.Parameters.AddWithValue("@UserImage", filesname);
                cmd.Parameters.AddWithValue("@NT_ID", fileOnServer);
                Helper my = new Helper();
                my.ExecuteDMLCommand(ref cmd, strSQL, "E");

            }
            context.Response.ContentType = "text/plain";
            context.Response.Write("Upload Successful. The page will now refresh.");
        }
    }



    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}