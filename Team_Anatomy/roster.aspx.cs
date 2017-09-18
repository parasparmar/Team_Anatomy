using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Globalization;

public partial class roster : System.Web.UI.Page
{
    DataTable dt;
    Helper my = new Helper();
    string strSQL = string.Empty;
    int MyEmpID = 0;


    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            dt = (DataTable)Session["dtEmp"];
            if (dt.Rows.Count <= 0)
            {
                Response.Redirect("index.aspx");
            }
            else
            {
                MyEmpID = Convert.ToInt32(dt.Rows[0]["Employee_Id"].ToString());
            }

        }
        catch (Exception Ex)
        {
            Response.Redirect("index.aspx");
        }
        MyEmpID = 923563;
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Roster";
        fillddlRepManager();
        fillddlWeek();
    }

    private void fillddlWeek()
    {
        
        if (pnlAmIRvwMgr.Visible)
        {
            strSQL = "WFMP.GetWeeks";
        }
        else
        {
            strSQL = "WFMP.GetWeeks";
        }
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.Add("@Year", 2017);
        cmd.CommandType = CommandType.StoredProcedure;

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlWeek.DataSource = dt;
        ddlWeek.DataTextField = "Dates";
        ddlWeek.DataValueField = "Id";
        ddlWeek.DataBind();

    }

    private void fillddlRepManager()
    {
        
        strSQL = "Select count(*) as Teams FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
        strSQL += " WHERE A.RepMgrCode = " + MyEmpID + " and A.IsReportingManager = 1";
        int countofManagersReportingToMe = my.getSingleton(strSQL);

        if (countofManagersReportingToMe > 0)
        {
            pnlAmIRvwMgr.Visible = true;
            strSQL = "SELECT A.RepMgrCode, REPLACE(B.First_Name +' '+B.Middle_Name+' '+B.Last_Name,'  ',' ') as RepMgr";
            strSQL += " , A.Employee_ID as MgrID, A.First_Name +' '+A.Middle_Name+' '+A.Last_Name as MgrName";
            strSQL += "  FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
            strSQL += " INNER JOIN [CWFM_Umang].[WFMP].[tblMaster] B ON B.Employee_ID = A.RepMgrCode";
            strSQL += " WHERE A.RepMgrCode = " + MyEmpID + " and A.IsReportingManager = 1";
            DataTable dt = my.GetData(strSQL);
            ddlRepManager.DataSource = dt;
            ddlRepManager.DataTextField = "MgrName";
            ddlRepManager.DataValueField = "MgrID";
            ddlRepManager.DataBind();
        }
        else
        {
            pnlAmIRvwMgr.Visible = false;
        }

    }

    protected void ddlRepManager_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void ddlWeek_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}