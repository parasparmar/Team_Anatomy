using System;
using System.Collections;
using System.Configuration;
using System.Data;
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

            EmployeeTableAdapters.dtaEmployee dtaEmp = new EmployeeTableAdapters.dtaEmployee();
            Employee.dtEmployeeDataTable dtEmp = new Employee.dtEmployeeDataTable();
            dtaEmp.Fill(dtEmp, myID);            
            Employee.dtEmployeeRow dr = (Employee.dtEmployeeRow)dtEmp.Rows[0];
            lblName.Text = dr.First_Name + " " + dr.Last_Name;
            lblNameDesignation.Text = dr.First_Name + " " + dr.Last_Name + " - " + dr.Designation;
            lblDOJ.Text = dr.Date_of_Joining.ToString("dd-MMM-yyyy");
            string UserImageURI = "~/Sitel/user_images/" + dr.UserImage;
            mediumUserImage.ImageUrl = UserImageURI;
            smallUserImage.ImageUrl = UserImageURI;

        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }



    }




    
}
