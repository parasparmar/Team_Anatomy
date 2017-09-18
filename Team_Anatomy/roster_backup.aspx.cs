using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class roster_backup : System.Web.UI.Page
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
        //fillTeamList();
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Roster";
        strSQL = "SELECT A.RepMgrCode, B.First_Name +' '+B.Middle_Name+' '+B.Last_Name as RepMgr, A.Employee_ID, A.First_Name +' '+A.Middle_Name+' '+A.Last_Name as Name";
        strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
        strSQL += " INNER JOIN [CWFM_Umang].[WFMP].[tblMaster] B ON B.Employee_ID = A.RepMgrCode ";
        strSQL += " WHERE A.RepMgrCode = 923563 ";

        lvwTeamList.DataSource = my.GetData(strSQL);
        lvwTeamList.DataBind();

    }

    protected void gv_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;
        if (gv.Rows.Count > 0)
        {
            gv.UseAccessibleHeader = true;
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;

            gv.HeaderStyle.BorderStyle = BorderStyle.None;

            gv.BorderStyle = BorderStyle.None;
            gv.BorderWidth = Unit.Pixel(1);
        }
    }

    protected void lvwTeamList_ItemDataBound(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)
        {
            strSQL = "SELECT A.RepMgrCode, B.First_Name +' '+B.Middle_Name+' '+B.Last_Name as RepMgr, A.Employee_ID, A.First_Name +' '+A.Middle_Name+' '+A.Last_Name as Name";
            strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
            strSQL += " INNER JOIN [CWFM_Umang].[WFMP].[tblMaster] B ON B.Employee_ID = A.RepMgrCode ";
            strSQL += " WHERE A.RepMgrCode = ";

            HiddenField hdnfld_Employee_ID = (HiddenField)e.Item.FindControl("hdnfld_Employee_ID");

            GridView gv = (GridView)e.Item.FindControl("gvteamList");
            int EmpID = Convert.ToInt32(hdnfld_Employee_ID.Value.ToString());
            gv.DataSource = my.GetData(strSQL + EmpID);
            gv.DataBind();
        }

    }
}