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
using System.Web.UI.HtmlControls;


public partial class swap_p : System.Web.UI.Page
{
    public DataTable dtEmp;
    public DataTable dtSwapRoster;
    public DataTable dtSwapRosterWFormattedDates;
    Helper my;
    private string strSQL;
    private int MyEmpID { get; set; }
    private int SwappedEmployeeID { get; set; }
    private int SwappedIndex { get; set; }
    private int MyRepMgr { get; set; }

    private int WeekID { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();

        if (!IsPostBack)
        {
            try
            {
                dtEmp = (DataTable)Session["dtEmp"];
                if (dtEmp == null)
                {
                    Response.Redirect("index.aspx", false);
                }
                else
                {
                    // In Production Use the below
                    this.MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                    MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
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
            GetSelectedRecord();
            fillgvSwapStatus();
        }
        else
        {
            dtEmp = (DataTable)Session["dtEmp"];
            if (dtEmp == null)
            {
                Response.Redirect("index.aspx", false);
            }
            else
            {
                // In Production Use the below
                this.MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());
            }
        }

    }
    protected void fillddlYear()
    {
        strSQL = "select distinct ryear as Year from CWFM_Umang.WFMP.tblRstWeeks";
        my.append_dropdown(ref ddlYear, strSQL, 0, 0);
        ddlYear.SelectedIndex = ddlYear.Items.IndexOf(new ListItem(DateTime.Today.Year.ToString()));        
        ddlYear_SelectedIndexChanged(ddlYear, new EventArgs());


    }
    protected void ddlYear_SelectedIndexChanged(object sender, EventArgs e)
    {
        ltlReportingMgrsTeam.Text = "Step 1 : Swap Basics : Year Selected : " + ddlYear.SelectedItem.Text;
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
            //ddlWeek.SelectedIndex = ddlWeek.Items.IndexOf(ddlWeek.Items.FindByValue(RowID));
            ddlWeek.SelectedIndex = ddlWeek.Items.IndexOf(ddlWeek.Items.FindByValue(RowID));
        }
        else
        {
            ddlWeek.SelectedIndex = 0;
        }
        // To Do : The two lines below are only for convenience. THey should be removed from production, uat and development.
        ddlWeek.SelectedIndex = 0;

        // To Do : Let this line remain
        ddlWeek_SelectedIndexChanged(ddlYear, new EventArgs());
    }
    protected void ddlWeek_SelectedIndexChanged(object sender, EventArgs e)
    {
        
        if (ddlWeek.SelectedValue.Length > 0 && ddlYear.SelectedValue != "0")
        {

            WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
            ltlReportingMgrsTeam.Text = "Step 1 : Swap Basics : Week Selected : " + ddlWeek.SelectedItem.Text;
            fillgvRoster(this.MyEmpID, WeekID);
        }
    }
    /// <summary>
    /// Fills the Roster with shifts for all employees reporting to this employee's reporting manager.
    /// </summary>
    /// <param name="MyEmpID">The EmpID of the viewer</param>
    /// <param name="WeekID">The Week ID for the Selected dates</param>
    /// <param name="isInEditMode">Optional parameter. If true then the dropdowns are populated for the edit mode with unique shifts</param>
    private void fillgvRoster(int MyEmpID, int WeekID, bool isInEditMode = false)
    {
        DataTable dtDates = my.GetData("Select * from [WFMP].[tblRstWeeks] where WeekId = " + WeekID);
        DateTime FromDate = Convert.ToDateTime(dtDates.Rows[0]["FrDate"].ToString());
        DateTime ToDate = Convert.ToDateTime(dtDates.Rows[0]["ToDate"].ToString());
        DataTable dtShifts2Populate = my.GetData("Select ShiftID, ShiftCode from WFMP.tblShiftCode");


        SqlCommand cmd = new SqlCommand("[WFMP].[Swap_GetSwapWithinSpecificTeam_2]");
        cmd.Parameters.AddWithValue("@EmpID", this.MyEmpID);
        cmd.Parameters.AddWithValue("@FromDate", FromDate);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        dtSwapRoster = my.GetDataTableViaProcedure(ref cmd);
        string[] rowFields = { "xSort", "ECN", "NAME" };
        string[] columnFields = { "ShiftDate" };
        Pivot pvt = new Pivot(dtSwapRoster);
        dtSwapRoster = pvt.PivotData("ShiftCode", AggregateFunction.First, rowFields, columnFields);
        dtSwapRosterWFormattedDates = dtSwapRoster;



        DateTime colDate;
        int RowCount = dtSwapRosterWFormattedDates.Rows.Count;
        int ColCount = dtSwapRosterWFormattedDates.Columns.Count;
        int i = 0;
        foreach (DataColumn column in dtSwapRosterWFormattedDates.Columns)
        {
            if (DateTime.TryParse(column.ColumnName, CultureInfo.InvariantCulture, DateTimeStyles.None, out colDate))
            {
                column.ColumnName = colDate.ToString("ddd, dd-MMM-yyyy");
                gvRoster.Columns[i].HeaderText = column.ColumnName.ToString();
            }
            i++;
        }

        gvRoster.DataSource = dtSwapRosterWFormattedDates;
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
    protected void gvRoster_RowEditing(object sender, GridViewEditEventArgs e)
    {

        foreach (GridViewRow row in gvRoster.Rows)
        {
            if (row.Cells[0].Text == MyEmpID.ToString())
            {
                gvRoster.EditIndex = row.RowIndex;
                SwappedEmployeeID = Convert.ToInt32(gvRoster.Rows[e.NewEditIndex].Cells[0].Text);
                ViewState["SwappedEmployeeID"] = SwappedEmployeeID;
                SwappedIndex = e.NewEditIndex;
            }

        }
        //gvRoster.EditIndex = e.NewEditIndex;

        WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
        fillgvRoster(MyEmpID, WeekID, true);
    }
    protected void gvRoster_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowIndex > 0)
        {
            GridViewRow row = gvRoster.Rows[e.Row.RowIndex - 1];
            if (row.Cells[1].Text == MyEmpID.ToString())
            {
                RadioButton rdo = row.Cells[0].FindControl("rdSelect") as RadioButton;
                if (rdo != null) { rdo.Enabled = false; }

                if (dtSwapRoster != null && dtSwapRoster.Rows.Count > 0)
                {
                    for (int c = 2; c < row.Cells.Count; c++)
                    {
                        DropDownList l = row.FindControl("ddl" + (c - 2).ToString()) as DropDownList;
                        if (l != null)
                        {
                            string myDate = gvRoster.Columns[c].HeaderText.ToString();
                            DateTime dtThisDay = new DateTime();
                            if (DateTime.TryParseExact(myDate, "ddd, dd-MMM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dtThisDay))
                            {
                                var query = dtSwapRoster.AsEnumerable()
                                            .Where(s => s.Field<int>("ECN") == MyEmpID || s.Field<int>("ECN") == SwappedEmployeeID)
                                            .Where(s => s.Field<DateTime>("ShiftDate") == dtThisDay)
                                            .Select(p => new { ShiftID = p.Field<int>("ShiftID"), ShiftCode = p.Field<string>("ShiftCode") })
                                            .Distinct();

                                l.DataSource = query.ToList();
                                l.DataTextField = "ShiftCode";
                                l.DataValueField = "ShiftID";
                                l.SelectedIndex = 0;
                                l.DataBind();
                            }
                        }
                    }
                }
                else
                {
                    ControlCollection c = row.Cells[0].Controls;
                    c.Clear();
                    Literal lockIcon = new Literal();
                    lockIcon.Text = "<i class='glyphicon glyphicon-lock'></i>";
                    c.Add(lockIcon);
                }
            }
            if (row.Cells[1].Text == SwappedEmployeeID.ToString())
            {
                var c = row.Cells[0].Controls;
                c.Clear();
                Literal ExchangeIcon = new Literal();
                ExchangeIcon.Text = "<i class='fa fa-exchange'></i>";
                c.Add(ExchangeIcon);
            }
        }
    }
    private void GetSelectedRecord()
    {
        for (int i = 0; i < gvRoster.Rows.Count; i++)
        {
            RadioButton rb = (RadioButton)gvRoster.Rows[i].Cells[0].FindControl("rdSelect");
            if (rb != null)
            {
                if (rb.Checked)
                {
                    HiddenField hf = (HiddenField)gvRoster.Rows[i].Cells[0].FindControl("HiddenField1");
                    if (hf != null)
                    {
                        ViewState["SelectedSwapPartner"] = hf.Value;
                    }
                    break;
                }
            }
        }
    }
    private void SetSelectedRecord()
    {
        for (int i = 0; i < gvRoster.Rows.Count; i++)
        {
            RadioButton rb = (RadioButton)gvRoster.Rows[i].Cells[0].FindControl("rdSelect");
            if (rb != null)
            {
                HiddenField hf = (HiddenField)gvRoster.Rows[i].Cells[0].FindControl("HiddenField1");
                if (hf != null && ViewState["SelectedSwapPartner"] != null)
                {
                    if (hf.Value.Equals(ViewState["SelectedSwapPartner"].ToString()))
                    {
                        rb.Checked = true;
                        break;
                    }
                }
            }
        }
    }
    protected void rdSelect_CheckedChanged(object sender, EventArgs e)
    {
        string swapID;
        RadioButton rb = (RadioButton)sender;
        swapID = rb.Text;
        SwappedEmployeeID = Convert.ToInt32(swapID);
        WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
        fillSwapRepeater(SwappedEmployeeID, WeekID);
    }
    private void fillSwapRepeater(int SwappedEmployeeID, int WeekID)
    {
        DataTable dtDates = my.GetData("Select * from [WFMP].[tblRstWeeks] where WeekId = " + WeekID);
        DateTime FromDate = Convert.ToDateTime(dtDates.Rows[0]["FrDate"].ToString());
        DateTime ToDate = Convert.ToDateTime(dtDates.Rows[0]["ToDate"].ToString());
        DataTable dtShifts2Populate = my.GetData("Select ShiftID, ShiftCode from WFMP.tblShiftCode");

        SqlCommand cmd = new SqlCommand("[WFMP].[Swap_GetSwapWithinSpecificTeam]");
        cmd.Parameters.AddWithValue("@EmpID", this.MyEmpID);
        cmd.Parameters.AddWithValue("@FromDate", FromDate);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        dtSwapRoster = my.GetDataTableViaProcedure(ref cmd);
        DataView dv = new DataView(dtSwapRoster);
        dv.RowFilter = "ECN = " + MyEmpID + " or ECN = " + SwappedEmployeeID;
        dv.Sort = "xSort asc";
        dtSwapRoster = dv.ToTable();
        rptSwapStage2.DataSource = dtSwapRoster;
        rptSwapStage2.DataBind();
    }
    protected void rptSwapStage2_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Header)
        {
            for (int i = 1; i < dtSwapRoster.Columns.Count; i++)
            {
                Label h = e.Item.FindControl("h" + i) as Label;

                if (i < 3)
                {
                    h.Text = dtSwapRoster.Columns[i].ColumnName.ToString();
                }
                else
                {
                    DateTime dtShift = Convert.ToDateTime(dtSwapRoster.Columns[i].ColumnName.ToString());
                    h.Text = dtShift.Date.ToString("ddd, dd-MMM-yyyy");

                }

            }
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            for (int i = 1; i < dtSwapRoster.Columns.Count; i++)
            {
                Label h = e.Item.FindControl("lblHCBefore" + i) as Label;
                Label k = e.Item.FindControl("lblHCAfter" + i) as Label;
                if (i == 2)
                {
                    h.Text = "Working Headcount";
                }
                else if (i >= 3)
                {
                    // The sum of all shifts containing : and not equal to 00:00:00 to 00:00:00
                    int workingShifts = 0;
                    string columnName = dtSwapRoster.Columns[i].ColumnName.ToString();
                    var ids = dtSwapRoster.AsEnumerable().Select(r => r.Field<string>(columnName)).ToList();
                    foreach (string id in ids)
                    {
                        if (id.Contains(":") && id.Contains("-"))
                        {
                            workingShifts++;
                        }
                    }
                    h.Text = workingShifts.ToString();
                    k.Text = workingShifts.ToString();
                }

            }
        }

