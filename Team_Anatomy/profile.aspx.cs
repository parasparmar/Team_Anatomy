using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;

public partial class profile : System.Web.UI.Page
{
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
            string myID = PageExtensionMethods.getMyWindowsID().ToString();
            lblNTID.Text = myID;
            Helper my = new Helper();
            //DataTable dt = my.GetData("Select top 1 * from cwfm_umang..WFM_Employee_List where NT_ID = '" + myID + "'");
            DataTable dt = my.GetData("Exec TA.getEmployeeData '" + myID + "'");
            DataRow dr = dt.Rows[0];
            lblEmployee_ID.Text = dr["Employee_ID"].ToString();
            string FullName = dr["First_Name"].ToString() + " " + dr["Middle_Name"].ToString() + " " + dr["Last_Name"].ToString();
            lblName.Text = FullName;
            lblDesignation.Text = dr["Designation"].ToString();
            lblDepartment.Text = dr["Department"].ToString() + "-" + dr["Sub_Department"].ToString();
            lblDOJ.Text = dr.Field<DateTime>("Date_of_Joining").ToString("dd-MMMM-yyyy");
            lblEmailID.Text = dr["Email_id"].ToString();
            lblContactNumber.Text = dr["Contact_Number"].ToString();
            if (dr["UserImage"].ToString().Length > 3)
            {
                imgbtnProfilePhoto.ImageUrl = "/sitel/user_images/" + dr["UserImage"].ToString();
            }
            lblSupervisor.Text = dr["Supervisor"].ToString();
            lblEmployee_Role.Text = dr["Employee_Role"].ToString();
            lblEmployee_Type.Text = dr["Employee_Type"].ToString();
            lblEmployee_Status.Text = dr["Employee_Status"].ToString();
            lblUpdate_Date.Text = dr["Update_Date"].ToString();
            lblUpdated_by.Text = dr["Updated_by"].ToString();
            lblSite.Text = dr["Site"].ToString();

            tbGender.SelectedValue = dr["Gender"].ToString();
            //tbDate_of_Birth.Text = Convert.ToDateTime(dr["Date_of_Birth"]).ToString("dd-MMM-yyyy");
        }
        catch (Exception Ex) {
            Response.Write(Ex.Message);
        }
    }



}