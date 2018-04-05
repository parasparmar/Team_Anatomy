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

public partial class swap : System.Web.UI.Page
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
        //ddlWeek_SelectedIndexChanged(ddlYear, new EventArgs());
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


        SqlCommand cmd = new SqlCommand("[WFMP].[Swap_GetSwapWithinSpecificTeam]");
        cmd.Parameters.AddWithValue("@EmpID", this.MyEmpID);
        cmd.Parameters.AddWithValue("@FromDate", FromDate);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        dtSwapRoster = my.GetDataTableViaProcedure(ref cmd);

        string xTbl;

        xTbl = "<table class='xcls datatable table table-responsive table-condensed'>";
        xTbl += "<tr>";
        xTbl += "<th></th>";
        for (int xi = 1; xi <= dtSwapRoster.Columns.Count - 1; xi++)
        {
            xTbl += "<th>" + dtSwapRoster.Columns[xi].ColumnName.ToString() + "</th>";
        }
        xTbl += "</tr>";

        string xDisabled = "Disabled";
        for (int xr = 0; xr < dtSwapRoster.Rows.Count; xr++)
        {
            xTbl += "<tr>";
            if (xr > 0)
            {
                xDisabled = "";
            }


            xTbl += "<td><input type='radio' id='xRad' name='xRad' " + xDisabled + " value='" + dtSwapRoster.Rows[xr][1].ToString() + "' onchange='SetMyID(" + dtSwapRoster.Rows[xr][1].ToString() + ");' /></td>";
            for (int xi = 1; xi <= dtSwapRoster.Columns.Count - 1; xi++)
            {
                //if (xi > 2)
                //{
                //    xTbl += "<td><Select class='select2 form-control' style='width:100%;' id='"+ dtSwapRoster.Rows[xr][1].ToString() + "_"+ dtSwapRoster.Columns[xi].ColumnName.ToString() + "'>" + dtSwapRoster.Rows[xr][xi].ToString() + "</select></td>";
                //}
                //else
                //{
                xTbl += "<td>" + dtSwapRoster.Rows[xr][xi].ToString() + "</td>";
                //}
            }
            xTbl += "</tr>";
        }

        xTbl += "</table>";

        dvRoster.InnerHtml = xTbl;

        //dtSwapRosterWFormattedDates = dtSwapRoster;


        //string[] rowFields = { "ECN", "NAME" };
        //string[] columnFields = { "ShiftDate" };
        //Pivot pvt = new Pivot(dtSwapRosterWFormattedDates);
        //dtSwapRosterWFormattedDates = pvt.PivotData("ShiftCode", AggregateFunction.First, rowFields, columnFields);

        //DataRow[] foundRows = dtSwapRosterWFormattedDates.Select().OrderBy(u => u["Sort"]).ToArray();
        //dtSwapRosterWFormattedDates.Clear();
        //dtSwapRosterWFormattedDates = foundRows.CopyToDataTable();


        //DateTime colDate;
        //int RowCount = dtSwapRosterWFormattedDates.Rows.Count;
        //int ColCount = dtSwapRosterWFormattedDates.Columns.Count;
        //int i = 0;
        //foreach (DataColumn column in dtSwapRosterWFormattedDates.Columns)
        //{
        //    if (DateTime.TryParse(column.ColumnName, CultureInfo.InvariantCulture, DateTimeStyles.None, out colDate))
        //    {
        //        column.ColumnName = colDate.ToString("ddd, dd-MMM-yyyy");
        //        gvRoster.Columns[i].HeaderText = column.ColumnName.ToString();
        //    }
        //    i++;
        //}

        //gvRoster.DataSource = dtSwapRosterWFormattedDates;
        //gvRoster.DataBind();


    }

    private void fillgvSwap(int MyEmpID, int WeekID, int SwappedEmployeeID)
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
        dv.RowFilter = "ecn = " + MyEmpID.ToString() + " or ecn = " + SwappedEmployeeID.ToString();

        dtSwapRoster = dv.ToTable();

        string xTbl;
        string xDis;
        string xSel;
        DataTable xdt;

        xTbl = "<table id='tblSwap' runat='server' class='xcls datatable table table-responsive table-condensed'>";
        xTbl += "<tr>";

        for (int xi = 1; xi <= dtSwapRoster.Columns.Count - 1; xi++)
        {
            xTbl += "<th>" + dtSwapRoster.Columns[xi].ColumnName.ToString() + "</th>";
        }
        xTbl += "</tr>";


        for (int xr = 0; xr < dtSwapRoster.Rows.Count; xr++)
        {
            xTbl += "<tr>";




            for (int xi = 1; xi <= dtSwapRoster.Columns.Count - 1; xi++)
            {
                if (xi > 2)
                {
                    xTbl += "<td><Select class='form-control' style='width:100%;' id='" + dtSwapRoster.Rows[xr][1].ToString() + "_" + dtSwapRoster.Columns[xi].ColumnName.ToString() + "'>";
                    DateTime myDate;
                    if (DateTime.TryParseExact(dtSwapRoster.Columns[xi].ColumnName, "dd-MMM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out myDate))
                    {
                        //var query = dtSwapRoster.AsEnumerable()
                        //.Where(q => q.Field<string>(myDate.ToString("dd-MMM-yyyy")) == myDate.ToString("dd-MMM-yyyy"))
                        //.Where(q => q.Field<int>("ECN") == MyEmpID || q.Field<int>("ECN") == SwappedEmployeeID)
                        //.Select(q => new { ShiftCode = q.Field<string>("ShiftCode") }).Distinct().ToList();
                        //foreach (var q in query)
                        //{
                        //    xTbl += " <option value=''>" + q.ShiftCode + "</option>";
                        //}

                        string strSQL = "SELECT DISTINCT  SC.SHIFTID,SC.SHIFTCODE,EmpCode  FROM WFMP.ROSTERMST RM";
                        strSQL += " INNER JOIN WFMP.TBLSHIFTCODE SC ON SC.SHIFTID = RM.SHIFTID";
                        strSQL += " where EmpCode in (" + MyEmpID + ", " + SwappedEmployeeID + ")";
                        strSQL += " and rDate = '" + dtSwapRoster.Columns[xi].ColumnName + "'";
                        DataTable dt = my.GetData(strSQL);
                        int column_no = 0;
                        foreach(DataRow t in dt.Rows)
                        {
                            //string empid = dtSwapRoster.Rows[xr][1].ToString(); // myempid
                            ////myDate// thisdate
                            //if(dtSwapRoster.Columns[xi].ColumnName == myDate.ToString("dd-MMM-yyyy"))
                            //{
                            //    if(dtSwapRoster.Rows[xr][column_no].ToString() == t[0].ToString())
                            //    {

                            //    } 

                            //}

                            strSQL = "SELECT DISTINCT  SC.SHIFTID  FROM WFMP.ROSTERMST RM";
                            strSQL += " INNER JOIN WFMP.TBLSHIFTCODE SC ON SC.SHIFTID = RM.SHIFTID";
                            strSQL += " where EmpCode in (" + dtSwapRoster.Rows[xr][1].ToString() + ")";
                            strSQL += " and rDate = '" + dtSwapRoster.Columns[xi].ColumnName + "'";
                            xdt = my.GetData(strSQL);

                            xSel = "";
                            if (xdt.Rows[0][0].ToString() == t[0].ToString())
                            {
                                xSel = "selected";
                            }

                            //xDis = "";
                            //if (t[0].ToString() == "49")
                            //{
                            //    xDis = "Disabled";
                            //}
                            
                            xTbl += " <option "+ xSel + " value='" + t[0] + "'>" + t[1] + "</option>";
                            column_no++;
                        }
                    }



                    xTbl += " </select></td>";
                }
                else
                {
                    xTbl += "<td>" + dtSwapRoster.Rows[xr][xi].ToString() + "</td>";
                }
            }
            xTbl += "</tr>";
        }

        xTbl += "</table>";

        dvSwap.InnerHtml = xTbl;
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



    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        SwappedEmployeeID = Convert.ToInt32(xMyID.Value.ToString());
        WeekID = Convert.ToInt32(ddlWeek.SelectedValue.ToString());
        fillgvSwap(MyEmpID, WeekID, SwappedEmployeeID);
    }
}

class SwapShift
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
