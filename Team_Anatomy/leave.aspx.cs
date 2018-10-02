using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class leave : System.Web.UI.Page
{
    DataTable dt;
    Helper my;
    string strsql;
    int MyEmpID;
    string fdate { get; set; }
    string tdate { get; set; }//imp
    EmailSender Email = new EmailSender();
    private DateTime FromDate { get; set; }
    private DateTime ToDate { get; set; }
    private LeaveType LeaveOptions { get; set; }


    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();
        LeaveOptions = new LeaveType();
        try
        {
            dt = Session["dtEmp"] as DataTable;
            if (dt.Rows.Count <= 0)
            {
                Response.Redirect("index.aspx", false);
            }
            else
            {
                // In Production Use the below
                MyEmpID = Convert.ToInt32(dt.Rows[0]["Employee_Id"].ToString());

                if (!Int32.TryParse(MyEmpID.ToString(), out MyEmpID))
                {
                    Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
                }

            }

        }
        catch (Exception Ex)
        {
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            Response.Write(Ex.Message);
        }

        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Leave Request";

        my.fill_dropdown(ddl_leave_dropdown, "WFMP.getDefaultLeaveType", "LeaveText", "LeaveId", "", "", "S");

        if (!IsPostBack)
        {
            fillgvLeaveLog();
        }
    }
    protected void btn_proceed_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "<script>$(document).ready(function(){ $('#pnlLeaveBox').css({ 'display': 'block' });})</script>", false);
        fillgvLeaveDetails();

    }
    protected void reservation_TextChanged(object sender, EventArgs e)
    {
        fillFromAndToDates();
    }

    private void fillFromAndToDates() {
        string[] received = reservation.Text.Split('-');
        FromDate = received[0].Trim().ToDateTime();
        ToDate = received[1].Trim().ToDateTime();
    }
    private void fillgvLeaveDetails()
    {
        fillFromAndToDates();
        // Switch with WFMP.getLeaveRoster 
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = "WFMP.getLeaveRoster";
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd.Parameters.AddWithValue("@FromDate", FromDate);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);

        ViewState["Paging"] = dt;
        gvLeaveDetails.DataSource = dt;
        gvLeaveDetails.DataBind();

    }
    protected void gvLeaveDetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridViewRow gvr = e.Row;
        if (gvr.RowIndex >= 0)
        {
            var thedate = gvr.Cells[0];
            DateTime ondate = thedate.Text.ToDateTime();

            var lbl = gvr.Cells[1];
            lbl.Text = ondate.DayOfWeek.ToString();

            DropDownList ddl = (DropDownList)gvr.FindControlRecursive("ddlSelectLeave");

            if (ondate > DateTime.Now)
            {
                // Normal Leaves
                ddl.DataSource = LeaveOptions.GetDtLeaveType(LeaveType.Leave.Normal);

            }
            else if (ondate < DateTime.Now)
            {
                // UnPlanned Leaves
                ddl.DataSource = LeaveOptions.GetDtLeaveType(LeaveType.Leave.UnPlanned);
            }

            ddl.DataValueField = "LeaveId";
            ddl.DataTextField = "LeaveText";
            ddl.DataBind();
            if (gvr.Cells[3].Text == "WO" && ddl.Items.Contains(new ListItem("WO", "3")))
            {
                ddl.SelectedValue = "3";
            }
        }
    }
    private void fillgvLeaveLog()
    {

        strsql = "WFMP.[buildBadges]";

        SqlCommand cmd = new SqlCommand(strsql);
        cmd.Parameters.AddWithValue("@ECN", Convert.ToInt32(MyEmpID.ToString()));       
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        gvLeaveLog.DataSource = dt;
        gvLeaveLog.DataBind();
        ViewState["dirState"] = dt;
        ViewState["sortdr"] = "Asc";

    }
    private void clearfields()
    {
        ddl_leave_dropdown.ClearSelection();
        txt_leave_reason.Text = string.Empty;//.InnerText 
        gvLeaveDetails.DataSource = null;
        gvLeaveDetails.DataBind();
    }
    protected void gvLeaveLog_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridViewRow gvr = (GridViewRow)e.Row;
        if (gvr.RowIndex >= 0)// && e.Row.RowIndex == gv.EditIndex
        {
            int dt;
            Button btn = (Button)gvr.FindControlRecursive("btn_Cancel");

            string stat1 = gvr.Cells[7].Text.ToString();
            string stat2 = gvr.Cells[8].Text.ToString();
            string date = gvr.Cells[9].Text.ToString();
            if (date == "&nbsp;")
            {
                dt = 0;
            }
            else
            {
                dt = 1;
            }

            FromDate = gvr.Cells[0].Text.ToDateTime();
            DateTime today = DateTime.Today;

            if (today > FromDate || dt == 1 || stat2 == "declined")
            {
                btn.CssClass = "btn btn-sm btn-danger disabled";
                btn.Enabled = false;
            }

        }
    }
    protected void btn_submit_Click(object sender, EventArgs e)
    {
        if (!checkForMax2WorkOffs())
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "<script>$(document).ready(function(){ $('#pnlLeaveBox').css({ 'display': 'block' });})</script>", false);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "toastr_message", "toastr.warning('Please check if you are applying for more than 2 Work-Offs in a week. Kindly reapply with appropriate changes to the leave types.')", true);

        }
        else
        {
            //ScriptManager.RegisterStartupScript(this,this.GetType(), "toastr_message", "toastr.success('Leaves Successfully applied')", true);
            string received = reservation.Text;
            string[] seperator = { " - " };
            DateTime from_Date = Convert.ToDateTime(received.Split(seperator, StringSplitOptions.None).First<string>());
            DateTime end_Date = Convert.ToDateTime(received.Split(seperator, StringSplitOptions.None).Last<string>());

            SqlConnection con = new SqlConnection(my.getConnectionString());
            con.Open();
            String strSQL = "WFMP.InsertLeaveRecords";
            SqlCommand cmd = new SqlCommand(strSQL, con);
            cmd.CommandType = CommandType.StoredProcedure;
            MyEmpID = Convert.ToInt32(dt.Rows[0]["Employee_Id"].ToString());
            cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
            cmd.Parameters.AddWithValue("@from_date", from_Date);
            cmd.Parameters.AddWithValue("@to_date", end_Date);
            cmd.Parameters.AddWithValue("@leave_reason", txt_leave_reason.Text.ToString());
            cmd.Parameters.Add("@xLEAVE_BATCH_ID", SqlDbType.VarChar, 500);
            cmd.Parameters["@xLEAVE_BATCH_ID"].Direction = ParameterDirection.Output;
            cmd.Parameters.Add("@stop", SqlDbType.Int);
            cmd.Parameters["@stop"].Direction = ParameterDirection.Output;
            cmd.Connection = con;

            cmd.ExecuteNonQuery();
            con.Close();

            string dec = cmd.Parameters["@stop"].Value.ToString();
            if (String.IsNullOrEmpty(dec))
            {
                string xLeaveBatchID = cmd.Parameters["@xLEAVE_BATCH_ID"].Value.ToString();
                foreach (GridViewRow row in gvLeaveDetails.Rows)
                {
                    String xLeaveType;
                    String xDate;
                    DropDownList xDDL = (DropDownList)row.FindControl("ddlSelectLeave");
                    xLeaveType = xDDL.SelectedValue.ToString();
                    xDate = row.Cells[0].Text;
                    strSQL = "INSERT INTO WFMP.tbl_datewise_leave(LeaveDate,leave_type,leave_batch_id) VALUES('" + xDate + "','" + xLeaveType + "','" + xLeaveBatchID + "')";

                    try
                    {
                        con.Open();
                        cmd = new SqlCommand(strSQL, con);
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                    catch (Exception ex)
                    {
                        Response.Write(ex.Message.ToString());
                    }

                }

                string newFromDate;
                string newToDate;

                newFromDate = String.Format("{0:dddd, MMMM d, yyyy}", from_Date);
                newToDate = String.Format("{0:dddd, MMMM d, yyyy}", end_Date);
                string leavereason = txt_leave_reason.Text.ToString();

                Email.InitiatorEmpId = MyEmpID;
                Email.RecipientsEmpId = dt.Rows[0]["RepMgrCode"].ToString();
                Email.CCsEmpId = MyEmpID.ToString();
                Email.Subject = "Leave Request";
                Email.Body = "<strong>Hi, </strong>";
                Email.Body += "<P>" + dt.Rows[0]["First_Name"].ToString() + " " + dt.Rows[0]["Last_Name"].ToString() + " has requested leave from " + newFromDate + " to " + newToDate; //+ " for given reason"+" ' "+ txt_leave_reason.Text.ToString()+ " '.<P>";
                Email.Body += "<br> Reason: <i>" + leavereason + "</i> <br>";
                Email.Send();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "toastr_message", "toastr.success('You have successfully applied for leave.')", true);

                fillgvLeaveLog();
            }
            else
            {
                int stop = Convert.ToInt32(dec);
                if (stop == 1)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "toastr_message", "toastr.warning('These leaves overlap with previously applied leaves. Kindly reapply with appropriate changes to the leave dates.')", true);
                    clearfields();
                }

            }
        }
    }
    private bool checkForMax2WorkOffs()
    {
        string received = reservation.Text;
        bool trueValue = true;
        string[] seperator = { " - " };
        DateTime from_Date = Convert.ToDateTime(received.Split(seperator, StringSplitOptions.None).First<string>());
        DateTime end_Date = Convert.ToDateTime(received.Split(seperator, StringSplitOptions.None).Last<string>());
        string strSQL = "Select WeekId, frDate as from_Date, ToDate as end_Date from WFMP.tblRstWeeks ";
        strSQL += " where WeekId between( ";
        strSQL += " select WeekId from WFMP.tblRstWeeks where '" + from_Date + "' between frdate and todate";
        strSQL += " ) and( ";
        strSQL += " select WeekId from WFMP.tblRstWeeks where '" + end_Date + "' between frdate and todate ";
        strSQL += " )";
        DataTable dtDates = my.GetData(strSQL);
        int WOcounter = 0;
        List<LeaveRecords> h = new List<LeaveRecords>();
        foreach (GridViewRow r in gvLeaveDetails.Rows)
        {
            int dateColumn = r.GetGVCellUsingFieldName("Date");
            string formattedDate = r.Cells[r.GetGVCellUsingFieldName("Date")].Text.ToString();
            DateTime dateTime;
            if (DateTime.TryParseExact(formattedDate, "dd MMM yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out dateTime))
            {
                DropDownList ddlSelectLeave = r.FindControl("ddlSelectLeave") as DropDownList;
                if (ddlSelectLeave != null)
                {
                    LeaveRecords g = new LeaveRecords();
                    g.Date = dateTime;
                    g.ShiftCode = ddlSelectLeave.SelectedItem.Text.ToString();
                    g.ShiftID = g.ShiftCode == "WO" ? 49 : 0;
                    if (g.ShiftID == 49)
                    {
                        DataRow[] dr = dtDates.Select("'" + g.Date + "'>=from_Date and '" + g.Date + "'<=end_Date");
                        g.WeekID = Convert.ToInt32(dr[0]["WeekId"].ToString());
                        h.Add(g);
                        WOcounter = h.Where(s => s.WeekID == g.WeekID).Count();
                        if (WOcounter > 2)
                        {
                            r.Cells[2].CssClass = "bg-orange";
                            trueValue = trueValue && false;
                        }
                        else
                        {
                            r.Cells[2].CssClass = "bg-teal";
                            trueValue = trueValue && true;
                        }
                    }
                }
            }

        }
        return trueValue;
    }
    protected void btn_Cancel_Click(object sender, EventArgs e)
    {
        //    
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "xKeyx", "xShowModal()", true);
        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "xKeyx", "openmodal", true);
        Button btn = (Button)sender;
        GridViewRow row = (GridViewRow)btn.NamingContainer;


        fdate = row.Cells[0].Text.ToString();
        tdate = row.Cells[1].Text.ToString();
    }
    protected void btn_save_cancel_reason_Click(object sender, EventArgs e)
    {
        SqlCommand cmd = new SqlCommand("WFMP.cancelLeaveRequest");
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        cmd.Parameters.AddWithValue("@LeaveRequestID", lblLeaveID.Value);
        cmd.Parameters.AddWithValue("@ReasonForCancellation", txt_cancel_reason.Text);
        int Rows = my.ExecuteDMLCommand(ref cmd, "", "S");
        txt_cancel_reason.Text = String.Empty;
        fillgvLeaveLog();
        if (Rows > 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "toastr_message", "toastr.success('Your leaves have been cancelled successfully.')", true);
        }
    }

    [WebMethod]
    public static string getDates()
    {
        Helper my = new Helper();
        String strSQL = "WFMP.getMinDateforLeaveRequest";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dtMinDate = my.GetDataTableViaProcedure(ref cmd);
        string minDate = dtMinDate.Rows[0]["minDate"].ToString();      
        return (minDate);
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
            gv.FooterRow.TableSection = TableRowSection.TableFooter;
        }
    }
    protected void gvLeaveLog_Sorting(object sender, GridViewSortEventArgs e)
    {
        DataTable dtrslt = (DataTable)ViewState["dirState"];
        if (dtrslt.Rows.Count > 0)
        {
            if (Convert.ToString(ViewState["sortdr"]) == "Asc")
            {
                dtrslt.DefaultView.Sort = e.SortExpression + " Desc";
                ViewState["sortdr"] = "Desc";
            }
            else
            {
                dtrslt.DefaultView.Sort = e.SortExpression + " Asc";
                ViewState["sortdr"] = "Asc";
            }
            gvLeaveLog.DataSource = dtrslt;
            gvLeaveLog.DataBind();
        }

    }
    protected void gvLeaveLog_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvLeaveLog.PageIndex = e.NewPageIndex;
        //gvLeaveLog.DataSource = ViewState["Paging"];
        gvLeaveLog.DataBind();
        fillgvLeaveLog();

    }
}

class LeaveRecords
{
    public DateTime Date { get; set; }
    public int WeekID { get; set; }
    public string ShiftCode { get; set; }
    public int ShiftID { get; set; }

}



class LeaveType
{
    Helper my = new Helper();
    public readonly DataTable dtLeaveType;
    public LeaveType()
    {
        dtLeaveType = my.GetData("select LeaveId, LeaveText, Active from WFMP.tblLeaveType");
    }
    public enum Leave
    {
        Normal = 0,
        UnPlanned = 1
    }


    public DataTable GetDtLeaveType(Leave leavetype)
    {
        DataView dv = new DataView(dtLeaveType);
        if (leavetype == Leave.Normal)
        {
            dv.RowFilter = "Active=1 and LeaveId <> 4";
        }
        else if (leavetype == Leave.UnPlanned)
        {
            dv.RowFilter = "Active = 1 and LeaveId<> 3";

        }

        return dv.ToTable();
    }
}