        if ((e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem) && e.Item.ItemIndex < 3)
        {
            for (int j = 1; j < dtSwapRoster.Columns.Count; j++)
            {
                if (j < 3)
                {
                    Label d = e.Item.FindControl("ddl" + j) as Label;
                    d.Text = dtSwapRoster.Rows[e.Item.ItemIndex][j].ToString();

                }
                else
                {
                    int toggle = 0;
                    if (e.Item.ItemIndex == 0) { toggle = 1; } else { toggle = 0; }
                    DropDownList ddl = e.Item.FindControl("ddl" + j) as DropDownList;
                    string myShift = dtSwapRoster.Rows[e.Item.ItemIndex][j].ToString();
                    string SwappableShift = dtSwapRoster.Rows[toggle][j].ToString();
                    ListItem li1 = new ListItem(myShift);
                    ddl.Items.Add(li1);

                    //Duplicate Shifts Eliminated.
                    if (myShift != SwappableShift)
                    {
                        ListItem li2 = new ListItem(SwappableShift);
                        ddl.Items.Add(li2);
                    }

                    ddl.SelectedValue = myShift;

                    // Before Label populated
                    Label d = e.Item.FindControl("lblBefore" + j) as Label;
                    d.Text = dtSwapRoster.Rows[e.Item.ItemIndex][j].ToString();
                }
            }
        }
    }
    protected void btnSubmitStage3_Click(object sender, EventArgs e)
    {
        // Convert ShiftCodes to IDs by looking up the shiftcode table
        string strSQL = "select ShiftID, ShiftCode from WFMP.tblShiftCode where Active=1";
        DataTable dtShiftCodes = my.GetData(strSQL);
        Dictionary<string, int> dcShiftLookup = dtShiftCodes.AsEnumerable()
            .ToDictionary(row => row.Field<string>("ShiftCode"), row => row.Field<int>("ShiftID"));

        List<SwapShift> P = new List<SwapShift>();
        Label lblEmpCode1 = rptSwapStage2.Items[0].FindControl("ddl1") as Label;
        Label lblEmpCode2 = rptSwapStage2.Items[1].FindControl("ddl1") as Label;

        for (int j = 1; j <= 9; j++)
        {
            SwapShift me = new SwapShift();
            me.EmpCode1 = Convert.ToInt32(lblEmpCode1.Text.ToString());
            me.EmpCode2 = Convert.ToInt32(lblEmpCode2.Text.ToString());

            if (j > 2)
            {
                Label lblDate = rptSwapStage2.Controls[0].Controls[0].FindControl("h" + j) as Label;
                DateTime DateOfSwap;
                if (DateTime.TryParse(lblDate.Text, out DateOfSwap)) { me.Date = DateOfSwap; }

                Label lblBeforeShift1 = rptSwapStage2.Items[0].FindControl("lblBefore" + j) as Label;
                me.ShiftCode1 = lblBeforeShift1.Text;
                me.ShiftID1 = dcShiftLookup[me.ShiftCode1];

                DropDownList ddlAfterShift1 = rptSwapStage2.Items[0].FindControl("ddl" + j) as DropDownList;
                if (ddlAfterShift1 != null)
                {
                    me.NewShiftCode1 = ddlAfterShift1.SelectedValue;
                    me.NewShiftID1 = dcShiftLookup[me.NewShiftCode1];
                }

                Label lblBeforeShift2 = rptSwapStage2.Items[1].FindControl("lblBefore" + j) as Label;
                me.ShiftCode2 = lblBeforeShift2.Text;
                me.ShiftID2 = dcShiftLookup[me.ShiftCode2];

                DropDownList ddlAfterShift2 = rptSwapStage2.Items[1].FindControl("ddl" + j) as DropDownList;
                if (ddlAfterShift2 != null)
                {
                    me.NewShiftCode2 = ddlAfterShift2.SelectedValue;
                    me.NewShiftID2 = dcShiftLookup[me.NewShiftCode2];
                }
                me.RepMgrCode = MyRepMgr;
                me.InitiatedOn = DateTime.Now;
                me.Active = 1;

                // Basic Valid Swap 
                if (me.ShiftCode1 == me.NewShiftCode2 && me.ShiftCode2 == me.NewShiftCode1 && me.ShiftCode1 != me.ShiftCode2)
                {
                    P.Add(me);
                }

            }
        }
        SwapShift.Save(P);
        fillgvSwapStatus();
    }
    protected void btnCancelStage3_Click(object sender, EventArgs e)
    {

        fillgvSwapStatus();
    }
    private void fillgvSwapStatus()
    {
        string strSQL = "WFMP.Swap_getSwapStatus";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);

        if (ddlRole.SelectedValue.ToString() == "Reporting_Manager")
        {
            cmd.Parameters.AddWithValue("@Role", "Reporting_Manager");
        }
        else
        {
            cmd.Parameters.AddWithValue("@Role", "Employee");
        }


        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        gvSwapStatus.DataSource = dt;
        gvSwapStatus.DataBind();
        foreach (GridViewRow r in gvSwapStatus.Rows)
        {
            int Id = Convert.ToInt32(r.Cells[0].Text);
            var swaps = from s in dt.AsEnumerable()
                        where s.Field<int>("Id") == Id
                        select s;
            var t = swaps.FirstOrDefault();
            int EmpCode1 = t.Field<int>("EmpCode1");
            int EmpCode2 = t.Field<int>("EmpCode2");
            int RepMgrCode = t.Field<int>("RepMgrCode");


            Panel pnlPendingActions = (Panel)r.FindControl("pnlPendingActions");
            Panel pnlSwapInformation = (Panel)r.FindControl("pnlSwapInformation");
            Label lblSwapInformation = (Label)r.FindControl("lblSwapInformation");

            //Pending at or Completely approved.
            int ApproverAction = t.Field<int>("ApproverAction");
            int RepMgrAction = t.Field<int>("RepMgrAction");

            // if I am EmpCode1 
            if (EmpCode1 == MyEmpID)
            {
                pnlPendingActions.Visible = false;
                pnlSwapInformation.Visible = true;

                if (ApproverAction == 1 && RepMgrAction == 1)
                {
                    pnlPendingActions.Visible = false;
                    pnlSwapInformation.Visible = true;
                    lblSwapInformation.Text = "Approved";
                }
                else if (ApproverAction == 2 || RepMgrAction == 2)
                {
                    pnlPendingActions.Visible = false;
                    pnlSwapInformation.Visible = true;
                    lblSwapInformation.Text = "Declined";
                }
                else if (ApproverAction == 0 || RepMgrAction == 0)
                {
                    pnlPendingActions.Visible = false;
                    pnlSwapInformation.Visible = true;
                    lblSwapInformation.Text = "Pending";
                }

            }
            // if I am EmpCode2, have I approved/declined already
            else if (EmpCode2 == MyEmpID)
            {
                if (ApproverAction == 1)
                {
                    pnlPendingActions.Visible = false;
                    pnlSwapInformation.Visible = true;
                    lblSwapInformation.Text = "Approved by you : " + t.Field<DateTime>("ApproverActionDate").ToString("dd-MMM-yyyy HH:mm:ss");
                }
                else if (ApproverAction == 2)
                {
                    pnlPendingActions.Visible = false;
                    pnlSwapInformation.Visible = true;
                    lblSwapInformation.Text = "Declined by you : " + t.Field<DateTime>("ApproverActionDate").ToString("dd-MMM-yyyy HH:mm:ss");
                }
                else
                {
                    pnlPendingActions.Visible = true;
                    pnlSwapInformation.Visible = false;
                }

            }
            // if I am RepMgrCode, have I approved/declined already
            else if (RepMgrCode == MyEmpID)
            {
                if (RepMgrAction == 1)
                {
                    pnlPendingActions.Visible = false;
                    pnlSwapInformation.Visible = true;
                    lblSwapInformation.Text = "Approved by you : " + t.Field<DateTime>("RepMgrActionDate").ToString("dd-MMM-yyyy HH:mm:ss");
                }
                else if (RepMgrAction == 2)
                {
                    pnlPendingActions.Visible = false;
                    pnlSwapInformation.Visible = true;
                    lblSwapInformation.Text = "Declined by you : " + t.Field<DateTime>("RepMgrActionDate").ToString("dd-MMM-yyyy HH:mm:ss");
                }
                else
                {
                    pnlPendingActions.Visible = true;
                    pnlSwapInformation.Visible = false;
                }
            }
        }

    }
    protected void btnApprove_Click(object sender, EventArgs e)
    {
        Button btnApprove = sender as Button;
        int ID = Convert.ToInt32(btnApprove.CommandArgument.ToString());
        SwapShift S = new SwapShift(ID);
        S.ApproveSwap(MyEmpID);
        fillgvSwapStatus();
    }
    protected void btnDecline_Click(object sender, EventArgs e)
    {
        Button btnDecline = sender as Button;
        int ID = Convert.ToInt32(btnDecline.CommandArgument.ToString());
        SwapShift S = new SwapShift(ID);
        S.DeclineSwap(MyEmpID);
        fillgvSwapStatus();
    }
    protected void ddlRole_SelectedIndexChanged(object sender, EventArgs e)
    {

    }



    protected void hdShouldIProceed_ValueChanged(object sender, EventArgs e)
    {
        if (hdShouldIProceed.Value == "1")
        {
            pnlEnableSubmission.Visible = true;
        }
        else
        {
            pnlEnableSubmission.Visible = false;
        }
    }
}

