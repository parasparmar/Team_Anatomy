using System;
using System.Data;
using System.Data.SqlClient;
using context = System.Web.HttpContext;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;


public static class Log
{

    private static String myURL;
    public static void thisException(Exception exdb)
    {
        Helper my = new Helper();

        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand("[Debug].[sp_errors_login]", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;                
                cmd.Parameters.Add("@ExceptionMsg", SqlDbType.VarChar, 100).Value = exdb.Message.ToString();
                cmd.Parameters.Add("@ExceptionType", SqlDbType.VarChar, 100).Value = exdb.GetType().Name.ToString();
                cmd.Parameters.Add("@ExceptionSource", SqlDbType.NVarChar).Value = exdb.StackTrace.ToString();
                myURL = context.Current.Request.Url.ToString();
                cmd.Parameters.Add("@ExceptionURL", SqlDbType.VarChar, 100).Value = myURL;
                //cmd.Parameters.Add("@user_id", SqlDbType.VarChar, 20).Value = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
                cmd.Parameters.Add("@user_id", SqlDbType.VarChar, 20).Value = HttpContext.Current.User.Identity.Name;
                cmd.Parameters.Add("@machine_name", SqlDbType.VarChar, 20).Value = System.Environment.MachineName;
                cmd.ExecuteNonQuery();
            }
        }
        ////Paras 03-Aug-2017 Don't redirect
        //HttpContext.Current.Response.Redirect("~/error_page.aspx", false);
    }
}
