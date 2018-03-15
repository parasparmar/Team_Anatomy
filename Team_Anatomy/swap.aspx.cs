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
using System.Text;

public partial class swap : System.Web.UI.Page
{
    public DataTable dtEmp;
    public DataTable dtSwapRoster;
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
        dtSwapRoster = my.GetDataTableViaProcedure(ref cmd);

        string[] rowFields = { "ECN", "NAME", "TEAM_LEADER" };
        string[] columnFields = { "ShiftDate" };
        Pivot pvt = new Pivot(dtSwapRoster);
        dtSwapRoster = pvt.PivotData("ShiftCode", AggregateFunction.First, rowFields, columnFields);
        string colName;
        DateTime colDate;
        int RowCount = dtSwapRoster.Rows.Count;
        int ColCount = dtSwapRoster.Columns.Count;

        for (int j = 1; j < ColCount + 1; j++)
        {
            colName = dtSwapRoster.Columns[j - 1].ColumnName;
            if (DateTime.TryParse(colName, CultureInfo.InvariantCulture, DateTimeStyles.None, out colDate))
            {
                string col_Date = colDate.ToString("ddd, dd-MMM-yyyy");
                dtSwapRoster.Columns[j - 1].ColumnName = col_Date;
                gvRoster.Columns[j].HeaderText = col_Date;
            }
        }


        gvRoster.DataSource = dtSwapRoster;
        gvRoster.DataBind();
        gvRoster_PostFillActions(gvRoster, dtSwapRoster);
    }

    private void gvRoster_PostFillActions(GridView gv, DataTable dt)
    {
        int RowCount = dt.Rows.Count;
        int ColCount = dt.Columns.Count;

        // Set the date Header rows
        // The gv has dates beginning from 4th column onwards and shows 7 dates. ie:- indices 4 through ColCount = 10
        string lblName;
        for (int i = 0; i < RowCount; i++)
        {
            if (gv.Rows[i].Cells[1].Text == SwappedEmployeeID.ToString())
            {
                gv.Rows[i].CssClass = "bg-light-blue disabled color-palette";
            }
            for (int j = 4; j < ColCount + 1; j++)
            {

                lblName = "lbl" + (j - 4);
                Label v = (Label)gv.Rows[i].FindControl(lblName);
                v.Text = dt.Rows[i][j - 1].ToString();

            }
        }
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
        //pnlRoster.Visible = false;
        //pnlSwap.Visible = true;
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
        dtSwapRoster = my.GetDataTableViaProcedure(ref cmd);

        rptrSwapForm.DataSource = dtSwapRoster;
        rptrSwapForm.DataBind();

        Label ECN1 = (Label)rptrSwapForm.FindControlRecursive("lblEmp1");
        ECN1.Text = dtSwapRoster.Rows[0]["ECN1"].ToString();

        Label lblEmpName1 = (Label)rptrSwapForm.FindControlRecursive("lblEmpName1");
        lblEmpName1.Text = dtSwapRoster.Rows[0]["NAME1"].ToString();

        Label ECN2 = (Label)rptrSwapForm.FindControlRecursive("lblEmp2");
        ECN2.Text = dtSwapRoster.Rows[0]["ECN2"].ToString();

        Label lblEmpName2 = (Label)rptrSwapForm.FindControlRecursive("lblEmpName2");
        lblEmpName2.Text = dtSwapRoster.Rows[0]["NAME2"].ToString();

    }


    protected void rptrSwapForm_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {


        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DropDownList D1 = ((DropDownList)e.Item.FindControl("ddl1"));
            DropDownList D2 = ((DropDownList)e.Item.FindControl("ddl2"));
            ListItemCollection L = new ListItemCollection();

            ListItem L1 = new ListItem(dtSwapRoster.Rows[e.Item.ItemIndex]["ShiftCode1"].ToString(), dtSwapRoster.Rows[e.Item.ItemIndex]["ShiftId1"].ToString());
            ListItem L2 = new ListItem(dtSwapRoster.Rows[e.Item.ItemIndex]["ShiftCode2"].ToString(), dtSwapRoster.Rows[e.Item.ItemIndex]["ShiftId2"].ToString());
            L.Add(L1);
            L.Add(L2);


            D1.DataSource = L;
            D1.DataTextField = "Text";
            D1.DataValueField = "Value";

            D2.DataSource = L;
            D2.DataTextField = "Text";
            D2.DataValueField = "Value";

            D1.DataBind();
            D2.DataBind();

            D1.SelectedValue = L1.Value;
            D2.SelectedValue = L2.Value;

        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        InitiateSaveProcess();
    }

    private void InitiateSaveProcess()
    {
        List<SwapShift> S = new List<SwapShift>();
        Label EmpCode1 = (Label)rptrSwapForm.FindControlRecursive("lblEmp1");
        int ECN1 = Convert.ToInt32(EmpCode1.Text.ToString());

        Label EmpCode2 = (Label)rptrSwapForm.FindControlRecursive("lblEmp2");
        int ECN2 = Convert.ToInt32(EmpCode2.Text.ToString());

        foreach (RepeaterItem i in rptrSwapForm.Items)
        {
            SwapShift Me = new SwapShift();
            Me.RepMgrCode = MyRepMgr;
            Me.EmpCode1 = ECN1;
            Me.EmpCode2 = ECN2;
            // Fill date
            Label lblDate = (Label)i.FindControl("lblDate");
            DateTime rDate;
            if (DateTime.TryParseExact(lblDate.Text, "ddd, dd-MMM-yyyy", new CultureInfo(""), DateTimeStyles.None, out rDate))
            {
                Me.Date = rDate;
            }
            // Fill EmpCode

            // Fill Me with Newly Chosen Shifts
            DropDownList ddl1 = (DropDownList)i.FindControlRecursive("ddl1");
            if (ddl1 != null) { Me.NewShiftID1 = Convert.ToInt32(ddl1.SelectedValue); }

            DropDownList ddl2 = (DropDownList)i.FindControlRecursive("ddl2");
            if (ddl2 != null) { Me.NewShiftID2 = Convert.ToInt32(ddl2.SelectedValue); }

            // Fill Me with Original Shifts
            Label lblOriginalShift1 = (Label)i.FindControlRecursive("lblOriginalShift1");
            string ShiftCode1 = lblOriginalShift1.Text.ToString();
            Me.ShiftID1 = Convert.ToInt32(ddl1.Items.FindByText(ShiftCode1).Value);

            Label lblOriginalShift2 = (Label)i.FindControlRecursive("lblOriginalShift2");
            string ShiftCode2 = lblOriginalShift2.Text.ToString();
            Me.ShiftID2 = Convert.ToInt32(ddl1.Items.FindByText(ShiftCode2).Value);

            Me.isWorkingShift1 = Me.ShiftID1 < 49 ? 1 : 0;
            Me.isWorkingShift2 = Me.ShiftID2 < 49 ? 1 : 0;
            Me.isNewWorkingShift1 = Me.NewShiftID1 < 49 ? 1 : 0;
            Me.isNewWorkingShift2 = Me.NewShiftID2 < 49 ? 1 : 0;

            int originalHeadCount = Me.isWorkingShift1 + Me.isWorkingShift2;
            int postSwapHeadCount = Me.isNewWorkingShift1 + Me.isNewWorkingShift2;

            Me.InitiatedOn = DateTime.Now;
            // Validate Exact Swaps : For a given EmpCode1<>EmpCode2 & Date, check NewShiftID1= ShiftID2 and NewShiftID2=ShiftID1
            // This is the only valid case for which the Update should go through.            
            if (originalHeadCount == postSwapHeadCount && Me.ShiftID1 != Me.ShiftID2 && Me.NewShiftID1 == Me.ShiftID2 && Me.NewShiftID2 == Me.ShiftID1)
            {
                S.Add(Me);
            }
        }
        SwapShift.Save(S);
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {

    }
}