class SwapShift
{
    public int ID { get; private set; }
    public DateTime Date { get; set; }
    public int EmpCode1 { get; set; }
    public int ShiftID1 { get; set; }
    public string ShiftCode1 { get; set; }
    public int isWorkingShift1 { get; set; }
    public int NewShiftID1 { get; set; }
    public string NewShiftCode1 { get; set; }
    public int isNewWorkingShift1 { get; set; }
    public int EmpCode2 { get; set; }
    public int ShiftID2 { get; set; }
    public string ShiftCode2 { get; set; }
    public int isWorkingShift2 { get; set; }
    public int NewShiftID2 { get; set; }
    public string NewShiftCode2 { get; set; }
    public int isNewWorkingShift2 { get; set; }
    public DateTime InitiatedOn { get; set; }
    public int ActionByEmpCode2 { get; set; }
    public DateTime? ActionByEmpCode2On { get; set; }
    public int RepMgrCode { get; set; }
    public int ActionByRepMgr { get; set; }
    public DateTime? ActionByRepMgrOn { get; set; }
    public int Active { get; set; }

    public SwapShift() { }
    public SwapShift(int ID)
    {
        string strSQL = "select * from WFMP.tblSwap A where id=@Id";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Id", ID);
        Helper my = new Helper();
        DataTable dt = my.GetData(ref cmd);
        if (dt != null && dt.Rows.Count > 0)
        {
            this.Date = Convert.ToDateTime(dt.Rows[0]["Date"].ToString());
            this.EmpCode1 = Convert.ToInt32(dt.Rows[0]["EmpCode1"].ToString());
            this.ShiftID1 = Convert.ToInt32(dt.Rows[0]["ShiftID1"].ToString());
            this.isWorkingShift1 = Convert.ToInt32(dt.Rows[0]["isWorkingShift1"].ToString());
            this.NewShiftID1 = Convert.ToInt32(dt.Rows[0]["NewShiftID1"].ToString());
            this.isNewWorkingShift1 = Convert.ToInt32(dt.Rows[0]["isNewWorkingShift1"].ToString());
            this.EmpCode2 = Convert.ToInt32(dt.Rows[0]["EmpCode2"].ToString());
            this.ShiftID2 = Convert.ToInt32(dt.Rows[0]["ShiftID2"].ToString());
            this.isWorkingShift2 = Convert.ToInt32(dt.Rows[0]["isWorkingShift2"].ToString());
            this.NewShiftID2 = Convert.ToInt32(dt.Rows[0]["NewShiftID2"].ToString());
            this.InitiatedOn = Convert.ToDateTime(dt.Rows[0]["InitiatedOn"].ToString());
            this.ActionByEmpCode2 = Convert.ToInt32(dt.Rows[0]["ActionByEmpCode2"].ToString());
            if (dt.Rows[0]["ActionByEmpCode2On"].ToString().Length > 0) { this.ActionByEmpCode2On = Convert.ToDateTime(dt.Rows[0]["ActionByEmpCode2On"].ToString()); }
            this.RepMgrCode = Convert.ToInt32(dt.Rows[0]["RepMgrCode"].ToString());
            if (dt.Rows[0]["ActionByRepMgrOn"].ToString().Length > 0) { this.ActionByRepMgrOn = Convert.ToDateTime(dt.Rows[0]["ActionByRepMgrOn"].ToString()); }
            this.Active = Convert.ToInt32(dt.Rows[0]["Active"].ToString());
        }

    }
    public bool ApproveSwap(int SenderEmpCode)
    {
        if (SenderEmpCode == this.EmpCode1) { return false; }
        else if (SenderEmpCode == this.EmpCode2)
        {
            this.ActionByEmpCode2 = 1;
            this.ActionByEmpCode2On = DateTime.Now;
            Update(this);
            return true;
        }
        else if (SenderEmpCode == this.RepMgrCode)
        {
            this.ActionByRepMgr = 1;
            this.ActionByRepMgrOn = DateTime.Now;
            Update(this);
            return true;
        }
        else
        {
            return false;
        }
    }
    public bool DeclineSwap(int SenderEmpCode)
    {
        if (SenderEmpCode == this.EmpCode1)
        {
            return false;
        }
        else if (SenderEmpCode == this.EmpCode2)
        {
            this.ActionByEmpCode2 = 2;
            this.ActionByEmpCode2On = DateTime.Now;
            Update(this);
            return true;
        }
        else if (SenderEmpCode == this.RepMgrCode)
        {
            this.ActionByRepMgr = 2;
            this.ActionByRepMgrOn = DateTime.Now;
            Update(this);
            return true;
        }
        else
        {
            return false;
        }

    }
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
            SqlCommand cmd = new SqlCommand("WFMP.Swap_Save2DB", cn);
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
        SqlCommand cmd = new SqlCommand("WFMP.Swap_Save2DB");
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

        rowsAffected = my.ExecuteDMLCommand(ref cmd, cmd.CommandText, "S");

        // This will actually commit all approved swaps to the roster.
        Commit2Roster();
        return rowsAffected;

    }
    private static int Commit2Roster()
    {
        Helper my = new Helper();
        SqlCommand cmd = new SqlCommand("WFMP.Swap_Commit2Roster");
        my.ExecuteDMLCommand(ref cmd, "WFMP.Swap_Commit2Roster", "S");
        return 0;
    }
}
