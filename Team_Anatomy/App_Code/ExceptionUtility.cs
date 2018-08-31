using System;
using System.IO;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Reflection;
using System.Diagnostics;
using System.Runtime.CompilerServices;

/// <summary>
/// Summary description for ExceptionUtility
/// </summary>
public sealed class ExceptionUtility
{
    // All methods are static, so this can be private 
    private ExceptionUtility()
    { }

    // Log an Exception 
    [MethodImpl(MethodImplOptions.NoInlining)]
    public static string LogException(Exception exc, string source)
    {
        // Include enterprise logic for logging exceptions 
        Helper my = new Helper();
        SqlCommand cmd = new SqlCommand("setErrorLog");
        string projectName = string.Empty;
        string module = string.Empty;
        string Location = source;
        string[] errorSource = source.Split('/');
        if (errorSource.Length > 2)
        {
            projectName = errorSource[2];
            module = errorSource[errorSource.Length - 1].ToString();
        }
        
        
        cmd.Parameters.AddWithValue("@Project", projectName);
        cmd.Parameters.AddWithValue("@Module", module);
        cmd.Parameters.AddWithValue("@Location", Location);


        if (exc.InnerException != null)
        {
            cmd.Parameters.AddWithValue("@InnerExceptionType", exc.InnerException.GetType().ToString());
            cmd.Parameters.AddWithValue("@InnerExceptionMessage", exc.InnerException.Message);
            cmd.Parameters.AddWithValue("@InnerExceptionSource", exc.InnerException.Source);
            cmd.Parameters.AddWithValue("@InnerExceptionStackTrace", exc.InnerException.StackTrace);
        }

        cmd.Parameters.AddWithValue("@ExceptionType", exc.GetType().ToString());
        cmd.Parameters.AddWithValue("@ExceptionMessage", exc.Message);
        cmd.Parameters.AddWithValue("@ExceptionSource", source);
        cmd.Parameters.AddWithValue("@ExceptionStackTrace", exc.StackTrace);
        cmd.Parameters.AddWithValue("@UpdatedBy", PageExtensionMethods.getMyWindowsID());
        cmd.Parameters.Add("@ID", SqlDbType.Int);
        cmd.Parameters["@ID"].Direction = ParameterDirection.Output;
        my.ExecuteDMLCommand(ref cmd, "", "S");
        string id = cmd.Parameters["@ID"].Value.ToString();
        return id;
    }

    // Notify System Operators about an exception 
    public static void NotifySystemOps(Exception exc)
    {
        // Include code for notifying IT system operators
    }
}
