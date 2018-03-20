using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml.Linq;
using CD;
public partial class MasterPage : System.Web.UI.MasterPage
{


    DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            intialize_me();
        }
    }



    protected void intialize_me()
    {
        try
        {
            dt = (DataTable)Session["dtEmp"];
            if (dt.Rows.Count > 0)
            {
                DataRow dr = dt.Rows[0];
                lblName.Text = dr["First_Name"] + " " + dr["Last_Name"];
                lblNameDesignation.Text = dr["First_Name"] + " " + dr["Last_Name"] + " - " + dr["DesignationId"];
                lblDOJ.Text = Convert.ToDateTime(dr["DOJ"].ToString()).ToString("dd-MMM-yyyy");
                string UserImageURI = "~/Sitel/user_images/" + dr["UserImage"];
                mediumUserImage.ImageUrl = UserImageURI;
                smallUserImage.ImageUrl = UserImageURI;
                fillrptrImpersonator();
            }

        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }
    }

    private void fillrptrImpersonator()
    {
        Helper my = new Helper();
        string strSQL = "Select distinct  A.Skillset from [WFMPMS].[tblDsgn2KPIWtg] A ";
        strSQL += " where A.SkillsetId <> 5 ";
        strSQL += " union select distinct A.Skillset + '-Manager' as Skillset from[WFMPMS].[tblDsgn2KPIWtg] A";
        strSQL += " where A.SkillsetId <> 5 ";
        DataTable dt = my.GetData(strSQL);
        rptrImpersonator.DataSource = dt;
        rptrImpersonator.DataBind();

    }
}
