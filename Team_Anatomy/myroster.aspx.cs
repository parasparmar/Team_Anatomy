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
            title.Text = "My Roster";
            fillddlYear();
        }
    }

    protected void fillddlYear()
    {
        strSQL = "select distinct ryear as Year from CWFM_Umang.WFMP.tblRstWeeks";
        my.append_dropdown(ref ddlYear, strSQL, 0, 0);
        ltlReportingMgrsTeam.Text = "Roster For";
    }
    protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
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

        if (ddlWeek.SelectedValue.Length > 0 && ddlYear.SelectedValue != "0")
        {
            int WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
            fillgvRoster(MyEmpID, WeekID);
        }


        ltlRosterHeading.Text = "Week : " + ddlWeek.SelectedItem.Text;

    }
    protected void ddlWeek_SelectedIndexChanged(object sender, EventArgs e)
    {

        ltlRosterHeading.Text = "Week : " + ddlWeek.SelectedItem.Text;
        if (ddlWeek.SelectedValue.Length > 0 && ddlYear.SelectedValue != "0")
        {
            int RepMgrCode = MyRepMgr;
            int WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
            fillgvRoster(MyEmpID, WeekID);
        }

    }
    private void fillgvRoster(int MyEmpID, int WeekID)
    {
        gvRoster.DataSource = null;
        gvRoster.Columns.Clear();
        gvRoster.DataBind();

        DataTable dtDates = my.GetData("Select * from [WFMP].[tblRstWeeks] where WeekId = " + WeekID);
        DateTime FromDate = Convert.ToDateTime(dtDates.Rows[0]["FrDate"].ToString());
        DateTime ToDate = Convert.ToDateTime(dtDates.Rows[0]["ToDate"].ToString());
        
        SqlCommand cmd = new SqlCommand("[WFMP].[Roster_GetEmployeeSpecificRoster]");
        cmd.Parameters.AddWithValue("@EmpID", MyEmpID);
        cmd.Parameters.AddWithValue("@FromDate", FromDate);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        dtEmp = my.GetDataTableViaProcedure(ref cmd);

        string[] rowFields = { "ECN", "NAME", "TEAM_LEADER" };
        string[] columnFields = { "ShiftDate" };
        Pivot pvt = new Pivot(dtEmp);
        dtEmp = pvt.PivotData("ShiftCode", AggregateFunction.First, rowFields, columnFields);

        


        int RowCount = dtEmp.Rows.Count;
        int ColCount = dtEmp.Columns.Count;

        // Set the date Header rows
        // The gvRoster has dates beginning from 3rd column onwards and shows 7 dates. ie:- indices 2 through ColCount-1 = 8

        string colName;
        DateTime colDate;
        for (int j = 0; j < ColCount; j++)
        {
            colName = dtEmp.Columns[j].ColumnName;

            if (DateTime.TryParse(colName, CultureInfo.InvariantCulture, DateTimeStyles.None, out colDate))
            {
                BoundField d = new BoundField();
                d.DataField = colDate.ToString();
                d.HeaderText = colDate.ToString("ddd dd-MMM-yyyy");
                gvRoster.Columns.Add(d);

            }
            else
            {

                BoundField d = new BoundField();
                d.DataField = colName;
                d.HeaderText = colName;
                gvRoster.Columns.Add(d);
            }
        }


        gvRoster.DataSource = dtEmp;
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



}