class SwapShift
{

    public DateTime Date { get; set; }
    public int EmpCode1 { get; set; }
    public int ShiftID1 { get; set; }
    public int isWorkingShift1 { get; set; }
    public int NewShiftID1 { get; set; }
    public int isNewWorkingShift1 { get; set; }
    public int EmpCode2 { get; set; }
    public int ShiftID2 { get; set; }
    public int isWorkingShift2 { get; set; }
    public int NewShiftID2 { get; set; }
    public int isNewWorkingShift2 { get; set; }
    public DateTime InitiatedOn { get; set; }
    public int ActionByEmpCode2 { get; set; }
    public DateTime? ActionByEmpCode2On { get; set; }
    public int RepMgrCode { get; set; }
    public int ActionByRepMgr { get; set; }
    public DateTime? ActionByRepMgrOn { get; set; }
    public bool isSwapCompliant { get; set; }


    public static int Save(SwapShift Me)
    {
        int rowsAffected = 0;
        int originalHeadCount = Me.isWorkingShift1 + Me.isWorkingShift2;
        int postSwapHeadCount = Me.isNewWorkingShift1 + Me.isNewWorkingShift2;
        if (originalHeadCount == postSwapHeadCount && Me.NewShiftID1 == Me.ShiftID2 && Me.NewShiftID2 == Me.ShiftID1)
        {
            rowsAffected += Insert(Me);
        }
        return rowsAffected;
    }

