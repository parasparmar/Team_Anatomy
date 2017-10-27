<%@ WebHandler Language="C#" Class="FileUploadHandler" %>

using System;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;

public class FileUploadHandler : IHttpHandler
{
    Helper my = new Helper();
    DataTable dtEmp;
    string NT_ID;

    public void ProcessRequest(HttpContext context)
    {
        int Employee_ID = 0;
        if (context.Request.Files.Count > 0)
        {
            HttpFileCollection files = context.Request.Files;


            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile file = files[i];
                string filesname = file.FileName;
                NT_ID = filesname.Substring(0, filesname.IndexOf("_")).ToString();

                if (i == 0)
                {
                    dtEmp = my.GetData("WFMP.getEmployeeData '" + NT_ID + "'");
                    Employee_ID = Convert.ToInt32(dtEmp.Rows[0]["Employee_ID"].ToString());
                }
                string fileOnServer = context.Server.MapPath("/Sitel/user_images/" + filesname);
                file.SaveAs(fileOnServer);

                string strSQL = "WFMP.Profile_SaveUserImage";
                using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
                {
                    cn.Open();
                    using (SqlCommand cmd = new SqlCommand(strSQL, cn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@UserImage", filesname);
                        cmd.Parameters.AddWithValue("@Updated_by", NT_ID);
                        cmd.Parameters.AddWithValue("@Employee_ID", Employee_ID);
                        int rowsAffected = cmd.ExecuteNonQuery();

                    }
                }
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