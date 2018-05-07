﻿using System;
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

public partial class swap_horizontal : System.Web.UI.Page
{
    public DataTable dtEmp;
    public DataTable dtSwapRoster;
    Helper my;
    private string strSQL;
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
            fillgvSwapStatus();
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
        ltlReportingMgrsTeam.Text = "Roster For " + ddlYear.SelectedItem.Text;
        ddlYear_SelectedIndexChanged(ddlYear, new EventArgs());
        
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

        SqlCommand cmd = new SqlCommand("[WFMP].[Swap_GetSwapWithinSpecificTeam]");
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
            //if (gv.Rows[i].Cells[1].Text == SwappedEmployeeID.ToString())
            //{
            //    gv.Rows[i].CssClass = "";
            //}
            if (gv.Rows[i].Cells[1].Text == MyEmpID.ToString())
            {
                Button btnInitiateSwap = gv.Rows[i].Cells[0].FindControl("btnInitiateSwap") as Button;
                btnInitiateSwap.Enabled = false;
                btnInitiateSwap.CssClass = "btn btn-info disabled";
                btnInitiateSwap.Text = "Roster";
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
        foreach (GridViewRow r in gvRoster.Rows)
        {
            Button b = r.Cells[0].FindControl("btnInitiateSwap") as Button;
            if (b.CssClass == "btn btn-primary")
            {
                b.CssClass += " disabled";
                b.Text = "Locked";
            }

        }
        litab_1.Attributes.Remove("class");        
        tab_1.Attributes.Remove("class");
        tab_1.Attributes.Add("class", "tab-pane");


        litab_2.Attributes.Add("class", "active");
        tab_2.Attributes.Remove("class");
        tab_2.Attributes.Add("class", "tab-pane active");
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

        SqlCommand cmd = new SqlCommand("[WFMP].[Swap_GetSwapBetweenSpecificEmployees]");
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
            HiddenField hfPleaseLock = e.Item.FindControlRecursive("hfPleaseLock") as HiddenField;
            int PleaseLock = Convert.ToInt32(hfPleaseLock.Value);


            DropDownList D1 = ((DropDownList)e.Item.FindControl("ddl1"));
            DropDownList D2 = ((DropDownList)e.Item.FindControl("ddl2"));
            ListItemCollection L = new ListItemCollection();

            ListItem L1 = new ListItem(dtSwapRoster.Rows[e.Item.ItemIndex]["ShiftCode1"].ToString(), dtSwapRoster.Rows[e.Item.ItemIndex]["ShiftId1"].ToString());
            ListItem L2 = new ListItem(dtSwapRoster.Rows[e.Item.ItemIndex]["ShiftCode2"].ToString(), dtSwapRoster.Rows[e.Item.ItemIndex]["ShiftId2"].ToString());

            if (PleaseLock == 1)
            {
                HtmlButton btn = (HtmlButton)e.Item.FindControlRecursive("btnSwapShift");
                if (btn != null)
                {
                    btn.Attributes.Remove("class");
                    btn.Attributes.Add("class", "btn btn-warning disabled"); 
                }


                L.Clear();
                L.Add(L1);
                D1.DataSource = L;
                D1.DataTextField = "Text";
                D1.DataValueField = "Value";
                D1.DataBind();

                L.Clear();
                L.Add(L2);
                D2.DataSource = L;
                D2.DataTextField = "Text";
                D2.DataValueField = "Value";
                D2.DataBind();

                D1.SelectedValue = L1.Value;
                D2.SelectedValue = L2.Value;

                D1.Enabled = false;
                D2.Enabled = false;
            }
            else
            {
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
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        InitiateSaveProcess();
    }
    private void InitiateSaveProcess()
    {
        List<SwapShift_Horizontal> S = new List<SwapShift_Horizontal>();
        Label EmpCode1 = (Label)rptrSwapForm.FindControlRecursive("lblEmp1");
        int ECN1 = Convert.ToInt32(EmpCode1.Text.ToString());

        Label EmpCode2 = (Label)rptrSwapForm.FindControlRecursive("lblEmp2");
        int ECN2 = Convert.ToInt32(EmpCode2.Text.ToString());

        foreach (RepeaterItem i in rptrSwapForm.Items)
        {
            SwapShift_Horizontal Me = new SwapShift_Horizontal();
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
            if (ddl1 != null && ddl1.SelectedValue != null) { Me.NewShiftID1 = Convert.ToInt32(ddl1.SelectedValue); }

            DropDownList ddl2 = (DropDownList)i.FindControlRecursive("ddl2");
            if (ddl2 != null && ddl2.SelectedValue != null) { Me.NewShiftID2 = Convert.ToInt32(ddl2.SelectedValue); }
            // Fail First, Fail Fast.
            if (Me.NewShiftID1 != 0 && Me.NewShiftID2 != 0)
            {
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
        }
        if (S.Count > 0) { SwapShift_Horizontal.Save(S); }
    }
    protected void ddlRole_SelectedIndexChanged(object sender, EventArgs e)
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
    protected void btn_appr_Click(object sender, EventArgs e)
    {

        //ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "hideModal();", true);
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "show", "toastA();", true);
    }
    protected void btnApprove_Click(object sender, EventArgs e)
    {

        Button btnApprove = sender as Button;
        int ID = Convert.ToInt32(btnApprove.CommandArgument.ToString());
        SwapShift_Horizontal S = new SwapShift_Horizontal(ID);
        S.ApproveSwap(MyEmpID);
        fillgvSwapStatus();
    }
    protected void btnDecline_Click(object sender, EventArgs e)
    {
        Button btnApprove = sender as Button;
        int ID = Convert.ToInt32(btnApprove.CommandArgument.ToString());
        SwapShift_Horizontal S = new SwapShift_Horizontal(ID);
        S.DeclineSwap(MyEmpID);
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow r in gvRoster.Rows)
        {
            Button b = r.Cells[0].FindControl("btnInitiateSwap") as Button;
            if (b.CssClass == "btn btn-primary disabled")
            {
                b.CssClass = "btn btn-primary";
                b.Text = "Select";
            }
        }
        fillgvSwapStatus();
        rptrSwapForm.DataSource = null;
        rptrSwapForm.DataBind();

        litab_1.Attributes.Add("class", "active");
        tab_1.Attributes.Remove("class");
        tab_1.Attributes.Add("class", "tab-pane active");
        
        litab_2.Attributes.Remove("class");
        tab_2.Attributes.Remove("class");
        tab_2.Attributes.Add("class", "tab-pane");
    }
    protected void gvSwapStatus_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
}

class SwapShift_Horizontal
{
    public int ID { get; private set; }
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
    public int Active { get; set; }



    public SwapShift_Horizontal() { }
    public SwapShift_Horizontal(int ID)
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

    public static int Save(SwapShift_Horizontal Me)
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

    public static int Save(List<SwapShift_Horizontal> Entries)
    {
        int rowsAffected = 0;
        foreach (SwapShift_Horizontal Me in Entries)
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


    private static int Insert(SwapShift_Horizontal s)
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

    private static int Update(SwapShift_Horizontal s)
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