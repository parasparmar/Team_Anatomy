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
        Helper sub_class = new Helper();
        myURL = context.Current.Request.Url.ToString();
        SqlCommand cmd = new SqlCommand();
        sub_class.create_rst(ref cmd, "[Debug].[sp_errors_login]", "S");
        cmd.Parameters.Add("@ExceptionMsg", SqlDbType.VarChar, 100).Value = exdb.Message.ToString();
        cmd.Parameters.Add("@ExceptionType", SqlDbType.VarChar, 100).Value = exdb.GetType().Name.ToString();
        cmd.Parameters.Add("@ExceptionSource", SqlDbType.NVarChar).Value = exdb.StackTrace.ToString();
        cmd.Parameters.Add("@ExceptionURL", SqlDbType.VarChar, 100).Value = myURL;
        cmd.Parameters.Add("@user_id", SqlDbType.VarChar, 20).Value = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
        cmd.Parameters.Add("@machine_name", SqlDbType.VarChar, 20).Value = System.Environment.MachineName;
        cmd.ExecuteNonQuery();

        ////Paras 03-Aug-2017 Don't redirect
        //HttpContext.Current.Response.Redirect("~/error_page.aspx", false);
    }
}
