using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class _404 : System.Web.UI.Page
{
    public string errorID { get; set; }
    public string myNTID { get; set; }
    public int empCode { get; set; }
    public string PreviousPageUrl { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.UrlReferrer != null)
        {
            PreviousPageUrl = Request.UrlReferrer.ToString();
        }
        myNTID = PageExtensionMethods.getMyWindowsID().ToString();
        empCode = PageExtensionMethods.getMyEmployeeID();
        if (PageExtensionMethods.AmIAllowedThisPage(empCode, HttpContext.Current.Request.Url.AbsolutePath))
        {
            testPanel.Visible = true;
        }
        else
        {
            testPanel.Visible = false;
        }

        if (Request.QueryString["ex"] != null)
        {
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
            errorID = Request.QueryString["ex"].ToString();
            lnkFlag4Followup.OnClientClick = "window.location.href = 'mailto:support_iaccess@sitel.com?subject=PACMAN%20Issue%20%3A%20" + errorID + "&body=Hi%20Team%2C%0APlease%20help%20me%20with%20my%20PACMAN%20Issue%20logged%20today%20with%20ID%20%3A%20" + errorID + "%0AMy%20Login%20ID%20is%20%3A%20" + myNTID + "%0AMy%20Emp%20Code%20is%20%3A%20" + empCode + "'";
            lnkFlag4Followup.Text.Replace("Support_Iaccess@Sitel.com", "Support_Iaccess@Sitel.com with ID : " + errorID);
            btnErrorMessage.CommandName = "FollowUp";
            btnErrorMessage.CommandArgument = errorID;
            btnErrorMessage.Visible = true;
            btnErrorMessage.Enabled = true;
            btnErrorMessage.Text = "Kindly Followup on this error!";
        }
        else
        {
            resetLinks();
            pnlError.Visible = false;
            pnlSuccess.Visible = true;
        }
    }

    protected void btnErrorMessage_Click(object sender, EventArgs e)
    {
        errorID = btnErrorMessage.CommandArgument.ToString();
        if (errorID.Length > 0)
        {
            Helper my = new Helper();
            SqlCommand cmd = new SqlCommand("setFollowUpOnError");
            cmd.Parameters.AddWithValue("@ErrorID", errorID);            
            int i = my.ExecuteDMLCommand(ref cmd, "", "S");
            btnErrorMessage.Text = "Follow Up Initiated for Issue : " + errorID;
            btnErrorMessage.Enabled = false;
            btnErrorMessage.CssClass = "btn btn-success";
            resetLinks();
        }        
    }

    protected void resetLinks()
    {
        errorID = string.Empty;
        lnkFlag4Followup.OnClientClick = "window.location.href = 'mailto:support_iaccess@sitel.com?subject=PACMAN%20Issue%20%3A%20&body=Hi%20Team%2C%0APlease%20help%20me%20with%20my%20PACMAN%20Issue%20logged%20today%20with%20ID%20%3A%20%0AMy%20Login%20ID%20is%20%3A%20" + myNTID + "%0AMy%20Emp%20Code%20is%20%3A%20" + empCode + "'";
        lnkFlag4Followup.Text = "Email for Support";
        btnErrorMessage.Enabled = false;
        btnErrorMessage.Visible = false;
        btnErrorMessage.CssClass = "btn btn-danger";

    }


    protected void lnkRetry_Click(object sender, EventArgs e)
    {

        Response.Redirect(PreviousPageUrl);
    }

    protected void ddlExceptionType_SelectedIndexChanged(object sender, EventArgs e)
    {
        string exType = ddlExceptionType.SelectedValue;

        switch (exType)
        {
            case "InvalidOperationException":
                InvalidOperationException ioe = new InvalidOperationException("This is a test.");
                throw ioe;
            case "ArgumentException":
                ArgumentException ae = new ArgumentException("This is a test.");
                throw ae;
            case "NullReferenceException":
                NullReferenceException ne = new NullReferenceException("This is a test.");
                throw ne;
            case "AccessViolationException":
                AccessViolationException ave = new AccessViolationException("This is a test.");
                throw ave;
            case "IndexOutOfRangeException":
                IndexOutOfRangeException iore = new IndexOutOfRangeException("This is a test.");
                throw iore;
            case "StackOverflowException":
                StackOverflowException soe = new StackOverflowException("This is a test.");
                throw soe;
            default:
                throw new Exception("This is a test.");
        }

    }
}