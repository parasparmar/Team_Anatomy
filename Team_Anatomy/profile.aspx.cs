using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;

public partial class profile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string myID = PageExtensionMethods.getMyWindowsID().ToString();
        tbNTID.Text = myID;
        Helper my = new Helper();
        DataTable dt = my.GetData("Select top 1 * from cwfm_umang..WFM_Employee_List where NT_ID = '" + myID + "'");
        tbDesignation.Text = dt.Rows[0].Field<string>("Designation").ToString();

    }
}