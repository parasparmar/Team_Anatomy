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
                //Request.UrlReferrer.ToString();
        }
        myNTID = PageExtensionMethods.getMyWindowsID().ToString();
        empCode = PageExtensionMethods.getMyEmployeeID();
        if (Request.QueryString["ex"] != null)
        {
            pnlError.Visible = true;
            pnlSuccess.Visible = false;
            errorID = Request.QueryString["ex"].ToString();
            lnkFlag4Followup.NavigateUrl = "mailto:support_iaccess@sitel.com?subject=PACMAN%20Issue%20%3A%20" + errorID + "&body=Hi%20Team%2C%0APlease%20help%20me%20with%20my%20PACMAN%20Issue%20logged%20today%20with%20ID%20%3A%20" + errorID + "%0AMy%20Login%20ID%20is%20%3A%20" + myNTID + "%0AMy%20Emp%20Code%20is%20%3A%20" + empCode;
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
            SqlCommand cmd = new SqlCommand("setErrorLog");
            cmd.Parameters.AddWithValue("@ErrorID", errorID);            
            cmd.Parameters.AddWithValue("@FollowUpFlag", 1);
            my.ExecuteDMLCommand(ref cmd, "", "S");
            btnErrorMessage.Text = "Follow Up Initiated for Issue : " + errorID;
            btnErrorMessage.Enabled = false;
            btnErrorMessage.CssClass = "btn btn-success";
            resetLinks();            
        }
        else
        {
            
        }
    }

    protected void resetLinks()
    {
        errorID = string.Empty;
        lnkFlag4Followup.NavigateUrl = "mailto:support_iaccess@sitel.com?subject=PACMAN%20Issue%20%3A%20&body=Hi%20Team%2C%0APlease%20help%20me%20with%20my%20PACMAN%20Issue%20logged%20today%20with%20ID%20%3A%20%0AMy%20Login%20ID%20is%20%3A%20" + myNTID + "%0AMy%20Emp%20Code%20is%20%3A%20" + empCode;
        lnkFlag4Followup.Text = "Email for Support";
        btnErrorMessage.Enabled = false;
        btnErrorMessage.Visible = false;
        btnErrorMessage.CssClass = "btn btn-danger";

    }

    protected void throwException()
    {
        throw new OverflowException("PACMAN", new Exception("This is a test Exception raised for the 404 module"));
    }

    protected void lnkRetry_Click(object sender, EventArgs e)
    {
        
        Response.Redirect(PreviousPageUrl);
    }
}