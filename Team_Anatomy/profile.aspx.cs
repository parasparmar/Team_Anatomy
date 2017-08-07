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
            Session["Employee_Datatable"] = dtEmp;
            Session["myID"] = myID;
            Employee.dtEmployeeRow dr = (Employee.dtEmployeeRow)dtEmp.Rows[0];




            //Helper my = new Helper();
            //DataTable dt = my.GetData("Select top 1 * from cwfm_umang..WFM_Employee_List where NT_ID = '" + myID + "'");
            //DataTable dt = my.GetData("Exec TA.getEmployeeData '" + myID + "'");

            //DataRow dr = dt.Rows[0];

            lblNTID.Text = myID;
            lblEmployee_ID.Text = dr.Employee_ID.ToString();  //dr["Employee_ID"].ToString();
            lblName.Text = dr.First_Name + " " + dr.Middle_Name + " " + dr.Last_Name; // dr["First_Name"].ToString() + " " + dr["Middle_Name"].ToString() + " " + dr["Last_Name"].ToString();
            lblDesignation.Text = dr.Designation; // dr["Designation"].ToString();
            lblDepartment.Text = dr.Department + " - " + dr.Sub_Department; //dr["Department"].ToString() + "-" + dr["Sub_Department"].ToString();
            lblDOJ.Text = dr.Date_of_Joining.ToString("dd-MMMM-yyyy"); //dr.Field<DateTime>("Date_of_Joining").ToString("dd-MMMM-yyyy");
            lblEmailID.Text = dr.Email_id; //dr["Email_id"].ToString();
            lblContactNumber.Text = dr.Contact_Number;  //dr["Contact_Number"].ToString();
            if (!dr.IsUserImageNull())
            {
                imgbtnProfilePhoto.ImageUrl = "/sitel/user_images/" + dr.UserImage;
            }
            lblSupervisor.Text = dr.Supervisor; //dr["Supervisor"].ToString();
            lblEmployee_Role.Text = dr.Employee_Role; // dr["Employee_Role"].ToString();
            lblEmployee_Type.Text = dr.Employee_Type; dr["Employee_Type"].ToString();
            lblEmployee_Status.Text = dr.Employee_Status; // dr["Employee_Status"].ToString();
            lblUpdate_Date.Text = dr.IsUpdate_DateNull() ? string.Empty : dr.Update_Date.ToString("dd-MMMM-yyyy HH:mm"); //dr["Update_Date"].ToString();
            lblUpdated_by.Text = dr.Updated_by;
            lblSite.Text = dr.Site;
            /////---------------Personal Section 
            tbGender.SelectedValue = dr.Gender;
            tbDate_of_Birth.Text = dr.IsDate_of_BirthNull() ? string.Empty : dr.Date_of_Birth.ToString("dd-MMMM-yyyy");
            tbHighest_Qualification.Text = dr.Highest_Qualificatin;
            tbMarital_Status.Text = dr.Marital_Status;
            tbAnniversary_Date.Text = dr.IsAnniversary_DateNull() ? string.Empty : dr.Anniversary_Date.ToString("dd-MMM-yyyy");
            tbContact_Number.Text = dr.Contact_Number;
            tbAlternate_Contact.Text = dr.Alternate_Contact;
            tbEmail_id.Text = dr.Email_id;
            /////---------------Transport Section 
            tbTransport_User.Text = dr.Transport_User;
            tbAddress_Line_1.Text = dr.Address_Line_1;
            tbAddress_Line_2.Text = dr.Address_Line_2;
            tbAddress_Landmark.Text = dr.Address_Landmark;
            tbAddress_City.Text = dr.Address_City;
            tbAddress_Country.Text = dr.Address_Country;
            tbPermanent_Address_City.Text = dr.Permanent_Address_City;
            /////---------------Work Experience
            tbTotal_Work_Experience.Text = dr.Total_Work_Experience;
            tbSkill_Set_1.Text = dr.Skill_Set_1;
            tbSkill_Set_2.Text = dr.Skill_Set_2;
            tbSkill_Set_3.Text = dr.Skill_Set_3;





        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }



    }



    protected void btnPersonalSubmit_Click(object sender, EventArgs e)
    {
        myID = Session["myID"].ToString();
        EmployeeTableAdapters.dtaEmployee dtaEmp = new EmployeeTableAdapters.dtaEmployee();
        Employee.dtEmployeeDataTable dtEmp = (Employee.dtEmployeeDataTable)Session["Employee_Datatable"];
        Employee.dtEmployeeRow dr = (Employee.dtEmployeeRow)dtEmp.Rows[0];

        //string NT_ID = dr.NT_ID;
        //int Employee_ID = Convert.ToInt32(dr.Employee_ID);
        //string First_Name = dr.First_Name;
        //string Middle_Name = dr.Middle_Name;
        //string Last_Name = dr.Last_Name;
        //string Gender = tbGender.SelectedItem.ToString();
        //DateTime Date_of_Birth = Convert.ToDateTime(tbDate_of_Birth.Text);
        //string Marital_Status = tbMarital_Status.SelectedItem.ToString();
        //DateTime Anniversary_Date = Convert.ToDateTime(tbAnniversary_Date.Text);
        //string Address_Country = tbAddress_Country.Text;
        //string Address_City = tbAddress_City.Text;
        //string Address_Line_1 = tbAddress_Line_1.Text;
        //string Address_Line_2 = tbAddress_Line_2.Text;
        //string Address_Landmark = tbAddress_Landmark.Text;
        //string Permanent_Address_City = tbPermanent_Address_City.Text;
        //string Contact_Number = tbContact_Number.Text;
        //string Alternate_Contact = tbAlternate_Contact.Text;
        //string Email_id = tbEmail_id.Text;
        //string Transport_User = tbTransport_User.SelectedItem.ToString();
        //string Country = tbAddress_Country.Text;
        //string City = tbAddress_City.Text;
        //string Site = dr.Site;
        //string Department = dr.Department;
        //string Sub_Department = dr.Sub_Department;
        //string Designation = dr.Designation;
        //string Supervisor = dr.Supervisor;
        //DateTime Date_of_Joining = dr.Date_of_Joining;
        //string Employee_Role = dr.Employee_Role;
        //string Employee_Type = dr.Employee_Type;
        //string Employee_Status = dr.Employee_Status;
        //string Total_Work_Experience = tbTotal_Work_Experience.Text;
        //string Highest_Qualificatin = tbHighest_Qualification.Text;
        //string Skill_Set_1 = tbSkill_Set_1.Text;
        //string Skill_Set_2 = tbSkill_Set_2.Text;
        //string Skill_Set_3 = tbSkill_Set_3.Text;
        //string Updated_by = myID;
        //DateTime Update_Date = DateTime.Now;
        //string Supervisor_ECN = dr.Supervisor_ECN;
        //string UserImage = dr.UserImage;

        dr.Gender = tbGender.SelectedItem.ToString();
        dr.Date_of_Birth = Convert.ToDateTime(tbDate_of_Birth.Text);
        dr.Marital_Status = tbMarital_Status.SelectedItem.ToString();
        dr.Anniversary_Date = Convert.ToDateTime(tbAnniversary_Date.Text);
        dr.Address_Country = tbAddress_Country.Text;
        dr.Address_City = tbAddress_City.Text;
        dr.Address_Line_1 = tbAddress_Line_1.Text;
        dr.Address_Line_2 = tbAddress_Line_2.Text;
        dr.Address_Landmark = tbAddress_Landmark.Text;
        dr.Permanent_Address_City = tbPermanent_Address_City.Text;
        dr.Contact_Number = tbContact_Number.Text;
        dr.Alternate_Contact = tbAlternate_Contact.Text;
        dr.Email_id = tbEmail_id.Text;
        dr.Transport_User = tbTransport_User.SelectedItem.ToString();
        dr.Country = tbAddress_Country.Text;
        dr.City = tbAddress_City.Text;
        dr.Total_Work_Experience = tbTotal_Work_Experience.Text;
        dr.Highest_Qualificatin = tbHighest_Qualification.Text;
        dr.Skill_Set_1 = tbSkill_Set_1.Text;
        dr.Skill_Set_2 = tbSkill_Set_2.Text;
        dr.Skill_Set_3 = tbSkill_Set_3.Text;
        dr.Updated_by = myID;
        dr.Update_Date = DateTime.Now;
        dr.UserImage = dr.UserImage;

        //string the_Procedure = "TA.updateEmployeeProfileData";
        //Helper my = new Helper();
        try
        {
            //SqlCommand cmd = new SqlCommand(the_Procedure);
            //cmd.Parameters.AddWithValue("@Employee_ID", Employee_ID);
            //cmd.Parameters.AddWithValue("@NT_ID", NT_ID);
            //cmd.Parameters.AddWithValue("@First_Name", First_Name);
            //cmd.Parameters.AddWithValue("@Middle_Name", Middle_Name);
            //cmd.Parameters.AddWithValue("@Last_Name", Last_Name);
            //cmd.Parameters.AddWithValue("@Gender", Gender);
            //cmd.Parameters.AddWithValue("@Date_of_Birth", Date_of_Birth);
            //cmd.Parameters.AddWithValue("@Marital_Status", Marital_Status);
            //cmd.Parameters.AddWithValue("@Anniversary_Date", Anniversary_Date);
            //cmd.Parameters.AddWithValue("@Address_Country", Address_Country);
            //cmd.Parameters.AddWithValue("@Address_City", Address_City);
            //cmd.Parameters.AddWithValue("@Address_Line_1", Address_Line_1);
            //cmd.Parameters.AddWithValue("@Address_Line_2", Address_Line_2);
            //cmd.Parameters.AddWithValue("@Address_Landmark", Address_Landmark);
            //cmd.Parameters.AddWithValue("@Permanent_Address_City", Permanent_Address_City);
            //cmd.Parameters.AddWithValue("@Contact_Number", Contact_Number);
            //cmd.Parameters.AddWithValue("@Alternate_Contact", Alternate_Contact);
            //cmd.Parameters.AddWithValue("@Email_id", Email_id);
            //cmd.Parameters.AddWithValue("@Transport_User", Transport_User);
            //cmd.Parameters.AddWithValue("@Country", Country);
            //cmd.Parameters.AddWithValue("@City", City);
            //cmd.Parameters.AddWithValue("@Site", Site);
            //cmd.Parameters.AddWithValue("@Department", Department);
            //cmd.Parameters.AddWithValue("@Sub_Department", Sub_Department);
            //cmd.Parameters.AddWithValue("@Designation", Designation);
            //cmd.Parameters.AddWithValue("@Supervisor", Supervisor);
            //cmd.Parameters.AddWithValue("@Date_of_Joining", Date_of_Joining);
            //cmd.Parameters.AddWithValue("@Employee_Role", Employee_Role);
            //cmd.Parameters.AddWithValue("@Employee_Type", Employee_Type);
            //cmd.Parameters.AddWithValue("@Employee_Status", Employee_Status);
            //cmd.Parameters.AddWithValue("@Total_Work_Experience", Total_Work_Experience);
            //cmd.Parameters.AddWithValue("@Highest_Qualificatin", Highest_Qualificatin);
            //cmd.Parameters.AddWithValue("@Skill_Set_1", Skill_Set_1);
            //cmd.Parameters.AddWithValue("@Skill_Set_2", Skill_Set_2);
            //cmd.Parameters.AddWithValue("@Skill_Set_3", Skill_Set_3);
            //cmd.Parameters.AddWithValue("@Updated_by", Updated_by);
            //cmd.Parameters.AddWithValue("@Update_Date", Update_Date);
            //cmd.Parameters.AddWithValue("@Supervisor_ECN", Supervisor_ECN);
            //cmd.Parameters.AddWithValue("@UserImage", UserImage);

            dtaEmp.Update(dr);

            //dtaEmp.Update(Employee_ID, NT_ID, First_Name, Middle_Name, Last_Name, Gender, Date_of_Birth, Marital_Status, Anniversary_Date, Address_Country
            //    , Address_City, Address_Line_1, Address_Line_2, Address_Landmark, Permanent_Address_City, Contact_Number, Alternate_Contact, Email_id
            //    , Transport_User, Country, City, Site, Department, Sub_Department, Designation, Supervisor, Date_of_Joining, Employee_Role, Employee_Type
            //    , Employee_Status, Total_Work_Experience, Highest_Qualificatin, Skill_Set_1, Skill_Set_2, Skill_Set_3, Updated_by, Update_Date
            //    , Supervisor_ECN, UserImage);
                
            //my.ExecuteDMLCommand(ref cmd, the_Procedure, "S");

        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }

    }
}