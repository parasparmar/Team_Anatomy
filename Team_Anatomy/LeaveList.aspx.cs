using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Data.Sql;

using System.Globalization;

public partial class LeaveList : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    string strSQL;
    private int MyEmpID { get; set; }
    private int MyRepMgr { get; set; }
    private int currentWeek { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();

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
                    this.MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                    if (!PageExtensionMethods.AmIAllowedThisPage(MyEmpID, HttpContext.Current.Request.Url.AbsolutePath))
                    {
                        Response.Redirect("404.aspx", false);
                    }
                    // MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
                    // currentWeek = my.getSingleton("SELECT [WeekId] FROM [CWFM_Umang].[WFMP].[tblRstWeeks] where GETDATE() between FrDate and ToDate");
                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect("index.aspx", false);
            }
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "Leave List";
            //fillddlYear();
        }
        else
        {
            dtEmp = (DataTable)Session["dtEmp"];
            if (dtEmp.Rows.Count <= 0)
            {
                Response.Redirect("index.aspx", false);
            }
            else
            {
                // In Production Use the below
                this.MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
               // MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
               // currentWeek = my.getSingleton("SELECT [WeekId] FROM [CWFM_Umang].[WFMP].[tblRstWeeks] where GETDATE() between FrDate and ToDate");
            }
        }
    }

    private void fillgvLeaveList(DateTime startDate, DateTime endDate)
    {
        int Manager = Convert.ToInt32(ddlManager.SelectedValue);
        gvLeaveList.DataSource = null;
        gvLeaveList.Columns.Clear();
        gvLeaveList.DataBind();

        SqlCommand cmd = new SqlCommand("wfmp.getLeaveList");
        cmd.Parameters.AddWithValue("@StartDate", startDate);
        cmd.Parameters.AddWithValue("@EndDate", endDate);
        cmd.Parameters.AddWithValue("@desig", Manager);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        DataView dataView = dt.DefaultView;
        dataView.RowFilter = "EmpCode > 0 ";

        string[] rowFields = { "EmpCode", "NAME", "Designation" };
        string[] columnFields = { "Date" };

        Pivot pvt = new Pivot(dt);
        dt = pvt.DateWisePivotData("Status", AggregateFunction.First, rowFields, columnFields);

        gvLeaveList.DataSource = dt;
        gvLeaveList.DataBind();
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


    protected void btn_current_Click(object sender, EventArgs e)
    {
        DateTime now = DateTime.Now;
        var startDate = new DateTime(now.Year, now.Month, 1);
        var endDate = startDate.AddMonths(1).AddDays(-1);

        fillgvLeaveList(startDate, endDate);
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        DateTime now = DateTime.Now;
        var startDate = new DateTime(now.Year, now.Month, 1);
        var endDate = startDate.AddMonths(3).AddDays(-1);

        fillgvLeaveList(startDate, endDate); 
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        DateTime now = DateTime.Now;
        var startDate = new DateTime(now.Year, now.Month, 1);
        var endDate = startDate.AddMonths(6).AddDays(-1);

        fillgvLeaveList(startDate, endDate);
    }
}