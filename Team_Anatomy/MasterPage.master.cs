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

public partial class MasterPage : System.Web.UI.MasterPage
{

    string myID;
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
            myID = PageExtensionMethods.getMyWindowsID().ToString();
            string constr = ConfigurationManager.ConnectionStrings["constr"].ToString();

            using (SqlConnection cn = new SqlConnection(constr))
            {
                cn.Open();
                string strSQL = "Exec WFMP.getEmployeeData @NT_ID = " + myID;
                using (SqlDataAdapter a = new SqlDataAdapter(strSQL, cn))
                {
                    a.Fill(dt);
                }
            }
            DataRow dr = dt.Rows[0];

            lblName.Text = dr["First_Name"] + " " + dr["Last_Name"];
            lblNameDesignation.Text = dr["First_Name"] + " " + dr["Last_Name"] + " - " + dr["DesignationId"];
            lblDOJ.Text = Convert.ToDateTime(dr["DOJ"].ToString()).ToString("dd-MMM-yyyy");
            string UserImageURI = "~/Sitel/user_images/" + dr["UserImage"];
            mediumUserImage.ImageUrl = UserImageURI;
            smallUserImage.ImageUrl = UserImageURI;

        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }



    }





}
