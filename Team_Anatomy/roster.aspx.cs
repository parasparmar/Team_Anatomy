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
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
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
    private void fillgvRoster(int RepMgrCode, int WeekID, int OffsetTheWeekBy = 0)
    {

        SqlCommand cmd = new SqlCommand("[WFMP].[GetRosterInformation]");
        cmd.Parameters.AddWithValue("@RepMgrCode", RepMgrCode);
        // The Offset is incase the previous weeks roster needs to be replicated for today.
        WeekID = WeekID + OffsetTheWeekBy;
        cmd.Parameters.AddWithValue("@WeekID", WeekID);
        dtEmp = my.GetDataTableViaProcedure(ref cmd);
        while (dtEmp.Columns.Count > 9)
        {
            dtEmp.Columns.RemoveAt(9);
        }
        if (OffsetTheWeekBy != 0)
        {
            for (int j = 2; j < dtEmp.Columns.Count; j++)
            {
                // The Offset is incase the previous weeks roster needs to be replicated for today.
                string newName = Convert.ToDateTime(dtEmp.Columns[j].ColumnName).AddDays(7).ToString("dd-MMM-yyyy");
                dtEmp.Columns[j].ColumnName = newName;
            }
        }

        gvRoster.DataSource = dtEmp;
        int RowCount = dtEmp.Rows.Count;


        int ColCount = dtEmp.Columns.Count;
        strSQL = "SELECT [ShiftID],[ShiftCode] FROM [CWFM_Umang].[WFMP].[tblShiftCode] where [Active] = 1";
        DataTable dt1 = my.GetData(strSQL);
        string ddlName;
        // Set the date Header rows
        // The gvRoster has dates beginning from 3rd column onwards and shows 7 dates. ie:- indices 2 through ColCount-1 = 8

        string colName;
        DateTime colDate;
        for (int j = 0; j < ColCount; j++)
        {
            colName = dtEmp.Columns[j].ColumnName;

            if (DateTime.TryParseExact(colName, "dd-MMM-yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out colDate))
            {
                gvRoster.Columns[j].HeaderText = colDate.ToString("ddd, dd-MMM-yyyy");
            }
            else
            {
                gvRoster.Columns[j].HeaderText = colName;
            }
        }
        gvRoster.DataBind();

        for (int i = 0; i < RowCount; i++)
        {
            for (int j = 0; j < ColCount; j++)
            {

                if (j > 1)
                {
                    //Set headers for Date Columns only    
                    ddlName = "dd" + (j - 1);
                    DropDownList v = (DropDownList)gvRoster.Rows[i].FindControl(ddlName);
                    ListItem NullShift = new ListItem("--", "0");
                    v.Items.Add(NullShift);

                    foreach (DataRow dr in dt1.Rows)
                    {
                        ListItem ShiftCode = new ListItem();
                        ShiftCode.Text = dr["ShiftCode"].ToString();
                        ShiftCode.Value = dr["ShiftID"].ToString();
                        v.Items.Add(ShiftCode);

                    }
                    v.SelectedIndex = v.Items.IndexOf(v.Items.FindByValue(dtEmp.Rows[i][j].ToString()));
                }
            }

        }


    }
    private void userCannotEditHisRosterRow()
    {

        if (Role == (int)role.MySelf)
        {
            foreach (GridViewRow gvRows in gvRoster.Rows)
            {
                int gvEmpID;
                var gvCell = gvRows.Cells[0].FindControl("EmpID");
                if (Int32.TryParse(gvCell.ToString(), out gvEmpID))
                {
                    if (gvEmpID == MyEmpID)
                    {
                        for (int i = 0; i <= 7; i++)
                        {
                            gvRows.Cells[i].CssClass += "read-only";
                        }
                    }
                }

            }

        }
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

        int RepMgrCode = Convert.ToInt32(ddlRepManager.SelectedValue);
        int WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
        int UpdatedBy = MyEmpID;
        DateTime updatedOn = DateTime.Now;

        string strSQL = "SELECT * FROM [CWFM_Umang].[WFMP].[RosterMst] where [RepMgrCode] = @RepMgrCode ";
        strSQL += " and [WeekID] = @WeekID";

        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            SqlCommand cmd = new SqlCommand(strSQL, cn);
            cmd.Parameters.AddWithValue("@RepMgrCode", RepMgrCode);
            cmd.Parameters.AddWithValue("@WeekID", WeekID);

            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                using (SqlCommandBuilder cb = new SqlCommandBuilder(da))
                {
                    using (DataSet X = new DataSet())
                    {
                        da.Fill(X);
                        List<RosterRecord> ListOfR = new List<RosterRecord>();
                        int CellCount = gvRoster.Columns.Count;
                        foreach (GridViewRow Row in gvRoster.Rows)
                        {
                            int TheEmpCode = Convert.ToInt32(Row.Cells[0].Text.ToString());
                            for (int j = 2; j < CellCount; j++)
                            {
                                RosterRecord R = new RosterRecord();
                                R.EmpCode = TheEmpCode;
                                R.rDate = Convert.ToDateTime(gvRoster.Columns[j].HeaderText);
                                DropDownList ddl = (DropDownList)Row.Cells[j].FindControl("dd" + (j - 1));
                                R.ShiftID = Convert.ToInt32(ddl.SelectedValue);
                                R.RepMgrCode = RepMgrCode;
                                R.WeekID = WeekID;
                                R.UpdatedBy = UpdatedBy;
                                R.updatedOn = updatedOn;
                                ListOfR.Add(R);
                            }
                        }
                        // Before an update to db, check for rules compliance
                        bool RosterRulesCompliance = isRosterRuleCompliant(ref ListOfR);
                        if (RosterRulesCompliance)
                        {
                            foreach (RosterRecord R in ListOfR)
                            {
                                // Select all rows in Dataset from DB with this ECN and this Date.
                                // The rDate has time information and hence the 'between' operator is critical.
                                // Between is not available in the datatable.select method hence the usage of >= and <.
                                DataRow[] drc = X.Tables[0].Select("EmpCode = " + R.EmpCode + " and rDate >= #" + R.rDate + "# and rDate <#" + R.rDate.AddDays(1) + "#");

                                if (drc.Length > 0)
                                {
                                    DataRow dr = drc[0];
                                    if (dr["ShiftID"].ToString() != R.ShiftID.ToString())
                                    {
                                        dr["WeekID"] = R.WeekID;
                                        dr["rDate"] = R.rDate;
                                        dr["ShiftID"] = R.ShiftID;
                                        dr["RepMgrCode"] = R.RepMgrCode;
                                        dr["UpdatedBy"] = R.UpdatedBy;
                                        dr["updatedOn"] = R.updatedOn;
                                    }
                                    // Delete duplicate shifts if any.
                                    for (int i = 1; i < drc.Length; i++)
                                    {
                                        drc[i].Delete();
                                    }
                                }
                                else if (drc.Length == 0)
                                {
                                    DataRow dr = X.Tables[0].NewRow();
                                    dr["EmpCode"] = R.EmpCode;
                                    dr["WeekID"] = R.WeekID;
                                    dr["rDate"] = R.rDate;
                                    dr["ShiftID"] = R.ShiftID;
                                    dr["RepMgrCode"] = R.RepMgrCode;
                                    dr["UpdatedBy"] = R.UpdatedBy;
                                    dr["updatedOn"] = R.updatedOn;
                                    X.Tables[0].Rows.Add(dr);
                                }
                            }
                            int rowsAffected = da.Update(X);
                        }
                        else
                        {
                            // in case of non compliance, point out to the user, reason for non compliance.
                            var nonCompliantRosterees = ListOfR.Where(i => i.rules_WorkOffCompliance == false);
                            foreach (var ncr in nonCompliantRosterees)
                            {
                                int emp = ncr.EmpCode;
                                DateTime rDate = ncr.rDate;

                            }

                        }
                    }
                }
            }
        }

    }
    private bool isRosterRuleCompliant(ref List<RosterRecord> ListOfR)
    {
        bool complianceStatus = true;
        complianceStatus = CountOfWOBetween1and2(ref ListOfR) && complianceStatus;
        return complianceStatus;
    }
    private bool CountOfWOBetween1and2(ref List<RosterRecord> ListOfR)
    {

        bool complianceStatus = true;
        var employees = ListOfR.Where(i => i.ShiftID == 49);
        foreach (var employee in employees)
        {
            int WOCount = 0;
            if (employee.ShiftID == 49)
            {
                employee.WOCount = WOCount++;
                if (employee.WOCount >= 2 || employee.WOCount < 1)
                {
                    employee.rules_WorkOffCompliance = false;
                    complianceStatus = false && complianceStatus;
                }
                else
                {
                    employee.rules_WorkOffCompliance = true;
                    complianceStatus = true && complianceStatus;
                }
            }
        }
        return complianceStatus;
    }
    protected void btnWeeks_Click(object sender, EventArgs e)
    {
        if (ddlRepManager.SelectedValue.Length > 0 && ddlWeek.SelectedValue.Length > 0 && ddlYear.SelectedValue != "0")
        {
            int RepMgrCode = Convert.ToInt32(ddlRepManager.SelectedValue);
            int WeekID = Convert.ToInt32(ddlWeek.SelectedValue);

            fillgvRoster(RepMgrCode, WeekID, -1);
        }
    }
    private void loadApprovedLeaves()
    {

        strSQL = "[WFMP].[Roster_loadLeaves]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@RepMgrCode", ddlRepManager.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@WeekId", ddlWeek.SelectedValue.ToString());

        DataTable dtleaves = my.GetDataTableViaProcedure(ref cmd);
        int gvRows = gvRoster.Rows.Count;
        int gvColumns = gvRoster.Columns.Count;
        int[] EmpLocation = new int[gvRows];
        DateTime[] DateLocation = new DateTime[gvColumns];

        for (int i = 0; i < gvRows; i++)
        {
            EmpLocation[i] = Convert.ToInt32(gvRoster.Rows[i].Cells[0].Text);
        }

        for (int j = 0; j < gvColumns; j++)
        {
            if (j > 1)
            {
                DateLocation[j] = Convert.ToDateTime(gvRoster.Columns[j].HeaderText);
            }
        }
        string ddlID = string.Empty;
        foreach (DataRow c in dtleaves.Rows)
        {
            int dtECN = Convert.ToInt32(c["ECN"].ToString());
            DateTime dtTheDate = Convert.ToDateTime(c["LeaveDate"].ToString());
            string LeaveShiftCode = c["LeaveShiftCode"].ToString();

            int i = Array.IndexOf(EmpLocation, dtECN);
            int j = Array.IndexOf(DateLocation, dtTheDate);

            TableCell me = gvRoster.Rows[i].Cells[j];
            me.CssClass = "bg-teal";
            foreach (Control ddl in me.Controls)
            {
                if (ddl is DropDownList)
                {
                    DropDownList d = (DropDownList)ddl;
                    d.SelectedIndex = d.Items.IndexOf(d.Items.FindByValue(LeaveShiftCode));
                }
            }
        }



    }
    protected void btnLoadLeaves_Click(object sender, EventArgs e)
    {
        if (gvRoster.Rows.Count > 0)
        {
            loadApprovedLeaves();

        }
    }
    protected void btnCancelledLeaves_Click(object sender, EventArgs e)
    {
        if (!cbxCancelledLeaves.Checked)
        {
            strSQL = "[WFMP].[Roster_loadCancelledLeaves]";
            SqlCommand cmd = new SqlCommand(strSQL);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@RepMgrCode", ddlRepManager.SelectedValue.ToString());
            cmd.Parameters.AddWithValue("@WeekId", ddlWeek.SelectedValue.ToString());

            DataTable dtleaves = my.GetDataTableViaProcedure(ref cmd);
            int gvRows = gvRoster.Rows.Count;
            int gvColumns = gvRoster.Columns.Count;
            int[] EmpLocation = new int[gvRows];
            DateTime[] DateLocation = new DateTime[gvColumns];

            for (int i = 0; i < gvRows; i++)
            {
                EmpLocation[i] = Convert.ToInt32(gvRoster.Rows[i].Cells[0].Text);
            }

            for (int j = 0; j < gvColumns; j++)
            {
                if (j > 1)
                {
                    DateLocation[j] = Convert.ToDateTime(gvRoster.Columns[j].HeaderText);
                }
            }
            string ddlID = string.Empty;
            foreach (DataRow c in dtleaves.Rows)
            {
                int dtECN = Convert.ToInt32(c["ECN"].ToString());
                DateTime dtTheDate = Convert.ToDateTime(c["LeaveDate"].ToString());

                int i = Array.IndexOf(EmpLocation, dtECN);
                int j = Array.IndexOf(DateLocation, dtTheDate);

                TableCell me = gvRoster.Rows[i].Cells[j];
                me.CssClass = "bg-yellow";
                //foreach (Control ddl in me.Controls)
                //{
                //    if (ddl is DropDownList)
                //    {
                //        DropDownList d = (DropDownList)ddl;
                //        d.SelectedIndex = d.Items.IndexOf(d.Items.FindByValue(LeaveShiftCode));
                //    }
                //}
            }

            btnCancelledLeaves.CssClass = "btn btn-flat btn-warning form-control";
            cbxCancelledLeaves.Checked = true;
        }
        else
        {

            btnCancelledLeaves.CssClass = "btn btn-primary form-control";
            btnCancelledLeaves.Text = "Load Cancelled Leaves";
            cbxCancelledLeaves.Checked = true;
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
    class RosterRecord
    {
        public int EmpCode { get; set; }

        public int RepMgrCode { get; set; }
        public int UpdatedBy { get; set; }
        public DateTime updatedOn { get; set; }
        public int WeekID { get; set; }


        public DateTime rDate { get; set; }
        public int ShiftID { get; set; }
        public int WOCount { get; set; }
        public int UpdateMode { get; set; }
        public bool rules_WorkOffCompliance { get; set; }
        public RosterRecord() { }


    }
}

