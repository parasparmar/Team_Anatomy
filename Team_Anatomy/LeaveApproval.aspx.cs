using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class LeaveApproval : System.Web.UI.Page
{
    DataTable dt;
    Helper my;
    string strSQL;
    int MyEmpID;
    public DataTable dtLeaveLog { get; set; }
    public string rowFilter { get; set; }
    public bool isFiltered { get; set; }
    EmailSender Email = new EmailSender();
    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();
        try
        {
            dt = (DataTable)Session["dtEmp"];
            if (dt.Rows.Count <= 0)
            {
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            else
            {
                MyEmpID = Convert.ToInt32(dt.Rows[0]["Employee_Id"].ToString());
            }
        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
            string redirect2URL = "index.aspx";
            if (ViewState["PreviousPageUrl"] != null)
            {
                redirect2URL = ViewState["PreviousPageUrl"].ToString();
            }
            else
            {
                ViewState["PreviousPageUrl"] = Page.Request.Url.ToString();
            }
            Response.Redirect(redirect2URL, false);
        }
       
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Leave Approval";
        if (!IsPostBack)
        {
            fillddlRepManager();
        }
    }
    private void fillddlRepManager()
    {
        strSQL = "WFMP.GetRepRevMgr";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(MyEmpID.ToString()));
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        ddlRepManager.DataSource = dt1;
        ddlRepManager.DataTextField = "MgrName";
        ddlRepManager.DataValueField = "MgrID";
        ddlRepManager.DataBind();
        ddlRepManager.SelectedValue = MyEmpID.ToString();
        //DropDownList v = (DropDownList)PageExtensionMethods.FindControlRecursive(Master, "ddlRepManager");
        //v.SelectedIndex = v.Items.IndexOf(v.Items.FindByValue(MyEmpID.ToString()));
        FillLeaveRequests(Convert.ToInt32(MyEmpID.ToString()));
    }
    protected void ddlRepManager_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillLeaveRequests(Convert.ToInt32(ddlRepManager.SelectedValue.ToString()));
        ddlLevel1Filter.ClearSelection();
    }
    public void FillLeaveRequests(int EmpCode)
    {
        if (Session["isFiltered"] != null)
        {
            isFiltered = Session["isFiltered"].ToBool();
        }
        
        if (isFiltered == false)
        {
            strSQL = "WFMP.GetEmployeeLeaveRequestes";
            SqlCommand cmd = new SqlCommand(strSQL);
            cmd.Parameters.AddWithValue("@EmpCode", EmpCode);
            dtLeaveLog = my.GetDataTableViaProcedure(ref cmd);
            gvApprLeaveLog.DataSource = dtLeaveLog;
            gvApprLeaveLog.DataBind();

            DataView view = new DataView(dtLeaveLog);
            view.RowFilter = rowFilter;
            view.RowStateFilter = DataViewRowState.CurrentRows;

            ddlEmployee.DataSource = view.ToTable(true, "ECN", "NAME");
            ddlEmployee.DataValueField = "ECN";
            ddlEmployee.DataTextField = "NAME";
            ddlEmployee.DataBind();
            ddlEmployee.Items.Insert(0, new ListItem("All", "1"));
        }
        else
        {
            applyLevelFilter();
        }
    }
    protected void btn_detail_Click(object sender, EventArgs e)
    {

        btn_dec.Enabled = false;
        btn_appr.Enabled = false;
        txt_reason.Text = String.Empty;
        LinkButton btn = (LinkButton)sender;
        GridViewRow row = (GridViewRow)btn.NamingContainer;
        string leaveid = row.Cells[8].Text.ToString();
        lblLeaveID.Text = leaveid;
        string employeeid = row.Cells[0].Text.ToString();
        lblEmployeeID.Text = employeeid;
        string employeeName = row.Cells[1].Text.ToString();
        lblEmployeeName.Text = employeeName;

        String Sql = "WFMP.getEmployeeLeaveRoster";
        SqlCommand cmd = new SqlCommand(Sql);
        cmd.Parameters.AddWithValue("@LeaveId", leaveid);
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        cmd.Dispose();

        strSQL = "[WFMP].[fillModal]";
        cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@LeaveId", Convert.ToInt32(leaveid.ToString()));
        cmd.Parameters.AddWithValue("@EmployeeId", Convert.ToInt32(employeeid.ToString()));
        cmd.Parameters.AddWithValue("@ApproverId", Convert.ToInt32(MyEmpID.ToString()));
        DataTable TruthTable = my.GetDataTableViaProcedure(ref cmd);
        if (TruthTable.Rows.Count != 0)
        {
            foreach (DataRow r in TruthTable.Rows)
            {
                if (r["can"].ToString() != string.Empty)
                {
                    int check = Convert.ToInt32(r["can"].ToString());
                    if (check == 0)
                    {
                        btn_dec.Enabled = true;
                    }
                    else if (check == 1)
                    {
                        btn_appr.Enabled = true;
                    }
                    else if (check == 3)
                    {
                        btn_appr.Enabled = false;
                        btn_dec.Enabled = false;
                    }
                }
                else
                {
                    btn_appr.Enabled = true;
                    btn_dec.Enabled = true;
                }
            }
        }
        gvdatewiseAppr.DataSource = dt1;
        gvdatewiseAppr.DataBind();

        ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
        upModal.Update();
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
    protected void btn_appr_Click(object sender, EventArgs e)
    {

        string val = lblLeaveID.Text.ToString();
        string id = val;
        string eval = lblEmployeeID.Text.ToString();
        string empid = eval;
        string comment = txt_reason.Text.ToString();
        string comments = comment;
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMP].[UpdateApproval]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        cmd.Parameters.AddWithValue("@ApproverID", MyEmpID);
        cmd.Parameters.AddWithValue("@EmpID", Convert.ToInt32(empid.ToString()));
        cmd.Parameters.AddWithValue("@id", Convert.ToInt32(id.ToString()));
        cmd.Parameters.AddWithValue("@comments", comments);

        cmd.Connection = con;
        int Rows = cmd.ExecuteNonQuery();
        con.Close();
        txt_reason.Text = String.Empty;
        lblLeaveID.Text = String.Empty;
        lblEmployeeName.Text = "";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "hideModal();", true);
        //FillLeaveRequests(Convert.ToInt32(ddlRepManager.SelectedValue.ToString()));
        ScriptManager.RegisterStartupScript(this, this.GetType(), "show", "toastA();", true);
        FillLeaveRequests(Convert.ToInt32(ddlRepManager.SelectedValue.ToString()));
        //Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.success('Leave is approved.')", true);
        //Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.success('Leave is approved.', 'Success')", true);
        //fillddlRepManager();--commented to prevent refreshing of RepMgrDropdown

        //System.Threading.Thread.Sleep(3000);
        //Page.Response.Redirect(Page.Request.Url.ToString(), true);

        string strSQL2 = "[WFMP].[getEmployeeMgrs]";

        SqlCommand cmdd = new SqlCommand(strSQL2);
        cmdd.Parameters.AddWithValue("@EmpCd", Convert.ToInt32(empid.ToString()));
        DataTable dtt = my.GetDataTableViaProcedure(ref cmdd);

        int RepMgr = Convert.ToInt32(dtt.Rows[0]["RepMgrCode"].ToString());
        int RevMgr = Convert.ToInt32(dtt.Rows[0]["RevMgrCode"].ToString());


        string strSQL3 = "[WFMP].[getLeavedatesandLeavereason]";

        SqlCommand cmddd = new SqlCommand(strSQL3);
        cmddd.Parameters.AddWithValue("@id", Convert.ToInt32(id.ToString()));
        DataTable dttt = my.GetDataTableViaProcedure(ref cmddd);

        DateTime fd = Convert.ToDateTime(dttt.Rows[0]["from_date"].ToString());
        DateTime td = Convert.ToDateTime(dttt.Rows[0]["to_date"].ToString());
        DateTime ao = Convert.ToDateTime(dttt.Rows[0]["applied_on"].ToString());

        string from_date = fd.ToString("dddd, dd MMMM yyyy hh:mm tt");
        string to_date = td.ToString("dddd, dd MMMM yyyy hh:mm tt");
        string reason = dttt.Rows[0]["leave_reason"].ToString();
        string appliedOn = ao.ToString("dddd, dd MMMM yyyy hh:mm tt");
        string applied_By = dttt.Rows[0]["name"].ToString();

        //string tableHeader = "<table style='border-collapse: collapse; width: 100 %;border: 1px solid #000000;'>< tr style='background-color: #f2f2f2'>< th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: #4CAF50;color: white; '> Start Date </ th >< th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: #4CAF50;color: white; '> End Date </ th >< th > Leave Reason </ th >< th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: #4CAF50;color: white; '> Applied On </ th >< th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: #4CAF50;color: white; '> Link for Action </ th ></ tr >< tr style='background-color: #f2f2f2'> ";
        //string tableFooter = "</tr></ table > ";
        //string tableBody = "<td style='text-align: left;padding: 8px;border: 1px solid #000000;'>"+ from_date+ "</td><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + to_date+ "</td><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + reason + "</td><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + appliedOn+ "</td><td><a href='TA/leave.aspx'></td>";

        Email.InitiatorEmpId = MyEmpID;
        if (MyEmpID == RepMgr)
        {
            Email.RecipientsEmpId = RevMgr.ToString();
            Email.CCsEmpId = MyEmpID.ToString() + ";" + empid.ToString();
        }
        else if (MyEmpID == RevMgr)
        {
            Email.RecipientsEmpId = empid.ToString();
            Email.CCsEmpId = MyEmpID.ToString() + ";" + RepMgr.ToString();
        }
        //Email.RecipientsEmpId = "931040";
        //Email.BCCsEmpId = MyEmpID.ToString();

        Email.Subject = "Leave Request Approved";
        Email.Body = "<style>.xMailBody {font-family: calibri;}</style><div class='xMailBody'><strong>Hi, </strong>";
        Email.Body += "<P>A leave application for " + applied_By + " has been approved by " + dt.Rows[0]["First_Name"].ToString() + " " + dt.Rows[0]["Last_Name"].ToString() + " and it requires your action. </P>";
        Email.Body += "<p>Leave Application details:</p> <br>";
        Email.Body += "<table style='border-collapse: collapse;width: 90%;border: 1px solid #000000;font-family: calibri;'><tr style='background-color: #f2f2f2'><th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: #4CAF50;color: white;'>Start Date</th><th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: #4CAF50;color: white;'>End Date</th><th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: #4CAF50;color: white;'>Leave Reason</th><th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: #4CAF50;color: white;'>Applied On</th><th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: #4CAF50;color: white;'>Link for Action</th></tr><tr style='background-color: #f2f2f2'><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + from_date + "</td><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + to_date + "</td><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + reason + "</td><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + appliedOn + "</td><td style='text-align: left;padding: 8px;border: 1px solid #000000;'><a href='http://iaccess/TA/LeaveApproval.aspx'>Leave Approval page</a></td></tr></table> </div>";
        // Email.Body += "<br> <p>Regards, <br> IAccess Support Team <br> PS: This is an automated triggered email. Please do not reply.</p>";
        //Email.Send();
        //}
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "dtblAdd1", "dtbl();", true);
    }
    protected void btn_dec_Click(object sender, EventArgs e)
    {

        string val = lblLeaveID.Text.ToString();
        char trim = (',');
        string id = val.TrimEnd(trim);
        string eval = lblEmployeeID.Text.ToString();
        string empid = eval.TrimEnd(trim);
        string comment = txt_reason.Text.ToString();
        string comments = comment.TrimEnd(trim);
        if (comments == string.Empty)
        { //ClientScript.RegisterStartupScript(GetType(), "Message", "<SCRIPT type='text/javascript'>alert('Please enter decline reason');</script>");
            alert.Visible = true;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
            string abc = comments.TrimEnd(trim);
            txt_reason.Text = abc;
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "<SCRIPT type='text/javascript'>alert('Please enter decline reason');</script>", false);
        }

        else
        {
            SqlConnection con = new SqlConnection(my.getConnectionString());
            con.Open();

            String strSQL = "[WFMP].[UpdateDecline]";
            SqlCommand cmd = new SqlCommand(strSQL, con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@ApproverID", MyEmpID);
            cmd.Parameters.AddWithValue("@EmpID", Convert.ToInt32(empid.ToString()));
            cmd.Parameters.AddWithValue("@id", Convert.ToInt32(id.ToString()));
            cmd.Parameters.AddWithValue("@comments", comments);
            cmd.Parameters.Add("@bit", SqlDbType.VarChar, 500);
            cmd.Parameters["@bit"].Direction = ParameterDirection.Output;

            cmd.Connection = con;
            cmd.ExecuteNonQuery();
            con.Close();
            string decider = cmd.Parameters["@bit"].Value.ToString();
            txt_reason.Text = String.Empty;
            lblLeaveID.Text = String.Empty; ;
            lblEmployeeName.Text = "";
            //if (decider == "disable")
            //{
            //    ////btn_dec.ID.Enabled = false;
            //    //Button btn_dec = (Button)sender;
            //    //string buttonId = btn_dec.ID+1;
            //    //string buttonText = btn_dec.Text + 1;
            //    //string buttonClass = btn_dec.CssClass + 1;
            //    //btn_dec.Attributes.Add("class", "buttonClass");

            //    ////(FindControl(buttonId) as Button).Enabled = false;
            //    //Button tb1 = (Button)FindControl(btn_dec);
            //    //tb1.Enabled = false;
            //}
            ScriptManager.RegisterStartupScript(this, this.GetType(), "show", "toastD();", true);
            alert.Visible = false;

            //Page.Response.Redirect(Page.Request.Url.ToString(), true);
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "hideModal();", true);
        //FillLeaveRequests(Convert.ToInt32(ddlRepManager.SelectedValue.ToString()));
        //
        FillLeaveRequests(Convert.ToInt32(ddlRepManager.SelectedValue.ToString()));

        //Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.success('Request Declined.', 'Success')", true);
        //--fillddlRepManager();//---commented to prevent refreshing of RepMgrDropdown

        string strSQL1 = "[WFMP].[getEmployeeMgrs]";

        SqlCommand cmdd = new SqlCommand(strSQL1);
        cmdd.Parameters.AddWithValue("@EmpCd", Convert.ToInt32(empid.ToString()));
        DataTable dtt = my.GetDataTableViaProcedure(ref cmdd);

        int RepMgr = Convert.ToInt32(dtt.Rows[0]["RepMgrCode"].ToString());
        int RevMgr = Convert.ToInt32(dtt.Rows[0]["RevMgrCode"].ToString());

        string strSQL3 = "[WFMP].[getLeavedatesandLeavereason]";

        SqlCommand cmddd = new SqlCommand(strSQL3);
        cmddd.Parameters.AddWithValue("@id", Convert.ToInt32(id.ToString()));
        DataTable dttt = my.GetDataTableViaProcedure(ref cmddd);

        DateTime fd = Convert.ToDateTime(dttt.Rows[0]["from_date"].ToString());
        DateTime td = Convert.ToDateTime(dttt.Rows[0]["to_date"].ToString());
        DateTime ao = Convert.ToDateTime(dttt.Rows[0]["applied_on"].ToString());

        string from_date = fd.ToString("dddd, dd MMMM yyyy hh:mm tt");
        string to_date = td.ToString("dddd, dd MMMM yyyy hh:mm tt");
        string reason = dttt.Rows[0]["leave_reason"].ToString();
        string appliedOn = ao.ToString("dddd, dd MMMM yyyy hh:mm tt");
        string applied_By = dttt.Rows[0]["name"].ToString();

        Email.InitiatorEmpId = MyEmpID;
        if (MyEmpID == RepMgr)
        { Email.RecipientsEmpId = empid.ToString(); }
        else if (MyEmpID == RevMgr)
        { Email.RecipientsEmpId = RepMgr.ToString() + ";" + empid.ToString(); }
        //Email.RecipientsEmpId = "931040";
        //Email.BCCsEmpId = MyEmpID.ToString();
        Email.CCsEmpId = MyEmpID.ToString();
        Email.Subject = "Leave Request Declined";
        Email.Body = "<strong>Hi, </strong>";
        Email.Body += "<P>Your below leave application has been Declined by " + dt.Rows[0]["First_Name"].ToString() + " " + dt.Rows[0]["Last_Name"].ToString() + "</P>";
        Email.Body += "<p>Reason for Decline: '<b><i>" + comments + "'</b></i></p>";
        Email.Body += "<p>Leave Application details:</p> <br>";
        Email.Body += "<table style='border-collapse: collapse;width: 100%;border: 1px solid #000000;'><tr style='background-color: #f2f2f2'><th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: red;color: white;'>Start Date</th><th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: red;color: white;'>End Date</th><th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: red;color: white;'>Leave Reason</th><th style='text-align: left;padding: 8px;border: 1px solid #000000;background-color: red;color: white;'>Applied On</th></tr><tr style='background-color: #f2f2f2'><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + from_date + "</td><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + to_date + "</td><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + reason + "</td><td style='text-align: left;padding: 8px;border: 1px solid #000000;'>" + appliedOn + "</td></tr></table>";
        //Email.Send();

        //ScriptManager.RegisterStartupScript(this, this.GetType(), "dtblAdd2", "dtbl();", true);
    }
    private void applyLevelFilter()
    {

        ddlLevel1Filter.SelectedValue = (Session["ddlLevel1Filter"] != null) ? Session["ddlLevel1Filter"].ToString() : "1";
        ddlLevel2Filter.SelectedValue = (Session["ddlLevel2Filter"] != null) ? Session["ddlLevel2Filter"].ToString() : "1";
        ddlEmployee.SelectedValue = (Session["ddlEmployee"] != null) ? Session["ddlEmployee"].ToString() : "1";

        rowFilter = string.Empty;
        DropDownList[] ddls = { ddlLevel1Filter, ddlLevel2Filter, ddlEmployee };
        foreach (DropDownList d in ddls)
        {
            if (rowFilter == string.Empty)
            {
                rowFilter = getRowFilter(d.SelectedValue);

            }
            else
            {
                if (d.SelectedIndex > 0)
                {
                    if (getRowFilter(d.SelectedValue) != string.Empty)
                    {
                        rowFilter += " and " + getRowFilter(d.SelectedValue);
                    }
                }
            }
        }

        strSQL = "WFMP.GetEmployeeLeaveRequestes";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", ddlRepManager.SelectedValue.ToString());
        dtLeaveLog = my.GetDataTableViaProcedure(ref cmd);
        DataView view = new DataView(dtLeaveLog);
        view.RowFilter = rowFilter;
        view.RowStateFilter = DataViewRowState.CurrentRows;
        gvApprLeaveLog.DataSource = view;
        gvApprLeaveLog.DataBind();

        string EmpCode = string.Empty;
        if (ddlEmployee.SelectedIndex > 0 && isFiltered)
        {
            EmpCode = ddlEmployee.SelectedValue;
        }
        //ddlEmployee.ClearSelection();
        ddlEmployee.Items.Clear();
        DataTable dtTemp = view.ToTable(true, "ECN", "NAME");
        DataRow r = dtTemp.NewRow();
        r["ECN"] = "1";
        r["NAME"] = "All";
        dtTemp.Rows.InsertAt(r, 0);
        ddlEmployee.DataSource = dtTemp;

        ddlEmployee.DataValueField = "ECN";
        ddlEmployee.DataTextField = "NAME";
        ddlEmployee.SelectedValue = null;
        ddlEmployee.DataBind();
        //ddlEmployee.Items.Insert(0, new ListItem("All", "1"));

        if (EmpCode != string.Empty && isFiltered)
        {
            ddlEmployee.SelectedValue = EmpCode;
        }
        else
        {
            ddlEmployee.SelectedValue = "1";
        }
        ddlEmployee.DataBind();
    }
    private string getRowFilter(string i)
    {
        string r = string.Empty;
        switch (i)
        {
            case "0":
                r = string.Empty;
                break;
            case "1":
                r = string.Empty;
                break;
            case "2":
                r = "Level1_Action is null";
                break;
            case "3":
                r = "Level2_Action ='Pending'";
                break;
            case "4":
                r = "Level1_Action is not null";
                break;
            case "5":
                r = "Level2_Action <>'Pending'";
                break;
            default:
                r = "ECN = " + i.ToString();
                break;
        }

        return r;
    }
    protected void ddlLevel1Filter_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlLevel1Filter.SelectedValue == "1") { isFiltered = false; } else { isFiltered = true; }
        Session["isFiltered"] = isFiltered;
        Session["ddlLevel1Filter"] = ddlLevel1Filter.SelectedValue;
        applyLevelFilter();
    }
    protected void ddlLevel2Filter_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlLevel2Filter.SelectedValue == "1") { isFiltered = false; } else { isFiltered = true; }
        Session["isFiltered"] = isFiltered;
        Session["ddlLevel2Filter"] = ddlLevel2Filter.SelectedValue;
        applyLevelFilter();
    }
    protected void ddlEmployee_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlEmployee.SelectedValue == "1") { isFiltered = false; } else { isFiltered = true; }
        Session["isFiltered"] = isFiltered;
        Session["ddlEmployee"] = ddlEmployee.SelectedValue;
        applyLevelFilter();
    }
    protected void btnReset_Click(object sender, EventArgs e)
    {
        isFiltered = false;
        Session["isFiltered"] = isFiltered;
        Session["ddlLevel1Filter"] = 1;
        Session["ddlLevel2Filter"] = 1;
        Session["ddlEmployee"] = 1;
        if (ddlLevel1Filter.SelectedIndex > 0 || ddlLevel2Filter.SelectedIndex > 0 || ddlEmployee.SelectedIndex > 0)
        {
            ddlLevel1Filter.SelectedValue = "1";
            ddlLevel2Filter.SelectedValue = "1";
            ddlEmployee.SelectedValue = "1";
            applyLevelFilter();
        }
        
    }
}