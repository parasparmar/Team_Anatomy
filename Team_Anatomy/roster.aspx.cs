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
    DataTable dtRoster;
    Helper my = new Helper();
    string strSQL = string.Empty;
    int MyEmpID = 0;


    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            dtRoster = (DataTable)Session["dtEmp"];
            if (dtRoster.Rows.Count <= 0)
            {
                Response.Redirect("index.aspx");
            }
            else
            {
                MyEmpID = Convert.ToInt32(dtRoster.Rows[0]["Employee_Id"].ToString());
            }

        }
        catch (Exception Ex)
        {
            Response.Redirect("index.aspx");
        }
        if (!IsPostBack)
        {
            MyEmpID = 923563;
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "Roster";
            fillddlRepManager();
        }
    }
    private void fillddlRepManager()
    {

        strSQL = "Select count(*) as Teams FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
        strSQL += " WHERE A.RepMgrCode = " + MyEmpID + " and A.IsReportingManager = 1";
        int countofManagersReportingToMe = my.getSingleton(strSQL);

        if (countofManagersReportingToMe > 0)
        {
            pnlAmIRvwMgr.Visible = true;
            strSQL = "SELECT A.RepMgrCode, REPLACE(B.First_Name +' '+B.Middle_Name+' '+B.Last_Name,'  ',' ') as RepMgr";
            strSQL += " , A.Employee_ID as MgrID, A.First_Name +' '+A.Middle_Name+' '+A.Last_Name as MgrName";
            strSQL += "  FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
            strSQL += " INNER JOIN [CWFM_Umang].[WFMP].[tblMaster] B ON B.Employee_ID = A.RepMgrCode";
            strSQL += " WHERE A.RepMgrCode = " + MyEmpID + " and A.IsReportingManager = 1";
            DataTable dt = my.GetData(strSQL);
            ddlRepManager.DataSource = dt;
            ddlRepManager.DataTextField = "MgrName";
            ddlRepManager.DataValueField = "MgrID";
            ddlRepManager.DataBind();
            ddlRepManager.Items.Insert(0, new ListItem("Not Selected", "0"));

        }
        else
        {
            pnlAmIRvwMgr.Visible = false;
        }

    }
    protected void ddlRepManager_SelectedIndexChanged(object sender, EventArgs e)
    {
        int i = ddlRepManager.SelectedIndex;
        strSQL = "select distinct ryear as Year from CWFM_Umang.WFMP.tblRstWeeks";
        my.append_dropdown(ref ddlYear, strSQL, 0, 0);
        ltlReportingMgrsTeam.Text = "Roster for Team : " + ddlRepManager.SelectedItem.Text;
        ddlRepManager.SelectedIndex = i;
        if (ddlRepManager.SelectedValue.Length > 0 && ddlWeek.SelectedValue.Length > 0 && ddlYear.SelectedValue != "0")
        {
            int RepMgrCode = Convert.ToInt32(ddlRepManager.SelectedValue);
            int WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
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
        dtRoster = my.GetDataTableViaProcedure(ref cmd);
        if (OffsetTheWeekBy != 0)
        {
            for (int j = 2; j < dtRoster.Columns.Count; j++)
            {
                // The Offset is incase the previous weeks roster needs to be replicated for today.
                string newName = Convert.ToDateTime(dtRoster.Columns[j].ColumnName).AddDays(7).ToString("dd-MMM-yyyy");
                dtRoster.Columns[j].ColumnName = newName;
            }
        }

        gvRoster.DataSource = dtRoster;
        int RowCount = dtRoster.Rows.Count;
        int ColCount = dtRoster.Columns.Count;

        strSQL = "SELECT [ShiftID],[ShiftCode] FROM [CWFM_Umang].[WFMP].[tblShiftCode] where [Active] = 1";
        DataTable dt1 = my.GetData(strSQL);
        string ddlName;
        // Set the date Header rows
        // The gvRoster has dates beginning from 3rd column onwards and shows 7 dates. ie:- indices 2 through ColCount-1 = 8
        for (int j = 2; j < ColCount; j++)
        {
            gvRoster.Columns[j].HeaderText = dtRoster.Columns[j].ColumnName;
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
                    v.SelectedIndex = v.Items.IndexOf(v.Items.FindByValue(dtRoster.Rows[i][j].ToString()));
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
        int CellCount = gvRoster.Columns.Count;
        int RepMgrCode = Convert.ToInt32(ddlRepManager.SelectedValue);
        int WeekID = Convert.ToInt32(ddlWeek.SelectedValue);
        int UpdatedBy = MyEmpID;
        DateTime updatedOn = DateTime.Now;

        DataSet X = new DataSet();

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
                using (SqlCommandBuilder builder = new SqlCommandBuilder(da))
                {
                    da.Fill(X);
                    List<Rosteree> ListOfR = new List<Rosteree>();
                    foreach (GridViewRow Row in gvRoster.Rows)
                    {
                        int TheEmpCode = Convert.ToInt32(Row.Cells[0].Text.ToString());
                        for (int j = 2; j < CellCount; j++)
                        {
                            Rosteree R = new Rosteree();
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
                    foreach (Rosteree R in ListOfR)
                    {
                        DataRow[] drc = X.Tables[0].Select("EmpCode = " + R.EmpCode + " and rDate >= #" + R.rDate + "# and rDate <#" + R.rDate.AddDays(1) + "#");

                        if (drc.Length > 0)
                        {
                            DataRow dr = drc[0];
                            if (dr["ShiftID"].ToString() != R.ShiftID.ToString())
                            {
                                dr["ShiftID"] = R.ShiftID;
                                dr["UpdatedBy"] = R.UpdatedBy;
                                dr["updatedOn"] = R.updatedOn;
                            }

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
                            //dr.SetAdded();
                            X.Tables[0].Rows.Add(dr);
                        }
                    }
                    int rowsAffected = da.Update(X);

                }

            }
        }












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

    class Rosteree
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

        public Rosteree() { }

        public int UpdateRoster()
        {
            int rowsAffected = 0;


            return rowsAffected;
        }

    }

}