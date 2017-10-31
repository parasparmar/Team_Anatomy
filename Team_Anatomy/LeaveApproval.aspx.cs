using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
//using System.Globalization;
using System.Security;
using System.Security.Principal;
using System.Net;
using System.Web.Services;
using System.Web.Script.Serialization;

public partial class LeaveApproval : System.Web.UI.Page
{
    DataTable dt;
    Helper my = new Helper();
    string strSQL = string.Empty;
    int MyEmpID = 0;//

    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            dt = (DataTable)Session["dtEmp"];
            if (dt.Rows.Count <= 0)
            {
                Response.Redirect("index.aspx", false);
            }
            else
            {
                MyEmpID = Convert.ToInt32(dt.Rows[0]["Employee_Id"].ToString());
            }

        }
        catch (Exception Ex)
        {
            Response.Redirect("index.aspx", false);
        }

        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Leave Approval";

        if (!IsPostBack)
        {
            //MyEmpID = 923563;
            fillddlRepManager();
        }
    }

    private void fillddlRepManager()
    {
       strSQL = "CWFM_UMANG.WFMP.GetRepRevMgr";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(MyEmpID.ToString()));
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        ddlRepManager.DataSource = dt1;
        ddlRepManager.DataTextField = "MgrName";
        ddlRepManager.DataValueField = "MgrID";
        ddlRepManager.DataBind();


        DropDownList v = (DropDownList)PageExtensionMethods.FindControlRecursive(Master, "ddlRepManager");

        v.SelectedIndex = v.Items.IndexOf(v.Items.FindByValue(MyEmpID.ToString()));

        FillLeaveRequests(Convert.ToInt32(MyEmpID.ToString()));
    }

    protected void ddlRepManager_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillLeaveRequests(Convert.ToInt32(ddlRepManager.SelectedValue.ToString()));
    }

    public void FillLeaveRequests(int xEmpCode)
    {
        strSQL = "CWFM_UMANG.WFMP.GetEmployeeLeaveRequestes";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", xEmpCode);
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        gvApprLeaveLog.DataSource = dt1;
        gvApprLeaveLog.DataBind();
    }

    protected void btn_detail_Click(object sender, EventArgs e)
    {
        //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none",
        //"<script>$('.modal').modal('show');</script>", false);

        //System.Text.StringBuilder sb = new System.Text.StringBuilder();
        //sb.Append(@"<script>");
        //sb.Append(@"$('.modal').modal('show');");
        //sb.Append(@"</script>");
        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "mSlideScript", sb.ToString(), false);
        btn_dec.Enabled = false;
        btn_appr.Enabled = false;
        txt_reason.Text = String.Empty;
        Button btn = (Button)sender;
        GridViewRow row = (GridViewRow)btn.NamingContainer;
        string leaveid = row.Cells[8].Text.ToString();
        lblLeaveID.Text = leaveid;
        string employeeid = row.Cells[0].Text.ToString();
        lblEmployeeID.Text  = employeeid;
        String Sql = "select A.[LeaveDate], B.[LeaveText], A.[roster]";
        Sql += "from [WFMP].[tbl_datewise_leave] A ";
        Sql += "inner join [WFMP].[tblLeaveType] B ";
        Sql += "on A.[leave_type] = B.[LeaveID]";
        Sql += "WHERE [leave_batch_id] = '" + leaveid + "'";
        SqlCommand cmd = new SqlCommand(Sql);

        DataTable dt1 = my.GetData(Sql);

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


            }
        }

        gvdatewiseAppr.DataSource = dt1;
        gvdatewiseAppr.DataBind();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);

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
        if (txt_reason.Text.ToString() == string.Empty)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "a", "Alert();", true);
        }
        else
        {
            //string ival = lblLeaveID.Text .TrimEnd(char[,] trimChars).ToString();
            string val = lblLeaveID.Text.ToString();
            //char trim = (',');
            string id = val;//.Trim(trim);//val.TrimEnd(trim);
            string eval = lblEmployeeID.Text.ToString();
            string empid = eval;//.Trim(trim);//.TrimEnd(trim);
            string comment = txt_reason.Text.ToString();
            string comments = comment;//.TrimEnd(trim);
            SqlConnection con = new SqlConnection(my.getConnectionString());
            con.Open();

            String strSQL = "CWFM_UMANG.[WFMP].[UpdateApproval]";
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
            lblLeaveID.Text = String.Empty; ;
            lblEmployeeID.Text = "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "hideModal();", true);
            //FillLeaveRequests(Convert.ToInt32(ddlRepManager.SelectedValue.ToString()));
            ScriptManager.RegisterStartupScript(this, this.GetType(), "show", "toastA();", true);
            FillLeaveRequests(Convert.ToInt32(ddlRepManager.SelectedValue.ToString()));
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.success('Leave is approved.', 'Success')", true);
            fillddlRepManager();//
        }

    }
    protected void btn_dec_Click(object sender, EventArgs e)
    {

        string val = lblLeaveID.Text .ToString();
        char trim = (',');
        string id = val.TrimEnd(trim);
        string eval = lblEmployeeID.Text .ToString();
        string empid = eval.TrimEnd(trim);
        string comment = txt_reason.Text.ToString();
        string comments = comment.TrimEnd(trim);
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "CWFM_UMANG.[WFMP].[UpdateDecline]";
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
        lblLeaveID.Text  = String.Empty; ;
        lblEmployeeID.Text  = "";
        if (decider == "disable")
        {
            ////btn_dec.ID.Enabled = false;
            //Button btn_dec = (Button)sender;
            //string buttonId = btn_dec.ID+1;
            //string buttonText = btn_dec.Text + 1;
            //string buttonClass = btn_dec.CssClass + 1;
            //btn_dec.Attributes.Add("class", "buttonClass");

            ////(FindControl(buttonId) as Button).Enabled = false;
            //Button tb1 = (Button)FindControl(btn_dec);
            //tb1.Enabled = false;
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "hideModal();", true);
        //FillLeaveRequests(Convert.ToInt32(ddlRepManager.SelectedValue.ToString()));
        ScriptManager.RegisterStartupScript(this, this.GetType(), "show", "toastD();", true);
        FillLeaveRequests(Convert.ToInt32(ddlRepManager.SelectedValue.ToString()));
        Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.success('Request Declined.', 'Success')", true);
        fillddlRepManager();
        
    }
}