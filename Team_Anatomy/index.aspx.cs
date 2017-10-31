using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;

public partial class index : System.Web.UI.Page
{
    string myid;
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            myid = PageExtensionMethods.getMyWindowsID().ToString();
            //myid = "utiwa002";
            Session["myid"] = myid;
            //Is my NTID available?
            if (myid != "IDNotFound")
            {
                Helper my = new Helper();
                // Get all rows with my ntid.
                DataTable dt = my.GetData("WFMP.getEmployeeData '" + myid + "'");
                if (dt.Rows.Count > 0)
                {
                    Session["dtEmp"] = dt;
                    // If possible, redirect to the referring url, else to profile.aspx as default.
                    Response.Redirect("profile.aspx", false);
                }
                else
                {
                    // Every page in the application will use the session 'myid' as the NTName of the unauthorized user.
                    // or the user whose ntname does not match any known names in the db.
                    Session["myid"] = myid;
                    Response.Redirect("lockscreen.aspx", false);
                }
            }
            else
            {
                // In case the NTName cannot be read via pageextension methods.
                Response.Redirect("lockscreen.aspx", false);
            }
        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }

    }
}