    public static int Save(List<SwapShift> Entries)
    {
        int rowsAffected = 0;
        foreach (SwapShift Me in Entries)
        {
            int originalHeadCount = Me.isWorkingShift1 + Me.isWorkingShift2;
            int postSwapHeadCount = Me.isNewWorkingShift1 + Me.isNewWorkingShift2;
            if (originalHeadCount == postSwapHeadCount && Me.ShiftID1 != Me.ShiftID2 && Me.NewShiftID1 == Me.ShiftID2 && Me.NewShiftID2 == Me.ShiftID1)
            {
                rowsAffected += Insert(Me);
            }
        }
        return rowsAffected;
    }


    private static int Insert(SwapShift s)
    {

        int rowsAffected = 0;
        Helper my = new Helper();
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            SqlCommand cmd = new SqlCommand("WFMP.SaveSwapToDB", cn);            
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Date", s.Date);
            cmd.Parameters.AddWithValue("@EmpCode1", s.EmpCode1);
            cmd.Parameters.AddWithValue("@ShiftID1", s.ShiftID1);
            cmd.Parameters.AddWithValue("@isWorkingShift1", s.isWorkingShift1);
            cmd.Parameters.AddWithValue("@NewShiftID1", s.NewShiftID1);
            cmd.Parameters.AddWithValue("@isNewWorkingShift1", s.isNewWorkingShift1);
            cmd.Parameters.AddWithValue("@EmpCode2", s.EmpCode2);
            cmd.Parameters.AddWithValue("@ShiftID2", s.ShiftID2);
            cmd.Parameters.AddWithValue("@isWorkingShift2", s.isWorkingShift2);
            cmd.Parameters.AddWithValue("@NewShiftID2", s.NewShiftID2);
            cmd.Parameters.AddWithValue("@isNewWorkingShift2", s.isNewWorkingShift2);
            cmd.Parameters.AddWithValue("@InitiatedOn", s.InitiatedOn);
            cmd.Parameters.AddWithValue("@ActionByEmpCode2", s.ActionByEmpCode2);
            cmd.Parameters.AddWithValue("@ActionByEmpCode2On", s.ActionByEmpCode2On);
            cmd.Parameters.AddWithValue("@RepMgrCode", s.RepMgrCode);
            cmd.Parameters.AddWithValue("@ActionByRepMgr", s.ActionByRepMgr);
            cmd.Parameters.AddWithValue("@ActionByRepMgrOn", s.ActionByRepMgrOn);
            cmd.Parameters.AddWithValue("@Operation", "INSERT_NEW_SWAP");
            

            rowsAffected = cmd.ExecuteNonQuery();
        }
        return rowsAffected;
    }

    private static int Update(SwapShift s)
    {
        Helper my = new Helper();
        int rowsAffected = 0;
        SqlCommand cmd = new SqlCommand("WFMP.SaveSwapToDB");
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Date", s.Date);
        cmd.Parameters.AddWithValue("@EmpCode1", s.EmpCode1);
        cmd.Parameters.AddWithValue("@ShiftID1", s.ShiftID1);
        cmd.Parameters.AddWithValue("@isWorkingShift1", s.isWorkingShift1);
        cmd.Parameters.AddWithValue("@NewShiftID1", s.NewShiftID1);
        cmd.Parameters.AddWithValue("@isNewWorkingShift1", s.isNewWorkingShift1);
        cmd.Parameters.AddWithValue("@EmpCode2", s.EmpCode2);
        cmd.Parameters.AddWithValue("@ShiftID2", s.ShiftID2);
        cmd.Parameters.AddWithValue("@isWorkingShift2", s.isWorkingShift2);
        cmd.Parameters.AddWithValue("@NewShiftID2", s.NewShiftID2);
        cmd.Parameters.AddWithValue("@isNewWorkingShift2", s.isNewWorkingShift2);
        cmd.Parameters.AddWithValue("@InitiatedOn", s.InitiatedOn);
        cmd.Parameters.AddWithValue("@ActionByEmpCode2", s.ActionByEmpCode2);
        cmd.Parameters.AddWithValue("@ActionByEmpCode2On", s.ActionByEmpCode2On);
        cmd.Parameters.AddWithValue("@RepMgrCode", s.RepMgrCode);
        cmd.Parameters.AddWithValue("@ActionByRepMgr", s.ActionByRepMgr);
        cmd.Parameters.AddWithValue("@ActionByRepMgrOn", s.ActionByRepMgrOn);
        cmd.Parameters.AddWithValue("@Operation", "UPDATE_SWAP");

        rowsAffected = cmd.ExecuteNonQuery();
        return rowsAffected;
    }
}
