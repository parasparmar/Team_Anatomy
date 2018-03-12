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

public partial class swap : System.Web.UI.Page
{
    public DataTable dtEmp;
    Helper my;
    string strSQL;
    private int MyEmpID { get; set; }
    private int SwappedEmployeeID { get; set; }
    private int MyRepMgr { get; set; }
    private int currentWeek { get; set; }
    private int WeekID { get; set; }
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
            title.Text = "Shift Swaps";
            fillddlYear();
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
                MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
                currentWeek = my.getSingleton("SELECT [WeekId] FROM [CWFM_Umang].[WFMP].[tblRstWeeks] where GETDATE() between FrDate and ToDate");
            }
        }
    }

    protected void fillddlYear()
    {
        strSQL = "select distinct ryear as Year from CWFM_Umang.WFMP.tblRstWeeks";
        my.append_dropdown(ref ddlYear, strSQL, 0, 0);
        ddlYear.SelectedIndex = ddlYear.Items.IndexOf(new ListItem(DateTime.Today.Year.ToString()));
        ddlYear_SelectedIndexChanged(ddlYear, new EventArgs());
        ltlReportingMgrsTeam.Text = "Roster For " + ddlYear.SelectedItem.Text;
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


        ltlRosterHeading.Text = "Week : " + ddlWeek.SelectedItem.Text;
        // To Do : The two lines below are only for convenience. THey should be removed from production, uat and development.
        ddlWeek.SelectedIndex = 0;
        ddlWeek_SelectedIndexChanged(ddlYear, new EventArgs());
    }
    protected void ddlWeek_SelectedIndexChanged(object sender, EventArgs e)
    {

        ltlRosterHeading.Text = "Week : " + ddlWeek.SelectedItem.Text;
        if (ddlWeek.SelectedValue.Length > 0 && ddlYear.SelectedValue != "0")
        {

            WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
            fillgvRoster(this.MyEmpID, WeekID);
        }

    }
    private void fillgvRoster(int MyEmpID, int WeekID)
    {

        DataTable dtDates = my.GetData("Select * from [WFMP].[tblRstWeeks] where WeekId = " + WeekID);
        DateTime FromDate = Convert.ToDateTime(dtDates.Rows[0]["FrDate"].ToString());
        DateTime ToDate = Convert.ToDateTime(dtDates.Rows[0]["ToDate"].ToString());

        SqlCommand cmd = new SqlCommand("[WFMP].[Roster_GetSwapWithinTeamSpecificRoster]");
        cmd.Parameters.AddWithValue("@EmpID", this.MyEmpID);
        cmd.Parameters.AddWithValue("@FromDate", FromDate);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        dtEmp = my.GetDataTableViaProcedure(ref cmd);

        string[] rowFields = { "ECN", "NAME", "TEAM_LEADER" };
        string[] columnFields = { "ShiftDate" };
        Pivot pvt = new Pivot(dtEmp);
        dtEmp = pvt.PivotData("ShiftCode", AggregateFunction.First, rowFields, columnFields);
        string colName;
        DateTime colDate;
        int RowCount = dtEmp.Rows.Count;
        int ColCount = dtEmp.Columns.Count;

        for (int j = 1; j < ColCount + 1; j++)
        {
            colName = dtEmp.Columns[j - 1].ColumnName;
            if (DateTime.TryParse(colName, CultureInfo.InvariantCulture, DateTimeStyles.None, out colDate))
            {
                string col_Date = colDate.ToString("ddd, dd-MMM-yyyy");
                dtEmp.Columns[j - 1].ColumnName = col_Date;
                gvRoster.Columns[j].HeaderText = col_Date;
            }
        }


        gvRoster.DataSource = dtEmp;
        gvRoster.DataBind();
        gvRoster_PostFillActions(gvRoster, dtEmp);
    }

    private void gvRoster_PostFillActions(GridView gv, DataTable dt)
    {
        int RowCount = dt.Rows.Count;
        int ColCount = dt.Columns.Count;

        // Set the date Header rows
        // The gv has dates beginning from 4th column onwards and shows 7 dates. ie:- indices 4 through ColCount = 10
        string lblName;
        string ddlName;
        for (int i = 0; i < RowCount; i++)
        {
            if (gv.Rows[i].Cells[1].Text == SwappedEmployeeID.ToString())
            {
                gv.Rows[i].CssClass = "bg-light-blue disabled color-palette";
            }
            for (int j = 4; j < ColCount + 1; j++)
            {
                //Set labels for Date Columns only
                if ((gv.Rows[i].RowState & DataControlRowState.Edit) > 0)
                {
                    ddlName = "dd" + (j - 4);
                    DropDownList w = (DropDownList)gv.Rows[i].FindControl(ddlName);
                    ListItem item = new ListItem();
                    item.Text = dt.Rows[i][j - 1].ToString();
                    w.Items.Add(item);
                }
                else
                {
                    lblName = "lbl" + (j - 4);
                    Label v = (Label)gv.Rows[i].FindControl(lblName);
                    v.Text = dt.Rows[i][j - 1].ToString();
                }
            }
        }

        // To Do: This method auto initiates the swap mechanism and is for development only.
        // To Do: Please remove from P,U & D
        Button btnInitiateSwap = (Button)gvRoster.Rows[0].Cells[0].FindControl("btnInitiateSwap");
        if (btnInitiateSwap != null)
        {
            btnInitiateSwap.Click += BtnInitiateSwap_Click;
        }

        //gv.DataSource = dt;
        //gv.DataBind();
    }

    private void BtnInitiateSwap_Click(object sender, EventArgs e)
    {
        GridViewEditEventArgs c = new GridViewEditEventArgs(0);
        gvRoster_RowEditing(gvRoster, c);
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



    protected void gvRoster_RowEditing(object sender, GridViewEditEventArgs e)
    {
        // Normally the selected employee needs to undergo a shift edit,
        // However due to the swap being initiated by current employee we'd like the current employee to be placed in edit mode.
        // With the caveat that the shift options should be gathered from the swappedEmployee's shift for that day.
        SwappedEmployeeID = Convert.ToInt32(gvRoster.Rows[e.NewEditIndex].Cells[1].Text);
        fillRepeaterSwap(MyEmpID, SwappedEmployeeID);
    }

    protected void gvRoster_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {

    }

    protected void gvRoster_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        foreach (GridViewRow r in gvRoster.Rows)
        {
            r.RowState = DataControlRowState.Normal;
        }
        WeekID = Convert.ToInt32(ddlWeek.SelectedValue.ToString());
        if (WeekID > 0)
        {
            fillgvRoster(MyEmpID, WeekID);
        }
    }

    protected void fillRepeaterSwap(int MyEmpID, int SwappedEmployeeID)
    {
        pnlRoster.Visible = false;
        pnlSwap.Visible = true;
        WeekID = Convert.ToInt32(ddlWeek.SelectedValue.ToString());
        string strSQL = "Select * from WFMP.tblRstWeeks where WeekID = " + WeekID;
        DataTable dtDates = my.GetData(strSQL);
        DateTime FromDate = Convert.ToDateTime(dtDates.Rows[0]["FrDate"].ToString());
        DateTime ToDate = Convert.ToDateTime(dtDates.Rows[0]["ToDate"].ToString());

        SqlCommand cmd = new SqlCommand("[WFMP].[Roster_GetSwapBetweenEmployeesSpecificRoster]");
        cmd.Parameters.AddWithValue("@EmpID1", MyEmpID);
        cmd.Parameters.AddWithValue("@EmpID2", SwappedEmployeeID);
        cmd.Parameters.AddWithValue("@FromDate", FromDate);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        dtEmp = my.GetDataTableViaProcedure(ref cmd);
        rptrSwapForm.DataSource = dtEmp;
        rptrSwapForm.DataBind();
    }


    protected void rptrSwapForm_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {


        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DropDownList D1 = ((DropDownList)e.Item.FindControl("ddl1"));
            DropDownList D2 = ((DropDownList)e.Item.FindControl("ddl2"));
            ListItemCollection L = new ListItemCollection();
            ListItem L1 = new ListItem(dtEmp.Rows[e.Item.ItemIndex]["ShiftCode1"].ToString(), dtEmp.Rows[e.Item.ItemIndex]["ShiftId1"].ToString());
            ListItem L2 = new ListItem(dtEmp.Rows[e.Item.ItemIndex]["ShiftCode2"].ToString(), dtEmp.Rows[e.Item.ItemIndex]["ShiftId2"].ToString());
            L.Add(L1);
            L.Add(L2);
            D1.DataSource = L;
            D2.DataSource = L;

            D1.DataBind();
            D2.DataBind();

            D1.SelectedValue = L1.Text;
            D2.SelectedValue = L2.Text;

        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        foreach (RepeaterItem i in rptrSwapForm.Items)
        {

        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {

    }
}

class Employee
{
    public int EmpCode { get; set; }
    public int WeekID { get; set; }
    public DateTime rDate { get; set; }
    public int ShiftID { get; set; }
    public string ShiftCode { get; set; }
    public int RepMgrCode { get; set; }
    public int UpdatedBy { get; set; }

    
}