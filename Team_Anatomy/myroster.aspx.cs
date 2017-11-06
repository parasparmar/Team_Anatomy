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

public partial class myroster : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my = new Helper();
    string strSQL = string.Empty;
    private int MyEmpID { get; set; }
    private int MyRepMgr { get; set; }
    private int currentWeek { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            try
            {
                dtEmp = (DataTable)Session["dtEmp"];
                if (dtEmp.Rows.Count <= 0)
                {
                    Response.Redirect("index.aspx", false);
                }
                else
                {
                    // In Production Use the below
                    MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                    MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
                    currentWeek = my.getSingleton("SELECT [WeekId] FROM [CWFM_Umang].[WFMP].[tblRstWeeks] where GETDATE() between FrDate and ToDate");
                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect("index.aspx", false);
            }
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "Roster";
            fillddlRepManager();
        }
    }
    private void fillddlRepManager()
    {
        // If I'm a rev mgr, fill the ddlRepManager with my reporting managers, If I'm a reporting manager, fill it with reportees, if I'm a sole contributor,
        // fill ddlRepManager with my name.
        strSQL = "SELECT A.RepMgrCode, REPLACE(B.First_Name +' '+B.Middle_Name+' '+B.Last_Name,'  ',' ') as RepMgr";
        strSQL += " , A.Employee_ID as MgrID, A.First_Name +' '+A.Middle_Name+' '+A.Last_Name as MgrName";
        strSQL += "  FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
        strSQL += " INNER JOIN [CWFM_Umang].[WFMP].[tblMaster] B ON B.Employee_ID = A.RepMgrCode";
        strSQL += " WHERE A.RepMgrCode = " + MyEmpID + "";

        ListItem i = new ListItem();

        switch (Role)
        {
            case (int)role.ReviewingManager:
                pnlAmIRvwMgr.Visible = true;
                strSQL += " and A.IsReportingManager = 1";
                i = new ListItem("My Reportees", MyEmpID.ToString(), true);
                break;

            case (int)role.TeamManager:
                pnlAmIRvwMgr.Visible = true;
                i = new ListItem("My Team", MyEmpID.ToString(), true);
                break;

            case (int)role.MySelf:
                pnlAmIRvwMgr.Visible = true;

                i = new ListItem("My Team's Roster", MyRepMgr.ToString(), true);

                break;
        }

        DataTable dt = my.GetData(strSQL);
        ddlRepManager.DataSource = dt;
        ddlRepManager.DataTextField = "MgrName";
        ddlRepManager.DataValueField = "MgrID";
        ddlRepManager.DataBind();
        ddlRepManager.Items.Insert(0, i);
        ddlRepManager.SelectedIndex = 0;
        ddlRepManager_SelectedIndexChanged(ddlRepManager, new EventArgs());


    }
    protected void ddlRepManager_SelectedIndexChanged(object sender, EventArgs e)
    {
        int i = Convert.ToInt32(ddlRepManager.SelectedIndex);
        strSQL = "select distinct ryear as Year from CWFM_Umang.WFMP.tblRstWeeks";
        my.append_dropdown(ref ddlYear, strSQL, 0, 0);
        ltlReportingMgrsTeam.Text = "Roster for Team : " + ddlRepManager.SelectedItem.Text;
        ddlRepManager.SelectedIndex = i;
        ddlYear_SelectedIndexChanged(ddlRepManager, new EventArgs());
        if (ddlRepManager.SelectedValue.Length > 0 && ddlWeek.SelectedValue.Length > 0 && ddlYear.SelectedValue != "0")
        {
            int RepMgrCode = Convert.ToInt32(ddlRepManager.SelectedValue);
            int WeekID = Convert.ToInt32(ddlWeek.SelectedValue);

            fillgvRoster(RepMgrCode, WeekID);
        }
        else
        {

            int RepMgrCode = MyEmpID;
            int WeekID = currentWeek;
            fillgvRoster(RepMgrCode, WeekID);
        }
    }
    protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (pnlAmIRvwMgr.Visible)
        {
            // When The manager in the dropdown is a reporting manager
            strSQL = "WFMP.GetWeeks";


            SqlCommand cmd = new SqlCommand(strSQL);

            cmd.Parameters.AddWithValue("@Year", Convert.ToInt32(ddlYear.SelectedValue.ToString()));
            cmd.CommandType = CommandType.StoredProcedure;
            DataTable dt = my.GetDataTableViaProcedure(ref cmd);
            ddlWeek.DataSource = dt;

            ddlWeek.DataTextField = "Dates";
            ddlWeek.DataValueField = "Id";
            ddlWeek.DataBind();
            if (ddlYear.Text == DateTime.Today.Year.ToString())
            {
                string RowID = my.getSingleton("Select A.[WeekId] from [CWFM_Umang].[WFMP].[tblRstWeeks] A where '" + DateTime.Today.Date + "' between A.FrDate and a.ToDate").ToString();
                ddlWeek.SelectedIndex = ddlWeek.Items.IndexOf(ddlWeek.Items.FindByValue(RowID));
            }
            else
            {
                ddlWeek.SelectedIndex = 0;
            }

            if (ddlRepManager.SelectedValue.Length > 0 && ddlWeek.SelectedValue.Length > 0 && ddlYear.SelectedValue != "0")
            {
                int RepMgrCode = Convert.ToInt32(ddlRepManager.SelectedValue);
                int WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
                fillgvRoster(RepMgrCode, WeekID);
            }

            ddlWeek_SelectedIndexChanged(ddlYear, new EventArgs());
            ltlRosterHeading.Text = "Week : " + ddlWeek.SelectedItem.Text;
        }
    }
    protected void ddlWeek_SelectedIndexChanged(object sender, EventArgs e)
    {

        ltlRosterHeading.Text = "Week : " + ddlWeek.SelectedItem.Text;
        if (ddlRepManager.SelectedValue.Length > 0 && ddlWeek.SelectedValue.Length > 0 && ddlYear.SelectedValue != "0")
        {
            int RepMgrCode = Convert.ToInt32(ddlRepManager.SelectedValue);
            int WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
            fillgvRoster(RepMgrCode, WeekID);
        }

    }
    private void fillgvRoster(int RepMgrCode, int WeekID)
    {

        SqlCommand cmd = new SqlCommand("[WFMP].[GetRosterInformation]");
        cmd.Parameters.AddWithValue("@RepMgrCode", RepMgrCode);
        // The Offset is incase the previous weeks roster needs to be replicated for today.

        cmd.Parameters.AddWithValue("@WeekID", WeekID);
        dtEmp = my.GetDataTableViaProcedure(ref cmd);
        while (dtEmp.Columns.Count > 9)
        {
            dtEmp.Columns.RemoveAt(9);
        }


        gvRoster.DataSource = dtEmp;
        int RowCount = dtEmp.Rows.Count;
        int ColCount = dtEmp.Columns.Count;

        // Set the date Header rows
        // The gvRoster has dates beginning from 3rd column onwards and shows 7 dates. ie:- indices 2 through ColCount-1 = 8

        string colName;
        DateTime colDate;
        for (int j = 0; j < ColCount; j++)
        {
            colName = dtEmp.Columns[j].ColumnName;

            if (DateTime.TryParseExact(colName, "dd-MMM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out colDate))
            {
                gvRoster.Columns[j].HeaderText = colDate.ToString("dd-MMM-yyyy");
                
            }
            else
            {
                gvRoster.Columns[j].HeaderText = colName;
                //dtEmp.Columns[j].ColumnName = "[" + colDate.ToString("ddd, dd-MMM-yyyy") + "]";
            }
        }

        

        gvRoster.DataBind();
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

    private int Role
    {
        get
        {
            // Am I a reviewing manager or a reporting manager
            string strSQL_local = "Select count(*) as Teams FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
            strSQL_local += " WHERE A.RepMgrCode = " + MyEmpID + " and A.IsReportingManager = 1";
            int countofManagersReportingToMe = my.getSingleton(strSQL_local);

            if (countofManagersReportingToMe > 0)
            {
                return (int)role.ReviewingManager;
            }
            else
            {
                strSQL_local = "Select count(*) as Teams FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
                strSQL_local += " WHERE A.RepMgrCode = " + MyEmpID;
                int countofReporteesReportingToMe = my.getSingleton(strSQL_local);
                if (countofReporteesReportingToMe > 0)
                {
                    return (int)role.TeamManager;
                }
                else
                {
                    return (int)role.MySelf;
                }
            }
        }
        set { Role = value; }
    }
    private enum role
    {
        ReviewingManager = 3,
        TeamManager = 2,
        MySelf = 1
    }

}