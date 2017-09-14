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
    string myID;
    protected void Page_Load(object sender, EventArgs e)
    {
        myID = PageExtensionMethods.getMyWindowsID().ToString();
        //myID = "ktriv003";
        Session["myID"] = myID;
        Helper my = new Helper();
        DataTable dt = my.GetData("WFMP.getEmployeeData " + myID);
        if (dt.Rows.Count > 0)
        {
            Session["dtEmp"] = dt;
            Response.Redirect("roster.aspx", true);
        }
        else
        {
            Response.Redirect("lockscreen.aspx", true);
        }



    }
}