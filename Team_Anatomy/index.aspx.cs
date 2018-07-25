using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;

public partial class index : System.Web.UI.Page
{
    Helper my = new Helper();
    private string myID { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.UrlReferrer != null)
        {
            ViewState["PreviousPageUrl"] = Request.UrlReferrer.ToString();
        }

        if (Request.QueryString["q"] != null)
        {
            string skillset = Request.QueryString["q"].ToString();
            myID = getMyImpersonatorsNTID(skillset);
            RedirectBasedOnNTNameLookup(myID);
        }
        else
        {
            myID = PageExtensionMethods.getMyWindowsID().ToString();
            RedirectBasedOnNTNameLookup(myID);
        }

    }

    private void RedirectBasedOnNTNameLookup(string myID)
    {

        DataTable dt = new DataTable();
        if (myID != "IDNotFound")
        {
            myID = "ctirt002"; // pgora001 atike001 Pdsou014 vchoh001 mchau006 ykand001// RTA Vinod Chauhan sbodh001 vfern016  fjaya001 smerc021  vpere018 Pdsou014  nrodr058  mshai066

            SqlCommand cmd = new SqlCommand("WFMP.getEmployeeData");
            //myID = "pgora001";//to login as other userk slall002  rshar030 nchan016 utiwa002  aansa012 paloz001 pjite001 g.001 adube010 utiwa002 avish001 vshir001
            cmd.Parameters.AddWithValue("@NT_ID", myID);

            try
            {
                dt = my.GetDataTableViaProcedure(ref cmd);
                if (dt != null && dt.Rows.Count > 0)
                {

                    Session["dtEmp"] = dt;
                    Response.Redirect("ninebox.aspx", false);
                }
                else
                {
                    // Every page in the application will use the session 'myID' as the NTName of the unauthorized user.
                    Session["myID"] = myID;
                    Response.Redirect("lockscreen.aspx", false);
                }
            }
            catch (Exception Ex)
            {
                Response.Write(Ex.Message);
            }
        }
        else
        {
            Response.Redirect("lockscreen.aspx", false);
        }


    }
    private string getMyImpersonatorsNTID(string QueryString)
    {
        //myID = PageExtensionMethods.getMyWindowsID().ToString();
        string myID = Request.QueryString["q"].ToString();
        return myID;
    }
}