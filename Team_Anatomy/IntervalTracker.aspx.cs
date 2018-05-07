
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;

public partial class IntervalTracker : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    string strSQL;
    int MyEmpID;
    string reportee { get; set; }
    //string pacmancycle { get; set; }


    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();
        try
        {
            dtEmp = (DataTable)Session["dtEmp"];
            if (dtEmp.Rows.Count <= 0)
            {
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            else
            {
                MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
            }

        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }

        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Interval Tracker";

        if (!IsPostBack)
        {
            fillddlInterval();
            fillddlAccount();
            fillddlLOB();
            filllbSites();
            fillgvDowntimeLog();
        }
    }

    private void fillddlAccount()
    {
        string strSQL = "[WFMP].[fillEmployeeAccounts]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        if (dt1!= null && dt1.Rows.Count > 0)
        {
            
            ddlAccount.DataSource = dt1;
            ddlAccount.DataTextField = "Account";
            ddlAccount.DataValueField = "PrimaryClientID";
            ddlAccount.DataBind();
        }
        else
        {
            //ddlAccount.DataSource = dt1;
            ddlAccount.DataTextField = "No-Account";
            // ddlAccount.DataValueField = "0";
            //ddlAccount.DataValueField = "PrimaryClientID"; 
            Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.warning('Currently no accounts are mapped to you. For more support kindly contact iAccess team.')", true);
        }
    }
    protected void ddlAccount_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillddlLOB();
        filllbSites();
    }

    private void fillddlLOB()
    {
        //string Account = ddlAccount.SelectedItem.Value.ToString();

        string Account = ddlAccount.SelectedValue.ToString();
            string strSQL = "[WFMP].[fillAccountLOB]";
            SqlCommand cmd = new SqlCommand(strSQL);
            cmd.Parameters.AddWithValue("@Account", Account);
            DataTable dt = my.GetDataTableViaProcedure(ref cmd);
            ddlLOB.DataSource = dt;
            ddlLOB.DataTextField = "LOB";
            ddlLOB.DataValueField = "LOB";
            ddlLOB.DataBind();
    }

    private void filllbSites()
    {
        //string Account = ddlAccount.SelectedItem.Value.ToString();
        string Account = ddlAccount.SelectedValue.ToString();
        string strSQL = "[WFMP].[fillSites]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@AccountID", Account);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        lbSites.DataSource = dt;
        lbSites.DataTextField = "site";
        lbSites.DataValueField = "site";
        lbSites.DataBind();
    }

    private void fillddlInterval()
    {
        string strSQL = "[WFMP].[fillInterval]";
        SqlCommand cmd = new SqlCommand(strSQL);
        //cmd.Parameters.AddWithValue("@AccountID", Account);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlInterval.DataSource = dt;
        ddlInterval.DataTextField = "Interval";
        ddlInterval.DataValueField = "TimePeriod";
        ddlInterval.DataBind();
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(my.getConnectionString());
        con.Open();

        String strSQL = "[WFMP].[InsertIntervalTracker]";
        SqlCommand cmd = new SqlCommand(strSQL, con);
        cmd.CommandType = CommandType.StoredProcedure;

        DateTime Date;
        if (!DateTime.TryParse(tbDate.Text.ToString(), out Date)) { tbDate.Text = "Not a Date"; }

        DateTime interval = Convert.ToDateTime(ddlInterval.SelectedItem.Value.ToString());//
        string AccountID = ddlAccount.SelectedItem.Value.ToString();
        string lob = ddlLOB.SelectedItem.Value.ToString();

        string items = string.Empty;
        foreach (ListItem i in lbSites.Items)
        {
            if (i.Selected == true)
            {
                items += i.Value + ",";
            }
        }
        string sites = items.TrimEnd(',');

        string issue = txtIssue.Text.ToString();
        string incidentType = ddlIncident.SelectedItem.Text.ToString();//
        string clientTicket = txtClientTicket.Text.ToString();
        string sitelTicket = txtSitelTicket.Text.ToString();

        string folderPath = Server.MapPath("~/Sitel/mails/");
        string fileName = Path.GetFileName(AttachIssueMail.FileName);
        AttachIssueMail.SaveAs(folderPath + Path.GetFileName(AttachIssueMail.FileName));
        string Attachment = "Sitel/mails/" + fileName;

        if (DateTime.TryParse(tbDate.Text, out Date))
        {
            cmd.Parameters.AddWithValue("@Date", Date);
        }
        cmd.Parameters.AddWithValue("@Interval", interval);
        cmd.Parameters.AddWithValue("@Account", AccountID);
        cmd.Parameters.AddWithValue("@LOB", lob);
        cmd.Parameters.AddWithValue("@Sites", sites);
        cmd.Parameters.AddWithValue("@Issue", issue);
        cmd.Parameters.AddWithValue("@IncidentType", incidentType);
        cmd.Parameters.AddWithValue("@ClientTicket", clientTicket);
        cmd.Parameters.AddWithValue("@SitelTicket", sitelTicket);
        cmd.Parameters.AddWithValue("@Attachment", Attachment);
        cmd.Parameters.AddWithValue("@ActionBy", MyEmpID);
        
        cmd.Connection = con;
        cmd.ExecuteNonQuery();
        con.Close();
        clearfields();
        fillgvDowntimeLog();
    }

    private void clearfields() {
        ddlInterval.ClearSelection();
        ddlAccount.ClearSelection();
        //ddlLOB.ClearSelection();
        lbSites.ClearSelection();
        txtIssue.Text = string.Empty;
        tbDate.Text = string.Empty;
        ddlIncident.ClearSelection();
        txtClientTicket.Text = string.Empty;
        txtSitelTicket.Text = string.Empty;
        AttachIssueMail.Attributes.Clear();
        fillddlLOB();
    }
    protected void btnDiscardEsc_Click(object sender, EventArgs e)
    {
        clearfields();
    }

    private void fillgvDowntimeLog()
    {
        strSQL = "[WFMP].[GetIntervalTracker]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        DataTable dt3 = my.GetDataTableViaProcedure(ref cmd);

        string[] filePaths = Directory.GetFiles(Server.MapPath("Sitel/mails/"));
        //string[] filePaths1 = Directory.GetFiles("Sitel/mails/");
        List<ListItem> files = new List<ListItem>();

        foreach (string filePath in filePaths)
        {

            files.Add(new ListItem(Path.GetFileName(filePath), filePath));

        }

        gvDowntimeLog.DataSource = dt3;
        gvDowntimeLog.DataBind();

    }

    protected void lbDownload_Click(object sender, EventArgs e)
    {
        string filePath = (sender as LinkButton).CommandArgument;

        Response.ContentType = ContentType;

        Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(filePath));

        Response.WriteFile(filePath);

        Response.End();
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

    protected void ddlIncident_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlIncident.SelectedItem.Value == "3")
        {
            txtClientTicket.Text = "0";
            txtSitelTicket.Text = "0";
            txtClientTicket.Enabled = false;
            txtSitelTicket.Enabled = false;
        }
        else
        {
            txtClientTicket.Enabled = true;
            txtSitelTicket.Enabled = true;
            txtClientTicket.Text = string.Empty;
            txtSitelTicket.Text = string.Empty;
        }
    }
}